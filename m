Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbYFAV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbYFAV3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752442AbYFAV3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:29:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51049 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYFAV3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:29:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [RFC 3/7] cramfs: allow unlinking of files
Date: Sun, 1 Jun 2008 23:28:57 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
References: <20080531152013.031903990@arndb.de> <20080531153510.820446949@arndb.de> <20080601165439.GD13094@logfs.org>
In-Reply-To: <20080601165439.GD13094@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806012328.57577.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/JScBazHwVpIjhbyRYYQVHDATLiPEnjOCSWH+
 n4sIb9K7zTaELU8pzz2Dg69dsoh6XHug12RPdqRk8udvfo4VZb
 Vuf29BwtBKCPREbJNcVng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008, Jörn Engel wrote:
> On Sat, 31 May 2008 17:20:16 +0200, arnd@arndb.de wrote:
> >  
> > +int cramfs_unlink(struct inode *dir, struct dentry *dentry)
> > +{
> > +     struct inode *inode = dentry->d_inode;
> > +     struct dentry *new;
> > +
> > +     inode->i_ctime = dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> > +     drop_nlink(inode);
> > +     new = d_alloc(dentry->d_parent, &dentry->d_name);
> > +     d_add(new, NULL);
> > +
> > +     dget(dentry);
> 
> How is the negative dentry dropped on umount?  Looks like we want a
> per-sb list to put them on.  Then we can walk it and dput each one at
> umount time.

Good point. I think ramfs does exactly that, using kill_litter_super.
I haven't tested unmount so far, and should probably do something like
that in cramfs_put_super.

	Arnd <><

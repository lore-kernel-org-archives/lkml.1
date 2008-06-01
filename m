Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYFAVZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYFAVZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 17:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbYFAVZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 17:25:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:53127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYFAVZE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:25:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [RFC 2/7] cramfs: create unique inode numbers
Date: Sun, 1 Jun 2008 23:24:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de
References: <20080531152013.031903990@arndb.de> <20080531153510.692084580@arndb.de> <20080601165048.GC13094@logfs.org>
In-Reply-To: <20080601165048.GC13094@logfs.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200806012324.51734.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19UykgePfPq0SIkHgR8+0BMe3b8+CmWJa7N7Th
 IUwfeRyxKnMcKyFoSo3s253r1eF2hYjU6s0xSnqZKTg5kvfeP3
 ZBdvvKKMbKfKSa9q9SDTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008, Jörn Engel wrote:
> On Sat, 31 May 2008 17:20:15 +0200, arnd@arndb.de wrote:
> > 
> > This changes the inode number in cramfs to be based on
> > the location of the dentry instead of the file, in order
> > to make inodes unique.
> 
> Couldn't this cause problems for NFS?  The same inode no longer has a
> stable inode number across reboots.  Basing on dentry location can also
> be an information leak and cause problems on 64bit machines with old
> userspace.

Sorry if I was not clear with this: I meant dentry location on disk,
not in memory. So the inode number is still stable across reboots and
does not leak data, it is just different from before.

> We could keep the original approach and use a static counter otherwise.
> Something roughly like this:

One thing I like about my 2/7 patch is that it actually reduces the amount
of code in the file system, while your solution would increase it, with
otherwise identical behaviour.

	Arnd <><

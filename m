Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZESLzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZESLzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 07:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZESLzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 07:55:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZESLzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 07:55:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
Date: Tue, 19 May 2009 13:54:08 +0200
User-Agent: KMail/1.9.9
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       bharata@in.ibm.com, dwmw2@infradead.org, mszeredi@suse.cz,
       vaurora@redhat.com
References: <1242662968-11684-1-git-send-email-jblunck@suse.de> <E1M6Mez-0000tG-3q@pomaz-ex.szeredi.hu> <20090519103924.GL16526@bolzano.suse.de>
In-Reply-To: <20090519103924.GL16526@bolzano.suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905191354.08701.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18zPBSVhAaxDbgtcUOTMxcPKzlVFKhkUrM0PzL
 cXkz0vPE6DJxkmGZmH1sTudzlRvIGYqmpRsL2hFn7scITAkXI/
 6yrhP53tWLNbzPE5fvFFQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 May 2009, Jan Blunck wrote:
> > So this means that the topmost branch always needs to be writable,
> > right?  It isn't possible to make a union of two iso9660 filesystems,
> > for example?
> 
> Exactly. Although, you can do that with the help of tmpfs on top of the two
> iso9660 filesystems.

But how do you get there? You can mount the tmpfs on top of two iso9660
file systems, but it seems that you wouldn't be able to get the two
stacked on top of each other in the first place.

Also, by mounting a tmpfs on top, wouldn't you you violate the requirement
for persistent inode numbers again?

> Or by adding fake write support to iso9660 ... 

This would work, but you'd have to do this for each file system if you want
to be able to use it as the top of the union while backed by a read-only
block device or when you don't want it to be written.

	Arnd <><

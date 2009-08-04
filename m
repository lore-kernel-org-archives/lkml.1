Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbZHDKjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbZHDKjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932796AbZHDKjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:39:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbZHDKj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:39:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/compat_ioctl.c: add missing FS_IOC_FIEMAP support
Date: Tue, 4 Aug 2009 12:39:17 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.2.98; x86_64; ; )
Cc: Mark Lord <lkml@rtr.ca>, sandeen@redhat.com, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, sandeen@sandeen.net
References: <4A74584D.2010300@rtr.ca> <4A775FB9.80600@rtr.ca> <20090803162255.c6d12eda.akpm@linux-foundation.org>
In-Reply-To: <20090803162255.c6d12eda.akpm@linux-foundation.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908041239.18238.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dsC6w5LPIXAkAxoiihj0o4wGLhOyoKNKQe34
 sF7jcSELhxWW61HGdI98JPebgjXJjTzgWG30+CngbreQ2krxsZ
 fXBm4fJM+GJZIe+X+Rfrw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 August 2009, Andrew Morton wrote:
> > Well, whichever of the two works best for the maintainers.
> > 
> > We need something for it upstream, and probably back in -stable too.
> > Otherwise this prevents using 64-bit kernels on 32-bit userland,
> > as Linus likes to recommend so often.  ;)
> 
> OK, here's what I have, with a somewhat reworked changelog.
> 
> I assumed that "Josef" == josef@redhat.com.
> 
> Arnd, could you please check that it still looks OK?

Yes, it looks ok as well. The #include is not needed here,
and the difference in compat_sys_ioctl() is that with Eric's
patch, a file system or device driver could in theory implement
its own compat handler for FS_IOC_FIEMAP while it cannot do
that for the native ioctl.

I would like to keep the logic in compat_sys_ioctl in sync with
do_vfs_ioctl, but they have diverged already. I have an experimental
patch set to rework compat_ioctl handling that will also take care
of this.

	Arnd <><

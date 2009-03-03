Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZCCVU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZCCVU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZCCVUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:20:18 -0500
Received: from cmpxchg.org ([85.214.51.133]:42696 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZCCVUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:20:17 -0500
Date: Tue, 3 Mar 2009 22:20:13 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scripts/unifdef.c:209: error: conflicting types for 'getline'
Message-ID: <20090303212013.GA22332@cmpxchg.org>
References: <dd18b0c30903031236t6ed1adaen64507b0ab4be34a4@mail.gmail.com> <49AD97BF.3050909@oracle.com> <dd18b0c30903031300w2144e9e7i64ab912542f3e42f@mail.gmail.com> <49AD9C11.60504@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD9C11.60504@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 01:07:29PM -0800, Randy Dunlap wrote:
> Justin Mattock wrote:
> > On Tue, Mar 3, 2009 at 12:49 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >> Justin Mattock wrote:
> >>> Hello;
> >>> I am unable to compile the kernel
> >>> (just did a git pull a few minuets ago);
> >>> here is what I see:
> >>>
> >>> WARNING: modpost: Found 1 section mismatch(es).
> >>> To see full details build your kernel with:
> >>> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>>   GEN     .version
> >>>   CHK     include/linux/compile.h
> >>>   UPD     include/linux/compile.h
> >>>   CC      init/version.o
> >>>   LD      init/built-in.o
> >>>   LD      .tmp_vmlinux1
> >>>   KSYM    .tmp_kallsyms1.S
> >>>    AS      .tmp_kallsyms1.o
> >>>   LD      .tmp_vmlinux2
> >>>   KSYM    .tmp_kallsyms2.S
> >>>   AS      .tmp_kallsyms2.o
> >>>   CHK     include/linux/version.h
> >>>   HOSTCC  scripts/unifdef
> >>> scripts/unifdef.c:209: error: conflicting types for 'getline'
> >>> /usr/include/stdio.h:651: note: previous declaration of 'getline' was here
> >>> make[2]: *** [scripts/unifdef] Error 1
> >>> make[1]: *** [__headers] Error 2
> >>> make: *** [vmlinux] Error 2
> >>>
> >>> The only change to .config was:
> >>>
> >>> SYSFS_DEPRECATED_V2 [=y]
> >>> to
> >>> SYSFS_DEPRECATED_V2 [=n]
> >>> to see if I can make udev from:
> >>>
> >>> udev: starting version 137
> >>> [    7.557317] udev: deprecated sysfs layout; update the kernel or disable
> >>> CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
> >>>
> >>> giving me this message.
> >>>
> >>> also I did use a CFLAGS when compiling,
> >>> but never received this when doing so for:
> >>> 2.6.29-rc5-00289-g460c133
> >>>
> >>> any info would be appreciated.
> >> What CFLAGS?  I can't reproduce the problem.
> >>
> >>
> >> --
> >> ~Randy
> >>
> > 
> > make CC=/usr/bin/i686-pc-linux-gnu-gcc-4.4.0 CFLAGS="-march=core2
> > -mtune=core2 -O2 -pipe -fomit-frame-pointer"
> > CXXFLAGS="${CFLAGS}" MAKEOPTS="-j3"
> 
> I still can't reproduce the problem by using those CFLAGS/CXXFLAGS.

chigurh:~/linux/linux-2.6/scripts$ make unifdef CFLAGS="-D_GNU_SOURCE"
cc -D_GNU_SOURCE    unifdef.c   -o unifdef
unifdef.c:209: error: conflicting types for `getline'
/usr/include/stdio.h:649: error: previous declaration of `getline' was here
make: *** [unifdef] Error 1
chigurh:~/linux/linux-2.6/scripts$ make unifdef
cc     unifdef.c   -o unifdef
chigurh:~/linux/linux-2.6/scripts$

> > I also just loaded the latest libc
> > (not sure if this has anything to do);
> 
> That probably updated /usr/include/stdio.h (?; I'm just guessing here).

Perhaps getline() is now defined even without _GNU_SOURCE?  But I
doubt that...

	Hannes

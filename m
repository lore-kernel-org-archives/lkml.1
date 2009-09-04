Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZIDNdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZIDNdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 09:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756778AbZIDNdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 09:33:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227AbZIDNdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 09:33:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: asm-generic update candidates?
Date: Fri, 4 Sep 2009 15:32:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-6-generic; KDE/4.3.0; x86_64; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
References: <200909031729.52538.rgetz@blackfin.uclinux.org>
In-Reply-To: <200909031729.52538.rgetz@blackfin.uclinux.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909041532.50456.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/thPtJUf5+8v/GE6m7DnPBzfh8PDpnNBT2Myo
 kZPHcLlNTr17rpGcACzPv0+JDsgS5HwgSBc7o7QBG+46z8i6LJ
 zahgInM0RMIAGJL2lBwhg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009, Robin Getz wrote:
> Arnd:
> 
> I was reviewing some files in ./arch/blackfin/include for missing copyrights, 
> and while tracking things down I noticed there were still some likely 
> candidates for inclusion in asm-generic...

Ah, thanks. I basically started out with the list of files that exist in
almost all architectures. I never looked at files that are identical in
some architectures but nonexistent in more than a few others.

Also, my plan is to do one architecture at a time, not one file at a time
across all architectures, because that will reduce the need for coordination
between multiple maintainers.

> All seem to be the same file:
> 
> md5sum:
> 5b6b31d728ed2ed0df73c56676fdc68f  blackfin/include/asm/fb.h
> 5b6b31d728ed2ed0df73c56676fdc68f  cris/include/asm/fb.h
> 5b6b31d728ed2ed0df73c56676fdc68f  frv/include/asm/fb.h
> 5b6b31d728ed2ed0df73c56676fdc68f  h8300/include/asm/fb.h
> 5b6b31d728ed2ed0df73c56676fdc68f  s390/include/asm/fb.h
> 5b6b31d728ed2ed0df73c56676fdc68f  xtensa/include/asm/fb.h

Look at the latest version. Some architectures have already started
using the generic version, e.g. blackfin.

> e31d052cbba4f417ba2158a41b0d8709  arm/include/asm/fb.h
> e31d052cbba4f417ba2158a41b0d8709  m32r/include/asm/fb.h
> e31d052cbba4f417ba2158a41b0d8709  sh/include/asm/fb.h

Interesting one. The only difference between these and the
above is the use of pgprot_writecombine, which is defined as
pgprot_noncached on the other architectures.
 
> Mostly the same:
>  mn10300/include/asm/shmparam.h
>  frv/include/asm/shmparam.h
>  m68k/include/asm/shmparam.h
>  h8300/include/asm/shmparam.h
>  alpha/include/asm/shmparam.h
>  x86/include/asm/shmparam.h
>  m32r/include/asm/shmparam.h
>  avr32/include/asm/shmparam.h
>  powerpc/include/asm/shmparam.h
>  blackfin/include/asm/shmparam.h
> 
> All the same:
> frv/include/asm/ucontext.h
> h8300/include/asm/ucontext.h
> avr32/include/asm/ucontext.h
> m32r/include/asm/ucontext.h
> cris/include/asm/ucontext.h
> alpha/include/asm/ucontext.h
> mips/include/asm/ucontext.h
> microblaze/include/asm/ucontext.h
> mn10300/include/asm/ucontext.h
> blackfin/include/asm/ucontext.h

Yes, these should come naturally when the architectures
get changed to use the generic headers.
 
> There seems to be lots of similarities in
>  */include/asm/types.h
>  */include/asm/kmap_types.h
>  */include/asm/termios.h
>  */include/asm/socket.h
>  */include/asm/param.h
>  */include/asm/signal.h (but not all)
>  */include/asm/posix_types.h
>  */include/asm/termbits.h
>  */include/asm/segment.h
>  */include/asm/auxvec.h
>  */include/asm/shmbuf.h
>  */include/asm/spinlock_types.h
> 
> Do you keep a list somewhere?

Well, this is how I started out writing doing the common files
in the first place. I looked at the most similar files, and then
used vimdiff on up to four files at a time, changing them to
be exactly identical by editing out all the bitrot.

In general, if a file exists in asm-generic, it should be usable
by some of the architectures, if it does not exist then either it
is too hard to make a generic version or I have not looked at it
yet.

If you want to help convert an architecture, try doing

for i in include/asm-generic/*.h ; do
      vimdiff ${i} arch/${ARCH}/include/asm/${i##*/}
done

If the files are identical, replace the contents of the arch
specific one with a simple #include <asm-generic/${i}>. If they
are almost identical, add overrides like in
arch/microblaze/include/asm/posix_types.h, possibly adding the
option for overriding to the generic file. For files that
are rather different, just leave them alone.

	Arnd <><

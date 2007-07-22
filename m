Return-Path: <linux-kernel-owner+w=401wt.eu-S1765596AbXGVWWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765596AbXGVWWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 18:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXGVWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 18:22:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:38080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757540AbXGVWWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 18:22:16 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andre Noll <maan@systemlinux.org>
Subject: Re: Linus 2.6.23-rc1
Date: Mon, 23 Jul 2007 00:22:11 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070722221001.GH30660@skl-net.de>
In-Reply-To: <20070722221001.GH30660@skl-net.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230022.11831.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 July 2007 00:10:01 Andre Noll wrote:
> On 14:04, Linus Torvalds wrote:
> 
> > So give it all a good whacking, and report back about all the neat new 
> > features!
> 
> Does overlapping sections count as a new feature? ;)
> 
>   gcc -m elf_x86_64 -nostdlib -fPIC -shared -Wl,-soname=linux-vdso.so.1  -Wl,-z,max-page-size=4096 -Wl,-z,common-page-size=4096 -Wl,-T,arch/x86_64/vdso/vdso.lds arch/x86_64/vdso/vdso-start.o arch/x86_64/vdso/vdso-note.o arch/x86_64/vdso/vclock_gettime.o arch/x86_64/vdso/vgetcpu.o arch/x86_64/vdso/vvar.o -o arch/x86_64/vdso/vdso.so
> /usr/bin/ld: section .text [ffffffffff700500 -> ffffffffff7007e3] overlaps section .gnu.version_d [ffffffffff7004d8 -> ffffffffff70050f]
> collect2: ld returned 1 exit status
> make[3]: *** [arch/x86_64/vdso/vdso.so] Error 1
> make[2]: *** [arch/x86_64/vdso] Error 2
> make[1]: *** [_all] Error 2
> make: *** [all] Error 2


Does this patch fix it?

-Andi


Increase VDSO_TEXT_OFFSET for ancient binutils

For some reason old binutils genertate larger headers so
increase the text offset of the vdso to avoid linker errors.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86_64/vdso/voffset.h
===================================================================
--- linux.orig/arch/x86_64/vdso/voffset.h
+++ linux/arch/x86_64/vdso/voffset.h
@@ -1 +1 @@
-#define VDSO_TEXT_OFFSET 0x500
+#define VDSO_TEXT_OFFSET 0x600

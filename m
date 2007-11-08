Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbXKHENs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbXKHENs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 23:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbXKHENk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 23:13:40 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:50565 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753241AbXKHENj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 23:13:39 -0500
Date: Thu, 8 Nov 2007 05:13:14 +0100
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-am33-list@redhat.com
Subject: Re: [PATCH 0/2] MN10300: Add the MN10300 architecture to Linux
	kernel [try #3]
Message-ID: <20071108041314.GG26163@stusta.de>
References: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071107174323.31820.65054.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 05:43:23PM +0000, David Howells wrote:
> 
> 
> These patches add the MEI/Panasonic MN10300/AM33 architecture to the Linux
> kernel.
> 
> The first patch suppresses AOUT support in the kernel if CONFIG_BINFMT_AOUT=n
> and CONFIG_IA32_AOUT=n.  MN10300 does not support the AOUT binfmt, so the ELF
> binfmt should not be permitted to go looking for AOUT libraries to load, nor
> should random bits of the kernel depend on asm/a.out.h.
> 
> The second patch adds the architecture itself, to be selected by ARCH=mn10300
> on the make command line.
> 
> The patches can also be downloaded from:
> 
> 	http://people.redhat.com/~dhowells/mn10300/mn10300-arch.tar.bz2


The patch to include/asm-generic/Kbuild.asm doesn't seem to be required.


+#elif defined(__mn10300__)

Please use a CONFIG_ variable in such cases.


The parts outside arch/mn10300/ and include/asm-mn10300/ (except for the 
trivial "&& {,!}MN10300" Kconfig changes) should go separately through 
the maintainers or get ACKs from the maintainers, even more since they 
also contain cleanups like

-               .regions = {ERASEINFO(0x01000,64),
+               .regions        = {
+                       ERASEINFO(0x01000,64),
                }


--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
...
+extern void __kprobes arch_remove_kprobe(struct kprobe *p);

This looks as if it will break compilation on avr32 and sparc64.


> A suitable toolchain can be downloaded from:
> 
> 	ftp://ftp.redhat.com/pub/redhat/gnupro/AM33/
>...

What is the status of support in upstream GNU binutils and GNU gcc?

> David

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


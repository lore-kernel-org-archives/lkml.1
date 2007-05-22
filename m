Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbXEVTZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbXEVTZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 15:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759565AbXEVTZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 15:25:27 -0400
Received: from khc.piap.pl ([195.187.100.11]:54151 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758662AbXEVTZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 15:25:26 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: any value to "NORET_TYPE" macro?
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	<20070522135927.GA2098@stusta.de>
	<Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	<20070522161951.GC2098@stusta.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 22 May 2007 21:25:24 +0200
In-Reply-To: <20070522161951.GC2098@stusta.de> (Adrian Bunk's message of "Tue, 22 May 2007 18:19:51 +0200")
Message-ID: <m3ejl8k6e3.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

>> no, i think you're thinking of the alternative ATTRIB_NORET macro.
>> as you can read in my previous post, NORET_TYPE used to resolve to
>> "__volatile__" for very old gcc.  so i think it's legitimately dead
>> and can be ripped out.
>
> No doubt that it could be removed because it doesn't have any effect.
>
> But locking at the usages, it seems to have been used when people 
> thought it was what __noreturn now is, so replacing NORET_TYPE with 
> __noreturn might be a small optimization (but every NORET_TYPE should 
> be checked that it's actually correct).

Actually it seems all the NORET_TYPEs are in fact (should be)
__attribute__((noreturn)) (2.6.21):

Almost certainly:
arch/mips/kernel/traps.c:NORET_TYPE void ATTRIB_NORET die()
arch/ia64/kernel/machine_kexec.c:typedef NORET_TYPE void ()(
arch/x86_64/kernel/machine_kexec.c:NORET_TYPE void machine_kexec()
arch/arm26/kernel/traps.c:NORET_TYPE void die()
arch/ppc/kernel/machine_kexec.c:typedef NORET_TYPE void ()(
arch/ppc/kernel/machine_kexec.c:NORET_TYPE void machine_kexec()
arch/ppc/amiga/config.c:static NORET_TYPE void amiga_reset()
arch/powerpc/kernel/machine_kexec.c:NORET_TYPE void machine_kexec()
arch/powerpc/kernel/machine_kexec_64.c:extern NORET_TYPE void kexec_sequence()
arch/powerpc/kernel/machine_kexec_32.c:typedef NORET_TYPE void ()(
arch/sh/kernel/machine_kexec.c:typedef NORET_TYPE void ()(
arch/sh/kernel/machine_kexec.c:NORET_TYPE void machine_kexec()
arch/arm/kernel/traps.c:NORET_TYPE void die()
arch/i386/kernel/machine_kexec.c:NORET_TYPE void machine_kexec()
arch/m68k/amiga/config.c:static NORET_TYPE void amiga_reset()
drivers/s390/s390mach.c:static NORET_TYPE void s390_handle_damage()
include/asm-i386/kexec.h:asmlinkage NORET_TYPE void
include/asm-mips/ptrace.h:extern NORET_TYPE void die();
include/asm-x86_64/kexec.h:NORET_TYPE void
include/linux/kexec.h:extern NORET_TYPE void machine_kexec() ATTRIB_NORET;
include/linux/linkage.h:#define NORET_TYPE    /**/
include/linux/kernel.h:NORET_TYPE void panic()
include/linux/kernel.h:fastcall NORET_TYPE void do_exit()
include/linux/kernel.h:NORET_TYPE void complete_and_exit()
include/linux/sched.h:extern NORET_TYPE void do_group_exit();
kernel/exit.c:fastcall NORET_TYPE void do_exit()
kernel/exit.c:NORET_TYPE void complete_and_exit()
kernel/exit.c:NORET_TYPE void do_group_exit()
kernel/panic.c:NORET_TYPE void panic()

The remaining 2 ones should most probably be removed, e2fsprogs
don't use it either (it was probably used by ext[23] in-kernel
code in the past):

include/linux/ext4_fs.h:# define NORET_TYPE    /**/
include/linux/ext3_fs.h:# define NORET_TYPE    /**/

-- 
Krzysztof Halasa

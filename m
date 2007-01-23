Return-Path: <linux-kernel-owner+w=401wt.eu-S933131AbXAWUuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131AbXAWUuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933132AbXAWUuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:50:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933131AbXAWUub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:50:31 -0500
Date: Tue, 23 Jan 2007 15:50:18 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Samium Gromoff <_deepfire@feelingofgreen.ru>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@ucw.cz>,
       Valdis.Kletnieks@vt.edu, David Wagner <daw@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Define the EF_AS_NO_RANDOM e_flag bit
Message-ID: <20070123205017.GH29911@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <87r6toufpp.wl@betelheise.deep.net> <200701221520.l0MFKLdK032645@turing-police.cc.vt.edu> <871wlnq7ue.wl@betelheise.deep.net> <20070123084805.GB5560@ucw.cz> <87mz4996wg.wl@betelheise.deep.net> <20070123154127.57059632@localhost.localdomain> <877ivd8p42.wl@betelheise.deep.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ivd8p42.wl@betelheise.deep.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 11:28:13PM +0300, Samium Gromoff wrote:
> Author: Samium Gromoff <deepfire@betelheise.deep.net>
> Date:   Tue Jan 23 22:31:13 2007 +0300
> 
>     Define the ELF binary header flag EF_AS_NO_RANDOM
>     
>     EF_AS_NO_RANDOM should mean that the binary requests to not apply
>     randomisation to address spaces of its processes.
> 
> diff --git a/include/linux/elf.h b/include/linux/elf.h
> index 60713e6..58ebb47 100644
> --- a/include/linux/elf.h
> +++ b/include/linux/elf.h
> @@ -172,6 +172,8 @@ typedef struct elf64_sym {
>  
>  #define EI_NIDENT      16
>  
> +#define EF_AS_NO_RANDOM 0x1    /* do not randomise the address space */
> +

You can't make up EF_* flags this way, they are arch specific, the LSB bit
(but many others too) are already used on many architectures.
E.g.:
elf/mt.h:#define EF_MT_CPU_MRISC              0x00000001      /* default */
elf/sparc.h:#define EF_SPARCV9_PSO            0x1             /* partial store ordering */
elf/bfin.h:#define EF_BFIN_PIC                0x00000001      /* -fpic */
elf/alpha.h:#define EF_ALPHA_32BIT            0x00000001
elf/mips.h:#define EF_MIPS_NOREORDER  0x00000001
elf/m68k.h:#define EF_M68K_CF_ISA_A_NODIV     0x01  /* ISA A except for div */
elf/sh.h:#define EF_SH1                  1
elf/arm.h:#define EF_ARM_RELEXEC     0x01
elf/cris.h:#define EF_CRIS_UNDERSCORE         0x00000001
elf/ia64.h:#define EF_IA_64_TRAPNIL (1 << 0)  /* Trap NIL pointer dereferences.  */
elf/vax.h:#define EF_VAX_NONPIC               0x0001  /* Object contains non-PIC code */
elf/iq2000.h:#define EF_IQ2000_CPU_IQ2000     0x00000001      /* default */
elf/frv.h:#define EF_FRV_GPR_32               0x00000001      /* -mgpr-32 */
to name just a few.

	Jakub

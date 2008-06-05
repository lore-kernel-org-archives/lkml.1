Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbYFEUl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbYFEUl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 16:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYFEUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 16:41:50 -0400
Received: from www.tglx.de ([62.245.132.106]:57865 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbYFEUlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 16:41:50 -0400
Date: Thu, 5 Jun 2008 22:41:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Robert Richter <robert.richter@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] fix build bug in "x86: add PCI extended config space
 access for AMD Barcelona"
In-Reply-To: <20080605185706.35A3B806B@erda.amd.com>
Message-ID: <alpine.LFD.1.10.0806052239110.3235@apollo.tec.linutronix.de>
References: <20080604151131.GV23679@erda.amd.com> <20080605185706.35A3B806B@erda.amd.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2008, Robert Richter wrote:
> --- a/include/asm-x86/mmconfig.h
> +++ b/include/asm-x86/mmconfig.h
> @@ -9,10 +9,4 @@ static inline void fam10h_check_enable_mmcfg(void) { }
>  static inline void check_enable_amd_mmconf_dmi(void) { }
>  #endif
>  
> -#if defined(CONFIG_SMP) && defined(CONFIG_X86_64)
> -extern void __cpuinit amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c);
> -#else
> -static inline void amd_enable_pci_ext_cfg(struct cpuinfo_x86 *c) { }
> -#endif
> -

Can we please remove this superflous arch/x86/kernel/setup.h file,
which has a length/content ratio of 26:1. This removes the ugly
"../setup.h" includes

Thanks,
	tglx

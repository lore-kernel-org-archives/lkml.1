Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZIAKsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZIAKsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 06:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZIAKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 06:48:54 -0400
Received: from mail.tre.it ([62.13.171.46]:42672 "EHLO relay2.tre.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772AbZIAKsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 06:48:53 -0400
X-Greylist: delayed 92206 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Sep 2009 06:48:53 EDT
Date: Mon, 31 Aug 2009 13:13:59 +0200
From: Daniele Calore <orkaan@orkaan.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Anvin <hpa@zytor.com>, Arjan van de Veen <arjan@infradead.org>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: Re: [patch 2/3] x86/boot: adding hw subarch ID for Moorestown
Message-ID: <20090831131359.0cc90d4d@buddha>
In-Reply-To: <20090830134517.705603639@linutronix.de>
References: <20090830134446.843410397@linutronix.de>
	<20090830134517.705603639@linutronix.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think there is a typo (copy/paste error), see below:

On Sun, 30 Aug 2009 13:46:28 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 11 Jun 2009 20:34:47 -0700
> Subject: [patch 2/3] [PATCH] x86/boot: adding hw subarch ID for
> Moorestown
> 
> x86 bootprotocol 2.07 has introduced hardware_subarch ID in the boot
> parameters provided by FW. We use it to identify Moorestown platforms.
> 
> The subarchitecture ID will help select a set of platform features and
> x86_quirks.
> 
> [ tglx: Cleanup and paravirt fix ]
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  Documentation/x86/boot.txt       |    1 +
>  arch/x86/include/asm/bootparam.h |   10 ++++++++++
>  arch/x86/kernel/head_32.S        |    1 +
>  3 files changed, 12 insertions(+)
> 
> Index: linux-2.6-tip/Documentation/x86/boot.txt
> ===================================================================
> --- linux-2.6-tip.orig/Documentation/x86/boot.txt
> +++ linux-2.6-tip/Documentation/x86/boot.txt
> @@ -599,6 +599,7 @@ Protocol:	2.07+
>    0x00000000	The default x86/PC environment
>    0x00000001	lguest
>    0x00000002	Xen
> +  0x00000003	Moorestown MID
>  
>  Field name:	hardware_subarch_data
>  Type:		write (subarch-dependent)
> Index: linux-2.6-tip/arch/x86/include/asm/bootparam.h
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/include/asm/bootparam.h
> +++ linux-2.6-tip/arch/x86/include/asm/bootparam.h
> @@ -109,4 +109,14 @@ struct boot_params {
>  	__u8  _pad9[276];				/* 0xeec */
>  } __attribute__((packed));
>  
> +enum {
> +	X86_SUBARCH_PC = 0,
> +	X86_SUBARCH_LGUEST,
> +	X86_SUBARCH_XEN,
> +	X86_SUBARCH_MRST,
> +	X86_NR_SUBARCHS,
> +};
> +
> +
> +
>  #endif /* _ASM_X86_BOOTPARAM_H */
> Index: linux-2.6-tip/arch/x86/kernel/head_32.S
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/head_32.S
> +++ linux-2.6-tip/arch/x86/kernel/head_32.S
> @@ -157,6 +157,7 @@ subarch_entries:
>  	.long default_entry		/* normal x86/PC */
>  	.long lguest_entry		/* lguest hypervisor */
>  	.long xen_entry			/* Xen hypervisor */
> +	.long default_entry		/* Moorestown MID */

Typo: s/default_entry/mrst_entry

>  num_subarch_entries = (. - subarch_entries) / 4
>  .previous
>  #endif /* CONFIG_PARAVIRT */


Daniele
--

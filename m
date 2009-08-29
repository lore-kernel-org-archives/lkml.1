Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbZH2Q7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbZH2Q7m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 12:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZH2Q7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 12:59:42 -0400
Received: from www.tglx.de ([62.245.132.106]:36748 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZH2Q7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 12:59:41 -0400
Date: Sat, 29 Aug 2009 18:58:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
cc: LKML <linux-kernel@vger.kernel.org>, x86 team <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 1/7] x86/boot: adding hw subarch ID for Moorestown
In-Reply-To: <43F901BD926A4E43B106BF17856F07556A5EA871@orsmsx508.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0908291856100.19335@localhost.localdomain>
References: <20090821205008.518392436@linutronix.de> <20090821205602.584376844@linutronix.de> <4A8F1FEA.1060706@goop.org> <alpine.LFD.2.00.0908220139390.1769@localhost.localdomain> <43F901BD926A4E43B106BF17856F07556A5EA871@orsmsx508.amr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009, Pan, Jacob jun wrote:
> >From 2de4f68e7b0403bb39954d7c2e3d5097d0e6e3ac Mon Sep 17 00:00:00 2001
> From: Jacob Pan <jacob.jun.pan@intel.com>
> Date: Thu, 11 Jun 2009 20:34:47 -0700
> Subject: [PATCH] x86/boot: adding hw subarch ID for Moorestown
> 
> x86 bootprotocol 2.07 has introduced hardware_subarch ID in the boot
> parameters provided by FW. We use it to identify Moorestown platforms.
> 
> The subarchitecture ID will help select a set of platform features and
> x86_quirks.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
> ---
>  Documentation/x86/boot.txt       |    1 +
>  arch/x86/include/asm/bootparam.h |   11 +++++++++++
>  2 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 8da3a79..30b43e1 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -599,6 +599,7 @@ Protocol:	2.07+
>    0x00000000	The default x86/PC environment
>    0x00000001	lguest
>    0x00000002	Xen
> +  0x00000003	Moorestown MID
>  
>  Field name:	hardware_subarch_data
>  Type:		write (subarch-dependent)
> diff --git a/arch/x86/include/asm/bootparam.h b/arch/x86/include/asm/bootparam.h
> index 1724e8d..631cae9 100644
> --- a/arch/x86/include/asm/bootparam.h
> +++ b/arch/x86/include/asm/bootparam.h
> @@ -109,4 +109,15 @@ struct boot_params {
>  	__u8  _pad9[276];				/* 0xeec */
>  } __attribute__((packed));
>  
> +#define N_X86_SUBARCHS			4

Grr.

> +enum {
> +	X86_SUBARCH_PC = 0,
> +	X86_SUBARCH_LGUEST,
> +	X86_SUBARCH_XEN,
> +	X86_SUBARCH_MRST,

  	X86_NR_SUBARCHS,

perhaps ?

Also this patch will result in boot failure when paravirt is
enabled. head_32.S wants to be tweaked as well.

Thanks,

	tglx

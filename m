Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbYIWLIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbYIWLIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYIWLIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:08:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49216 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbYIWLIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:08:10 -0400
Date: Tue, 23 Sep 2008 13:07:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Russ Anderson <rja@sgi.com>, Ying Huang <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH 1/4] x86: Add UV EFI table entry
Message-ID: <20080923110756.GE29021@elte.hu>
References: <20080922210829.GD222374@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922210829.GD222374@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Ying Huang.)

* Russ Anderson <rja@sgi.com> wrote:

> [PATCH 1/4] Add UV EFI table entry
> 
> Look for a SAL entry in the EFI tables.
> 
> Signed-off-by: Russ Anderson <rja@sgi.com>
> Signed-off-by: Paul Jackson <pj@sgi.com>
> 
> ---
>  arch/x86/kernel/efi.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux/arch/x86/kernel/efi.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/efi.c	2008-09-22 16:01:00.000000000 -0500
> +++ linux/arch/x86/kernel/efi.c	2008-09-22 16:01:07.000000000 -0500
> @@ -367,6 +367,10 @@ void __init efi_init(void)
>  			efi.smbios = config_tables[i].table;
>  			printk(" SMBIOS=0x%lx ", config_tables[i].table);
>  		} else if (!efi_guidcmp(config_tables[i].guid,
> +					SAL_SYSTEM_TABLE_GUID)) {
> +			efi.sal_systab = config_tables[i].table;
> +			printk(" SALsystab=0x%lx ", config_tables[i].table);
> +		} else if (!efi_guidcmp(config_tables[i].guid,
>  					HCDP_TABLE_GUID)) {
>  			efi.hcdp = config_tables[i].table;
>  			printk(" HCDP=0x%lx ", config_tables[i].table);
> -- 
> Russ Anderson, OS RAS/Partitioning Project Lead  
> SGI - Silicon Graphics Inc          rja@sgi.com

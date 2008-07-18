Return-Path: <linux-kernel-owner+w=401wt.eu-S1761242AbYGRROL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761242AbYGRROL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbYGRRNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:13:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39318 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177AbYGRRNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:13:43 -0400
Date: Fri, 18 Jul 2008 19:13:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] - Earlier detection of system type (UV or non-UV)
Message-ID: <20080718171331.GK6875@elte.hu>
References: <20080709163602.GA12543@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080709163602.GA12543@sgi.com>
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


* Jack Steiner <steiner@sgi.com> wrote:

> A patch is coming that requires earlier detection of system type (UV 
> or non-UV) Move the logic that detects whether running on UV to 
> acpi_boot_table_init().

> ===================================================================
> --- linux.orig/arch/x86/kernel/acpi/boot.c	2008-07-09 11:14:03.000000000 -0500
> +++ linux/arch/x86/kernel/acpi/boot.c	2008-07-09 11:14:33.000000000 -0500
> @@ -1712,6 +1712,10 @@ int __init acpi_boot_table_init(void)
>  		return error;
>  	}
>  
> +#ifdef CONFIG_X86_64
> +	acpi_table_parse(ACPI_SIG_MADT, acpi_early_madt_oem_check);
> +#endif
> +
>  	acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);

why the assymetry? We should parse it regardless of 32-bit or 64-bit. 
(even if UV is 64-bit only, obviously)

	Ingo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbZFWH2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbZFWH2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWH21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:28:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36428 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587AbZFWH20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:28:26 -0400
Date: Tue, 23 Jun 2009 09:28:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623072811.GB6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com> <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0007]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> +/*
> + * Table structures must be byte-packed to match the SFI specification,
> + * as they are provided by the BIOS.
> + */
> +#pragma pack(1)

We use __attribute__((packed)) for that generally.

> +struct sfi_table_header {
> +	char signature[SFI_SIGNATURE_SIZE];
> +	u32 length;
> +	u8 revision;
> +	u8 checksum;
> +	char oem_id[SFI_OEM_ID_SIZE];
> +	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> +};

Please use more readable structure definitions, such as:

> +struct sfi_table_header {
> +	char			signature[SFI_SIGNATURE_SIZE];
> +	u32			length;
> +	u8			revision;
> +	u8			checksum;
> +	char			oem_id[SFI_OEM_ID_SIZE];
> +	char			oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> +};

> +void __init __iomem *
> +arch_early_ioremap(unsigned long phys, unsigned long size);
> +void __init arch_early_iounmap(void __iomem *virt, unsigned long size);

Why is this in sfr.h? Should be in a separate series.

> +static inline int sfi_init_memory_map(void) { return -1; }
> +static inline int sfi_init(void) { return 0; }
> +static inline void sfi_init_late(void)	{}

Seems half-aligned. Please align consistently, such as:

static inline int sfi_init_memory_map(void)	{ return -1; }
static inline int sfi_init(void)		{ return  0; }
static inline void sfi_init_late(void)		{ }

or dont align at all.

	Ingo

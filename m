Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbZFWHtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbZFWHtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZFWHs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:48:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:60908 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbZFWHs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,274,1243839600"; 
   d="scan'208";a="701687854"
Date: Tue, 23 Jun 2009 15:47:24 +0800
From: Feng Tang <feng.tang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>,
       "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Brown, Len" <len.brown@intel.com>
Subject: Re: [PATCH 2/8] SFI: include/linux/sfi.h
Message-ID: <20090623154724.08a51ea3@feng-desktop>
In-Reply-To: <20090623072811.GB6397@elte.hu>
References: <7425334c8329b15bec7cb4ecd0b17af042e97465.1245740912.git.len.brown@intel.com>
	<b3fb5fa65a532941d61a8c8415495f752aac540d.1245740912.git.len.brown@intel.com>
	<20090623072811.GB6397@elte.hu>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 15:28:11 +0800
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Len Brown <lenb@kernel.org> wrote:
> 
> > +/*
> > + * Table structures must be byte-packed to match the SFI
> > specification,
> > + * as they are provided by the BIOS.
> > + */
> > +#pragma pack(1)
> 
> We use __attribute__((packed)) for that generally.
> 
> > +struct sfi_table_header {
> > +	char signature[SFI_SIGNATURE_SIZE];
> > +	u32 length;
> > +	u8 revision;
> > +	u8 checksum;
> > +	char oem_id[SFI_OEM_ID_SIZE];
> > +	char oem_table_id[SFI_OEM_TABLE_ID_SIZE];
> > +};
> 
> Please use more readable structure definitions, such as:
> 
> > +struct sfi_table_header {
> > +	char			signature[SFI_SIGNATURE_SIZE];
> > +	u32			length;
> > +	u8			revision;
> > +	u8			checksum;
> > +	char			oem_id[SFI_OEM_ID_SIZE];
> > +	char
> > oem_table_id[SFI_OEM_TABLE_ID_SIZE]; +};
> 
> > +void __init __iomem *
> > +arch_early_ioremap(unsigned long phys, unsigned long size);
> > +void __init arch_early_iounmap(void __iomem *virt, unsigned long
> > size);
> 
> Why is this in sfr.h? Should be in a separate series.

Thanks for your great comments, will address them.

For these arch_early_ioremap/arch_early_iounmap API, do you mean we should
put it in a sfi.h under "asm" folder? The reason we put it here is to
give a arch independent API declaration here and let each arch implement
its own func.

Thanks,
Feng

> 
> > +static inline int sfi_init_memory_map(void) { return -1; }
> > +static inline int sfi_init(void) { return 0; }
> > +static inline void sfi_init_late(void)	{}
> 
> Seems half-aligned. Please align consistently, such as:
> 
> static inline int sfi_init_memory_map(void)	{ return -1; }
> static inline int sfi_init(void)		{ return  0; }
> static inline void sfi_init_late(void)		{ }
> 
> or dont align at all.
> 
> 	Ingo

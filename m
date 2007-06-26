Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbXFZGZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbXFZGZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbXFZGZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:25:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52564 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751147AbXFZGZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:25:37 -0400
Date: Mon, 25 Jun 2007 23:25:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-Id: <20070625232511.3fc07f8f.akpm@linux-foundation.org>
In-Reply-To: <20070619213808.716432000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.716432000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:37:06 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> +/*
> + * Decoding Capability Register
> + */
> +#define cap_read_drain(c)	(((c) >> 55) & 1)
> +#define cap_write_drain(c)	(((c) >> 54) & 1)
> +#define cap_max_amask_val(c)	(((c) >> 48) & 0x3f)
> +#define cap_num_fault_regs(c)	((((c) >> 40) & 0xff) + 1)
> +#define cap_pgsel_inv(c)	(((c) >> 39) & 1)
> +
> +#define cap_super_page_val(c)	(((c) >> 34) & 0xf)
> +#define cap_super_offset(c)	(((find_first_bit(&cap_super_page_val(c), 4)) \
> +					* OFFSET_STRIDE) + 21)
> +
> +#define cap_fault_reg_offset(c)	((((c) >> 24) & 0x3ff) * 16)
> +#define cap_max_fault_reg_offset(c) \
> +	(cap_fault_reg_offset(c) + cap_num_fault_regs(c) * 16)
> +
> +#define cap_zlr(c)		(((c) >> 22) & 1)
> +#define cap_isoch(c)		(((c) >> 23) & 1)
> +#define cap_mgaw(c)		((((c) >> 16) & 0x3f) + 1)
> +#define cap_sagaw(c)		(((c) >> 8) & 0x1f)
> +#define cap_caching_mode(c)	(((c) >> 7) & 1)
> +#define cap_phmr(c)		(((c) >> 6) & 1)
> +#define cap_plmr(c)		(((c) >> 5) & 1)
> +#define cap_rwbf(c)		(((c) >> 4) & 1)
> +#define cap_afl(c)		(((c) >> 3) & 1)
> +#define cap_ndoms(c)		(((unsigned long)1) << (4 + 2 * ((c) & 0x7)))
> +/*
> + * Extended Capability Register
> + */
> +
> +#define ecap_niotlb_iunits(e)	((((e) >> 24) & 0xff) + 1)
> +#define ecap_iotlb_offset(e) 	((((e) >> 8) & 0x3ff) * 16)
> +#define ecap_max_iotlb_offset(e) \
> +	(ecap_iotlb_offset(e) + ecap_niotlb_iunits(e) * 16)
> +#define ecap_coherent(e)	((e) & 0x1)

None of these actually _need_ to be macros and it would be better to 
implement them in C.  That way things are more self-documenting, more
pleasant to read, more likely to get commented and you'll fix the
two bugs wherein the argument to a macro is evaluated more than once.


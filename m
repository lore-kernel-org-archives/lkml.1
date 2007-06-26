Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbXFZGaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbXFZGaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbXFZGaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:30:39 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbXFZGai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:30:38 -0400
Date: Mon, 25 Jun 2007 23:30:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 05/10] Intel IOMMU driver
Message-Id: <20070625233012.1a554554.akpm@linux-foundation.org>
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

> 	Actual intel IOMMU driver. Hardware spec can be found at:
> http://www.intel.com/technology/virtualization
> 
> This driver sets X86_64 'dma_ops', so hook into standard DMA APIs. In this way,
> PCI driver will get virtual DMA address. This change is transparent to PCI
> drivers.
> 
> Changes from previous postings:
> 1) Fixed all the coding style errors - checkpatches.pl passes this patch
> 2) Addressed all Andrew's comments
> 3) Removed resource pool ( a.k.a pre-allocate pool)
> 4) Now uses the standard kmem_cache_alloc functions to allocate memory
>    during dma map api calls.
> 
> 
> ...
> +#define context_set_translation_type(c, val) \
> +	do { \
> +		(c).lo &= (((u64)-1) << 4) | 3; \
> +		(c).lo |= ((val) & 3) << 2; \
> +	} while (0)

That evaluates `c' twice.  It's a little handgrenade waiting to go off.

> +#define context_clear_entry(c) do {(c).lo = 0; (c).hi = 0;} while (0)

Ditto



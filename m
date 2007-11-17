Return-Path: <linux-kernel-owner+w=401wt.eu-S1759024AbXKQIwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbXKQIwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 03:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbXKQIwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 03:52:45 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:55460 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbXKQIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 03:52:44 -0500
Date: Sat, 17 Nov 2007 10:52:41 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: mark gross <mgross@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [PATCH]intel-iommu-PMEN support
Message-ID: <20071117085241.GG4380@rhun.haifa.ibm.com>
References: <20071116223957.GA26796@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116223957.GA26796@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 02:39:57PM -0800, mark gross wrote:

> The following patch adds support for protected memory enable bits by
> clearing them if they are set at startup time.  Some future boot
> loaders or firmware could have this bit set after it loads the
> kernel, and it needs to be cleared if DMA's are going to happen
> effectively.
> 
> please apply
> 
> --mgross
> 
> Signed-off-by: mark gross <mgross@intel.com>

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Mark, please try in the future to not mix unrelated changes such as
these. This patch should've been two patches, one to disable protected
memory enable and the other to do the cleanups.

> -#define MAX_FAULT_REASON_IDX 	ARRAY_SIZE(fault_reason_strings) - 1
> +#define MAX_FAULT_REASON_IDX 	(ARRAY_SIZE(fault_reason_strings) - 1)

> -static inline u64 dmar_readq(void *addr)
> +static inline u64 dmar_readq(void __iomem *addr)

Cheers,
Muli

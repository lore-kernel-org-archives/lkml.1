Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbXHAXqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbXHAXqr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 19:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbXHAXqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 19:46:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57171 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbXHAXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 19:46:38 -0400
Date: Wed, 1 Aug 2007 16:45:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andi K <ak@suse.de>, arjan <arjan@linux.intel.com>,
       Ashok Raj <ashok.raj@intel.com>, Suresh B <suresh.b.siddha@intel.com>
Subject: Re: [patch -mm][Intel-IOMMU] Optimize sg map/unmap calls
Message-Id: <20070801164554.5d2d157a.akpm@linux-foundation.org>
In-Reply-To: <20070801200623.GA20780@linux-os.sc.intel.com>
References: <20070801200623.GA20780@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 13:06:23 -0700
"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> +/* Computes the padding size required, to make the
> + * the start address naturally aligned on its size
> + */
> +static int
> +iova_get_pad_size(int size, unsigned int limit_pfn)
> +{
> +	unsigned int pad_size = 0;
> +	unsigned int order = ilog2(size);
> +
> +	if (order)
> +		pad_size = (limit_pfn + 1) % (1 << order);
> +
> +	return pad_size;
> +}

This isn't obviously doing the right thing for non-power-of-2 inputs.
ilog2() rounds down...

Please check that this, and all the other ilog2()s which have been added
are doing the right thing if they can be presented with non-power-of-2
inputs?

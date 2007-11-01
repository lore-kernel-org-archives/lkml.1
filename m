Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbXKAAvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbXKAAvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:51:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbXKAAvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:51:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33475 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbXKAAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:51:42 -0400
Date: Thu, 1 Nov 2007 09:52:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org, pbadari@us.ibm.com,
       benh@kernel.crashing.org, galak@gate.crashing.org, haveblue@us.ibm.com,
       paulus@samba.org, tony.luck@intel.com
Subject: Re: + add-remove_memory-for-ppc64-2.patch added to -mm tree
Message-Id: <20071101095243.ce7fb054.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071031225833.66C04432BF5@localhost>
References: <20071031225833.66C04432BF5@localhost>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 15:58:33 -0700
akpm@linux-foundation.org wrote:

> +int remove_memory(u64 start, u64 size)
> +{
> +	unsigned long start_pfn, end_pfn;
> +	int ret;
> +
> +	start_pfn = start >> PAGE_SHIFT;
> +	end_pfn = start_pfn + (size >> PAGE_SHIFT);
> +	ret = offline_pages(start_pfn, end_pfn, 120 * HZ);
> +	if (ret)
> +		goto out;
> +	/* we can free mem_map at this point */
> +out:
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(remove_memory);

Then, remove_memory() is now generic. 
Ok.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


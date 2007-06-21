Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbXFUGMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbXFUGMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 02:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXFUGMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 02:12:47 -0400
Received: from mga09.intel.com ([134.134.136.24]:40252 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbXFUGMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 02:12:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,445,1175497200"; 
   d="scan'208";a="98683614"
Message-ID: <467A1679.8090202@linux.intel.com>
Date: Wed, 20 Jun 2007 23:11:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation failures	in	dma	map
 api calls
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>	 <20070619213808.798646000@askeshav-devel.jf.intel.com>	 <1182326799.21117.19.camel@twins> <46792586.20706@linux.intel.com>	 <20070620173038.GA25516@linux-os.sc.intel.com>	 <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com>	 <1182370132.21117.84.camel@twins>	 <20070620230337.GA6771@linux-os.sc.intel.com> <1182406212.21117.94.camel@twins>
In-Reply-To: <1182406212.21117.94.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> What I'm saying is that if you do use the reserves, you should ensure
> the use is bounded. I'm not seeing anything like that.

each mapping takes at most 3 pages
> 
> This is a generic API, who is to ensure some other non-swap device will
> not deplete memory and deadlock the reclaim process?
>

that information is not available at this level ;(

> 
> 
> Also, explain to me how an IOMMU is different from bounce buffers? They
> both do the same thing, no? They both need memory in order to complete
> DMA.

bounce buffers happen in a place where you can sleep.... that makes a 
lot of difference.

> 
> Is it just a broken API you're working against? If so, isn't the Linux
> way to fix these things, that is why we have the source code after all.

well yes and no... the other iommu's snuck in as well... it's not 
entirely fair to hold this one back until a 2 year, 1400 driver 
project is completed ;(

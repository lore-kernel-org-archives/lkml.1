Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXEWS5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXEWS5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 14:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXEWS50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 14:57:26 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:57050 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbXEWS50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 14:57:26 -0400
Date: Wed, 23 May 2007 11:57:48 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data -- version 3
Message-ID: <20070523185748.GA4072@localhost.localdomain>
References: <20070523104946.f279241c.akpm@linux-foundation.org> <79E93560F4A5FD42BB769DAAF8BEF62A01AA8C77@scsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79E93560F4A5FD42BB769DAAF8BEF62A01AA8C77@scsmsx411.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.1i
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 11:26:53AM -0700, Yu, Fenghua wrote:
> > elements are cacheline aligned. And as such, this differentiates the
> local
> > only data and remotely accessed data cleanly.
> 
> >OK, but could we please have a concise description of the impact
> >of these changes on kernel memory footprint?  Increase or decrease?
> >And by approximately how much?
> 
> Depending on how linker places percpu data, the patches could
> increase or decrease percpu section size. Data from 2.6.21-rc7-mm2:
> 
> On x86 SMP, the section size is increased from 0x7768 to 0x790c.
> 1.3% increase.
> 
> On X86-64 SMP, the size is decreased from 0x72d0 to 0x6540.
> 11.8% decrease.
> 
> On X86-64 VSMP, the size is increased from 0x72d0 to 0x8340.
> 14.3% increase.
> 
> On IA64 SMP, the size is decreased from 0x8370 to 0x7fc0.
> 2.8% decrease.

Has there been any measurable benefit yet due to tail padding?
It would also be interesting to check the wastage/savings on another large
cache architecture like S390 (which has a 256 byte cache line)

Thanks,
Kiran

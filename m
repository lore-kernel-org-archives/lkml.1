Return-Path: <linux-kernel-owner+w=401wt.eu-S1757543AbXEXJDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbXEXJDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263AbXEXJDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:03:25 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:18319 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127AbXEXJDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:03:24 -0400
Subject: Re: [PATCH 1/2] Define new percpu interface for shared data --
	version 3
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: "Yu, Fenghua" <fenghua.yu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, clameter@sgi.com,
       rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070523185748.GA4072@localhost.localdomain>
References: <20070523104946.f279241c.akpm@linux-foundation.org>
	 <79E93560F4A5FD42BB769DAAF8BEF62A01AA8C77@scsmsx411.amr.corp.intel.com>
	 <20070523185748.GA4072@localhost.localdomain>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 24 May 2007 11:03:56 +0200
Message-Id: <1179997436.8070.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 11:57 -0700, Ravikiran G Thirumalai wrote:
> > >OK, but could we please have a concise description of the impact
> > >of these changes on kernel memory footprint?  Increase or decrease?
> > >And by approximately how much?
> > 
> > Depending on how linker places percpu data, the patches could
> > increase or decrease percpu section size. Data from 2.6.21-rc7-mm2:
> > 
> > On x86 SMP, the section size is increased from 0x7768 to 0x790c.
> > 1.3% increase.
> > 
> > On X86-64 SMP, the size is decreased from 0x72d0 to 0x6540.
> > 11.8% decrease.
> > 
> > On X86-64 VSMP, the size is increased from 0x72d0 to 0x8340.
> > 14.3% increase.
> > 
> > On IA64 SMP, the size is decreased from 0x8370 to 0x7fc0.
> > 2.8% decrease.
> 
> Has there been any measurable benefit yet due to tail padding?
> It would also be interesting to check the wastage/savings on another
> large
> cache architecture like S390 (which has a 256 byte cache line)

Current git with the patches applied and the default configuration for
s390 decreases the section size fof .data.percpu from 0x3e50 to 0x3e00.
0.5% decrease.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.



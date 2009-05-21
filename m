Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZEUTMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZEUTMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbZEUTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:12:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:48511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbZEUTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,228,1241420400"; 
   d="scan'208";a="414641730"
Subject: Re: [GIT PATCH] x86,percpu: fix pageattr handling with remap
 allocator
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Tejun Heo <tj@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "JBeulich@novell.com" <JBeulich@novell.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel-owner@vger.kernel.org" 
	<linux-kernel-owner@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4A14B271.5010202@kernel.org>
References: <1242305390-21958-1-git-send-email-tj@kernel.org>
	 <1242436626.27006.8623.camel@localhost.localdomain>
	 <4A0ED8D8.2010303@kernel.org>
	 <1242500964.27006.8636.camel@localhost.localdomain>
	 <4A0F672A.3000309@kernel.org>
	 <1242674444.27006.8691.camel@localhost.localdomain>
	 <4A11B9E7.8010707@zytor.com>
	 <1242680835.27006.8734.camel@localhost.localdomain>
	 <4A120B47.8060200@kernel.org>
	 <1242860470.27006.10106.camel@localhost.localdomain>
	 <4A149B89.3010104@kernel.org>
	 <1242866163.27006.10125.camel@localhost.localdomain>
	 <4A14B271.5010202@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 21 May 2009 12:10:08 -0700
Message-Id: <1242933008.27006.10150.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-20 at 18:46 -0700, Tejun Heo wrote:
> Yes it will.  The question is which way would be better.  Till now,
> there hasn't been any actual data on how remap compares to 4k. 

I am not sure if we see any measurable difference. Even if we use 4k
entries, it will be few  entries that kernel will be referring to
frequently.

> On NUMA, both remap and 4k add some level of TLB pressure.  remap will
> waste one more PMD TLB entry (dup) while 4k adds a bunch of 4k ones
> (non-dup but what used to be accessed by PMD TLB is now accessed with
> PTE TLB).  Some say using one more PMD TLB is better while others
> disagree.  So, the best course of action here seems to offer both and
> easy way to select between them so that data can be gathered, which is
> what this patchset does.

So with the planned future change of percpu unit allocation during cpu
online, you are planning to try large page allocation first and then
fallback to 4k pages, if that doesn't succeed. And then populate new
percpu ptr accordingly and then sort wrt to other cpu ptr's, so that we
can keep aliases in sync for future(and in parallel) cpa()'s that might
be happening.

There is nothing wrong with all this. Just the code complexity (and
maintenance) for what we are trying to gain ;)

> 
> I don't think the added complexity for cpa() justifies dropping remap
> without further testing.  The added complexity isn't that big.  Most
> of the confusion in this patchset came from my ignorance on the
> subject.  cpa() is a fragile thing but we need it anyway, so...
> 
> Thanks.
> 


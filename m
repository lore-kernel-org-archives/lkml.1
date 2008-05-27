Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbYE0SZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbYE0SZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759127AbYE0SYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:24:45 -0400
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:47710 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758211AbYE0SYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:24:44 -0400
Date: Tue, 27 May 2008 23:56:04 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080527182604.GK5181@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
Mail-Followup-To: Arjan van de Ven <arjan@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
	Michael Neuling <mikey@neuling.org>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org> <20080527140440.GD5181@dirshya.in.ibm.com> <20080527094035.67ccda32@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080527094035.67ccda32@infradead.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven <arjan@infradead.org> [2008-05-27 09:40:35]:

> On Tue, 27 May 2008 19:34:40 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> > 
> > What we are proposing is a scaled time value that is scaled to the
> > current CPU capacity.  If the scaled utilisation is 50% when the CPU
> > is at 100% capacity, it is expected to remain at 50% even if the CPU's
> > capacity is dropped to 50%, while the traditional utilisation value
> > will be 100%.
> 
> When you use the word "capacity" I cringe ;(
> 
> > 
> > The problem in the above two cases is that we had assumed that the
> > maximum CPU capacity is 100% at normal capacity (without IDA).
> > 
> > If the CPU is at half the maximum frequency, then scaled stats should
> > show 50%.  
> 
> see frequency != capacity.
> It's about more than frequency. It's about how much cache you have
> available too. If  you run single threaded on a dual core cpu, you have
> 100% of the cache, but the cpu is 50% idle. But that doesn't mean that
> when you double the load, you actually get 2x the performance. So
> you're not at 50% of capacity!
 
You are right.... I kind of interchangeably used frequency and
capacity assuming capacity is linearly proportional to frequency!

In reality, I agree that capacity is not linearly proportional to
frequency and it is dependent on cache usage etc.

The differences apart, I am sure I have conveyed the relationship
between scaled stats and CPU frequency. I used the term 'capacity' to
generalise CPU performance, but I guess it may lead to a different
discussion.  I will stick to frequency. :)

--Vaidy
 
> > The point I am trying to make is whether scaling should be done
> > relative to CPUs designed maximum capacity or maximum capacity under
> > current constraints is to be discussed.
> 
> now you're back at "capacity".. we were at frequency before ;(
> 
> 
> > 
> > Case A:
> > ------
> > 
> > Scaled stats is stats relative to maximum designed capacity including
> > IDA
> 
> you don't know what that is though.
> 

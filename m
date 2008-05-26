Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbYEZR3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbYEZR3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYEZR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:29:14 -0400
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:50198 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYEZR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:29:13 -0400
Message-ID: <483AF25B.6090806@linux.vnet.ibm.com>
Date: Mon, 26 May 2008 22:54:43 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com> <20080526085000.33787eac@infradead.org>
In-Reply-To: <20080526085000.33787eac@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Mon, 26 May 2008 20:01:33 +0530
> Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com> wrote:
> 
>> The following RFC patch tries to implement scaled CPU utilisation
>> statistics using APERF and MPERF MSR registers in an x86 platform.
>>
>> The CPU capacity is significantly changed when the CPU's frequency is
>> reduced for the purpose of power savings.  The applications that run
>> at such lower CPU frequencies are also accounted for real CPU time by
>> default.  If the applications have been run at full CPU frequency,
>> they would have finished the work faster and not get charged for
>> excessive CPU time.
>>
>> One of the solution to this problem it so scale the utime and stime
>> entitlement for the process as per the current CPU frequency.  This
>> technique is used in powerpc architecture with the help of hardware
>> registers that accurately capture the entitlement.
>>
> 
> there are some issues with this unfortunately, and these make it
> a very complex thing to do. 
> Just to mention a few:
> 1) What if the BIOS no longer allows us to go to the max frequency for
> a period (for example as a result of overheating); with the approach
> above, the admin would THINK he can go faster, but he cannot in reality,
> so there's misleading information (the system looks half busy, while in
> reality it's actually the opposite, it's overloaded). Management tools
> will take the wrong decisions (such as moving MORE work to the box, not
> less)
> 2) On systems with Intel Dynamic Acceleration technology, you can get
> over 100% of cycles this way. (For those who don't know what IDA is;
> IDA is basically a case where if your Penryn based dual core laptop is
> only using 1 core, the other core can go faster than 100% as long as
> thermals etc allow it). How do you want to deal with this?

Arjan,


These problems exist anyway, irrespective of scaled accounting (I'd say that
they are exceptions)

1. The management tool does have access to the current frequency and maximum
frequency, irrespective of scaled accounting. The decision could still be taken
on the data that is already available and management tools can already use them
2. With IDA, we'd have to document that APERF/MPERF can be greater than 100% if
the system is overclocked.

Scaled accounting only intends to provide data already available. Interpretation
is left to management tools and we'll document the corner cases that you just
mentioned.



-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL


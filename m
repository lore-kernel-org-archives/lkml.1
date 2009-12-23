Return-Path: <linux-kernel-owner+w=401wt.eu-S1755734AbZLWKZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbZLWKZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755695AbZLWKZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:25:49 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52630 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZLWKZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:25:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lOcN2+cYG/5mIZOidqoaFStD49hygBXJM/hw3P0CJiRNPpos4CMuDLoWHyQ5J08CJh
         j3zWjPqiatH64jHeEr4dh44bOAC1idxEd6yK4GfoqMdJvCX5V57OFS0c0tyAXmnE/dRQ
         uNfXNDoXUAd3zJ/YAqIpvJ4pyvja/HzPh5Qz0=
Message-ID: <4B31F028.7060209@garzik.org>
Date: Wed, 23 Dec 2009 05:25:44 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org>	 <1261143924.20899.169.camel@laptop> <4B2EE5A5.2030208@kernel.org>	 <1261387377.4314.37.camel@laptop> <4B2F7879.2080901@kernel.org>	 <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org>	 <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org>	 <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain>	 <20091223060229.GA14805@elte.hu>  <4B31B508.5040903@garzik.org> <1261557674.4937.117.camel@laptop>
In-Reply-To: <1261557674.4937.117.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2009 03:41 AM, Peter Zijlstra wrote:
> On Wed, 2009-12-23 at 01:13 -0500, Jeff Garzik wrote:
>> On 12/23/2009 01:02 AM, Ingo Molnar wrote:
>>> One key thing i havent seen in this discussion are actual measurements. I
>>> think a lot could be decided by simply testing this patch-set, by looking at
>>> the hard numbers: how much faster (or slower) did a particular key workload
>>> get before/after these patches.
>>
>> We are dealing with situations where drivers are using workqueues to
>> provide a sleep-able context, and trying to solve problems related to that.
>
> So why are threaded interrupts not considered? Isn't the typical atomic
> context of drivers the IRQ handler?


I don't see a whole lot of driver authors rushing to support threaded 
interrupts.  It is questionable whether the myriad crazy IDE interrupt 
routing schemes are even compatible.  Thomas's Mar 23 2009 email says 
"the primary handler must disable the interrupt at the device level" 
That is not an easy request for all the hardware libata must support.

But the most obvious reason is also the most compelling:  Tejun's work 
maps precisely to libata's needs.  And his work would seem to mesh well 
with other drivers in similar situations.

	Jeff



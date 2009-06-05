Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZFENno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZFENno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbZFENnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:43:37 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:46437 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbZFENng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:43:36 -0400
Date: Fri, 5 Jun 2009 19:13:20 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Menage <menage@google.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
Message-ID: <20090605134320.GA3994@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com> <4A291753.7090205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A291753.7090205@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 04:02:11PM +0300, Avi Kivity wrote:
> Paul Menage wrote:
>> On Wed, Jun 3, 2009 at 10:36 PM, Bharata B
>> Rao<bharata@linux.vnet.ibm.com> wrote:
>>   
>>> - Hard limits can be used to provide guarantees.
>>>
>>>     
>>
>> This claim (and the subsequent long thread it generated on how limits
>> can provide guarantees) confused me a bit.
>>
>> Why do we need limits to provide guarantees when we can already
>> provide guarantees via shares?
>>
>> Suppose 10 cgroups each want 10% of the machine's CPU. We can just
>> give each cgroup an equal share, and they're guaranteed 10% if they
>> try to use it; if they don't use it, other cgroups can get access to
>> the idle cycles.
>>
>> Suppose cgroup A wants a guarantee of 50% and two others, B and C,
>> want guarantees of 15% each; give A 50 shares and B and C 15 shares
>> each. In this case, if they all run flat out they'll get 62%/19%/19%,
>> which is within their SLA.
>>
>> That's not to say that hard limits can't be useful in their own right
>> - e.g. for providing reproducible loadtesting conditions by
>> controlling how much CPU a service can use during the load test. But I
>> don't see why using them to implement guarantees is either necessary
>> or desirable.
>>
>> (Unless I'm missing some crucial point ...)
>>   
>
> How many shares does a cgroup with a 0% guarantee get?
>

Shares cannot be used to provide guarantees. All they decide is what
propotion groups can get CPU time. (yes, shares is a bad name, weight
shows the intent better).

thanks,
-- 
regards,
Dhaval

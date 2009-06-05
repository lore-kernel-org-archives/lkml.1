Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZFENEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZFENEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbZFENEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:04:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43310 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbZFENEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:04:14 -0400
Message-ID: <4A291753.7090205@redhat.com>
Date: Fri, 05 Jun 2009 16:02:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com> <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
In-Reply-To: <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Wed, Jun 3, 2009 at 10:36 PM, Bharata B
> Rao<bharata@linux.vnet.ibm.com> wrote:
>   
>> - Hard limits can be used to provide guarantees.
>>
>>     
>
> This claim (and the subsequent long thread it generated on how limits
> can provide guarantees) confused me a bit.
>
> Why do we need limits to provide guarantees when we can already
> provide guarantees via shares?
>
> Suppose 10 cgroups each want 10% of the machine's CPU. We can just
> give each cgroup an equal share, and they're guaranteed 10% if they
> try to use it; if they don't use it, other cgroups can get access to
> the idle cycles.
>
> Suppose cgroup A wants a guarantee of 50% and two others, B and C,
> want guarantees of 15% each; give A 50 shares and B and C 15 shares
> each. In this case, if they all run flat out they'll get 62%/19%/19%,
> which is within their SLA.
>
> That's not to say that hard limits can't be useful in their own right
> - e.g. for providing reproducible loadtesting conditions by
> controlling how much CPU a service can use during the load test. But I
> don't see why using them to implement guarantees is either necessary
> or desirable.
>
> (Unless I'm missing some crucial point ...)
>   

How many shares does a cgroup with a 0% guarantee get?

Ideally, the scheduler would hand out cpu time according to weight and 
demand, then clamp over-demand by a cgroup's limit and boost the share 
to meet guarantees.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbZFHIv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbZFHIv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 04:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZFHIvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 04:51:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5415 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZFHIvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 04:51:51 -0400
Message-ID: <4A2CD0EB.5080900@openvz.org>
Date: Mon, 08 Jun 2009 12:50:51 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Dhaval Giani <dhaval@linux.vnet.ibm.com>, bharata@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Subject: Re: [RFC] CPU hard limits
References: <20090604053649.GA3701@in.ibm.com>	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>	 <20090605092733.GA27486@in.ibm.com>	 <6599ad830906050232n11aa30d8xfcda0a279a482f32@mail.gmail.com>	 <20090605094811.GD4601@linux.vnet.ibm.com>	 <6599ad830906050251h18f4e037h182f61aa80a5b046@mail.gmail.com>	 <20090605095931.GE4601@linux.vnet.ibm.com> <6599ad830906050303r404c325anc60ded4f45a50b95@mail.gmail.com>
In-Reply-To: <6599ad830906050303r404c325anc60ded4f45a50b95@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Fri, Jun 5, 2009 at 2:59 AM, Dhaval Giani<dhaval@linux.vnet.ibm.com> wrote:
>> I think we are focusing on the wrong use case here. Guarantees is just a
>> useful side-effect we get by using hard limits. I think the more
>> important use case is where the provider wants to limit the amount of
>> time a user gets (such as in a cloud).
>>
>> Maybe we should direct our attention in solving that problem? :)
>>
> 
> Yes, that case and the "predictable load test behaviour" case are both
> good reasons for hard limits.

ACK.

I'd like to add two things.

First, the article @openvz.org about guarantees you were discussing was 
not supposed to be a "best practices" paper. This was just a theoretical
thoughts on how to get guarantees out of the limit for those resources 
you cannot reclaim from the user and thus cannot provide the guarantee 
any other way. E.g. locked memory - once a user has it you cannot take 
it back, and if you want to guarantee some mount of it for group X you
have to keep all the other groups away from this amount.

And the second thing is an addition for Dhaval's case about limiting the 
amount of time a user gets. This is exactly what hosting providers do -
they _sell_ the CPU power to their customers and thus need to limit the
CPU time dedicated for containers.

> Paul
> 


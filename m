Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbZFENt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbZFENt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZFENtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:49:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:49436 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbZFENtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:49:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lRMpmaXDIfo2w1BjElv5Tm2xzs+nrUuSfTThq+Tibc1/bwQZFkOEpiNmizU2zgOzwB
         C80tYUFi7KmdFaC8V+tNY93bcpKjLU0xqZBUA//sKq5VI+01/tKKCpJQGEsZkFKUnSoH
         83TIadqcZx5DsWvngUqucxWbj0IMVmAgeVX1E=
MIME-Version: 1.0
In-Reply-To: <4A291A2F.3090201@redhat.com>
References: <20090605030309.GA3872@in.ibm.com> <4A28A2AB.3060108@redhat.com>
	 <20090605044946.GA11755@balbir.in.ibm.com>
	 <20090605051050.GB11755@balbir.in.ibm.com>
	 <4A28AB67.7040800@redhat.com>
	 <20090605052755.GE11755@balbir.in.ibm.com>
	 <20090605053159.GB3872@in.ibm.com> <4A28B4CE.4010004@redhat.com>
	 <20090605093947.GJ11755@balbir.in.ibm.com>
	 <4A291A2F.3090201@redhat.com>
Date: Fri, 5 Jun 2009 19:12:26 +0530
X-Google-Sender-Auth: b764497af4873cdd
Message-ID: <661de9470906050642s7774d601l53e366c77ffa7475@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 6:44 PM, Avi Kivity<avi@redhat.com> wrote:
> Balbir Singh wrote:
>>>
>>> That's the limit part.  I'd like to be able to specify limits and
>>>  guarantees on the same host and for the same groups; I don't think that
>>>  works when you advance the bandwidth period.
>>>
>>
>> Yes, this feature needs to be configurable. But your use case for both
>> limits and guarantees is interesting. We spoke to Peter and he was
>> convinced only of the guarantee use case. Could you please help
>> elaborate your use case, so that we can incorporate it into RFC v2 we
>> send out. Peter is opposed to having hard limits and is convinced that
>> they are not generally useful, so far I seen you and Paul say it is
>> useful, any arguments you have or any +1 from you will help us. Peter
>> I am not back stabbing you :)
>>
>
> I am selling virtual private servers.  A 10% cpu share costs $x/month, and I
> guarantee you'll get that 10%, or your money back.  On the other hand, I
> want to limit cpu usage to that 10% (maybe a little more) so people don't
> buy 10% shares and use 100% on my underutilized servers.  If they want 100%,
> let them pay for 100%.

Excellent examples, we've covered them in the RFC, could you see if we
missed anything in terms of use cases? The real question is do we care
enough to build hard limits control into the CFS group scheduler. I
believe we should.

>
>>> I think we need to treat guarantees as first-class goals, not something
>>>  derived from limits (in fact I think guarantees are more useful as they
>>>  can be used to provide SLAs).
>>>
>>
>> Even limits are useful for SLA's since your b/w available changes
>> quite drastically as we add or remove groups. There are other use
>> cases for limits as well
>
> SLAs are specified in terms of guarantees on a service, not on limits on
> others.  If we could use limits to provide guarantees, that would be fine,
> but it doesn't quite work out.

To be honest, I would disagree here, specifically if you start
comparing how you would build guarantees in the kernel and compare it
with the proposed approach. I don't want to harp on the technicality,
but point out the feasibility for people who care for lower end of the
guarantee without requiring density. I think the real technical
discussion should be on here are the use cases, lets agree on the need
for the feature and go ahead and start prototyping the feature.

Thanks,
Balbir

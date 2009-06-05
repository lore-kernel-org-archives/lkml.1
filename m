Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZFEJv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZFEJv1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 05:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZFEJvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 05:51:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4178 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZFEJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 05:51:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=iV6oHeTgECpp8/9fQBiuPspoOyPExQYsEfZabjPUs4eNf8yKgQVW9Ztz3+SFGZkdK
	1+Wgivh/2590AnkJIjzTQ==
MIME-Version: 1.0
In-Reply-To: <20090605094811.GD4601@linux.vnet.ibm.com>
References: <20090604053649.GA3701@in.ibm.com>
	 <6599ad830906050153i1afd104fqe70f681317349142@mail.gmail.com>
	 <20090605092733.GA27486@in.ibm.com>
	 <6599ad830906050232n11aa30d8xfcda0a279a482f32@mail.gmail.com>
	 <20090605094811.GD4601@linux.vnet.ibm.com>
Date: Fri, 5 Jun 2009 02:51:18 -0700
Message-ID: <6599ad830906050251h18f4e037h182f61aa80a5b046@mail.gmail.com>
Subject: Re: [RFC] CPU hard limits
From: Paul Menage <menage@google.com>
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pavel Emelyanov <xemul@openvz.org>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org,
       Linux Containers <containers@lists.linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 5, 2009 at 2:48 AM, Dhaval Giani<dhaval@linux.vnet.ibm.com> wrote:
>> > Now if 11th group with same shares comes in, then each group will now
>> > get 9% of CPU and that 10% guarantee breaks.
>>
>> So you're trying to guarantee 11 cgroups that they can each get 10% of
>> the CPU? That's called over-committing, and while there's nothing
>> wrong with doing that if you're confident that they'll not all need
>> their 10% at the same time, there's no way to *guarantee* them all
>> 10%. You can guarantee them all 9% and hope the extra 1% is spare for
>> those that need it (over-committing), or you can guarantee 10 of them
>> 10% and give the last one 0 shares.
>>
>> How would you propose to guarantee 11 cgroups each 10% of the CPU
>> using hard limits?
>>
>
> You cannot guarantee 10% to 11 groups on any system (unless I am missing
> something). The sum of guarantees cannot exceed 100%.

That's exactly my point. I was trying to counter Bharata's statement, which was:

> > Now if 11th group with same shares comes in, then each group will now
> > get 9% of CPU and that 10% guarantee breaks.

which seemed to be implying that this was a drawback of using shares
to implement guarantees.

Paul

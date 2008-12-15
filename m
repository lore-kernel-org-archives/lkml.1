Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbYLOM63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbYLOM63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 07:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYLOM6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 07:58:21 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56560 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYLOM6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 07:58:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=EwqIwanHiVc/eOAXy9UqVF5UyUaF15ljcMqTBgjZCX1Ke5iAzXEu0Og9645vwxW85y
         QlDjMm1n0yA4EAcjUt3yx4o+OIHhaLAVDk/VwplneJznVsPlgt0t9ChlWyEXOrQwE1vW
         fJYSr1YfGULIGYFvomKt3cevnfQ7a73dUCWcg=
Message-ID: <7c86c4470812150458o47292790gf143fb035bf1e06d@mail.gmail.com>
Date: Mon, 15 Dec 2008 13:58:18 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Vince Weaver" <vince@deater.net>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <18757.42682.109305.676647@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
	 <7c86c4470812120059s7f8e64a6h91ebeadbf938858d@mail.gmail.com>
	 <1229073834.12883.41.camel@twins>
	 <7c86c4470812120942x607a74f7w9f823adecbd73b85@mail.gmail.com>
	 <7c86c4470812121001i765d663bq6db3080b633a1eef@mail.gmail.com>
	 <20081214231332.GA26942@elte.hu>
	 <18757.42682.109305.676647@drongo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 15, 2008 at 1:37 AM, Paul Mackerras <paulus@samba.org> wrote:
> Ingo Molnar writes:
>
>> * stephane eranian <eranian@googlemail.com> wrote:
>>
>> > Hi,
>> >
>> > Given the level of abstractions you are using for the API, and given
>> > your argument that the kernel can do the HW resource scheduling better
>> > than anybody else.
>> >
>> > What happens in the following test case:
>> >
>> >    - 2-way system (cpu0, cpu1)
>> >
>> >    - on cpu0, two processes P1, P2, each self-monitoring and counting event E1.
>> >      Event E1 can only be measured on counter C1.
>> >
>> >    - on cpu1, there is a cpu-wide session, monitoring event E1, thus using C1
>> >
>> >    - the scheduler decides to migrate P1 onto CPU1. You now have a
>> >      conflict on C1.
>> >
>> > How is this managed?
>>
>> If there's a single unit of sharable resource [such as an event counter,
>> or a physical CPU], then there's just three main possibilities: either
>> user 1 gets it all, or user 2 gets it all, or they share it.
>>
>> We've implemented the essence of these variants, with sharing the resource
>> being the sane default, and with the sysadmin also having a configuration
>> vector to reserve the resource to himself permanently. (There could be
>> more variations of this.)
>>
>> What is your point?
>>
Could you explain what you mean by sharing here?

Are you talking about time multiplexing the counter?

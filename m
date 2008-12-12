Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbYLLIfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbYLLIfz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbYLLIfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:35:47 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:63651 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbYLLIfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:35:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=QbfnLzJ9NRgek3UzIGMrZzKbs5VOrq6k+4K25AQ+IaI6RNC37eMY2BtpjnA3xmb6Qs
         NjGgIk2/3M1U8GoNnxjf00mqFJstuCpsl2XmrIJ2hlv8JFmYIuP8/wmnWwvJ1WJ8/K4M
         fVN/QKcrG4Jv7jbFYZYnYECxeJe4SKgDGBEYQ=
Message-ID: <7c86c4470812120035i4ba84180p70dd55e203d8035f@mail.gmail.com>
Date: Fri, 12 Dec 2008 09:35:43 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch] Performance Counters for Linux, v3
Cc: "Vince Weaver" <vince@deater.net>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Veen" <arjan@infradead.org>,
       "Peter Anvin" <hpa@zytor.com>, "Paul Mackerras" <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <1229070345.12883.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081211155230.GA4230@elte.hu>
	 <Pine.LNX.4.64.0812111247510.22556@pianoman.cluster.toy>
	 <1229070345.12883.12.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Fri, Dec 12, 2008 at 9:25 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>> > +   /*
>> > +    * Common hardware events, generalized by the kernel:
>> > +    */
>> > +   PERF_COUNT_CYCLES               =  0,
>> > +   PERF_COUNT_INSTRUCTIONS         =  1,
>> > +   PERF_COUNT_CACHE_REFERENCES     =  2,
>> > +   PERF_COUNT_CACHE_MISSES         =  3,
>> > +   PERF_COUNT_BRANCH_INSTRUCTIONS  =  4,
>> > +   PERF_COUNT_BRANCH_MISSES        =  5,
>>
>> Many machines do not support these counts.  For example, Niagara T1 does
>> not have a CYCLES count.  And good luck if you think you can easily come
>> up with something meaningful for the various kind of CACHE_MISSES on the
>> Pentium 4.  Also, the Pentium D has various flavors of retired instruction
>> count with slightly different semantics.  This kind of abstraction should
>> be done in userspace.
>
> I'll argue to disagree, sure such events might not be supported by any
> particular hardware implementation - but the fact that PAPI gives a list
> of 'common' events means that they are, well, common. So unifying them
> between those archs that do implement them seems like a sane choice, no?
>
> For those archs that do not support it, it will just fail to open. No
> harm done.
>
> The proposal allows for you to specify raw hardware events, so you can
> just totally ignore this part of the abstraction.
>
I believe the cache related events do not belong in here. There is no definition
for them. You don't know what cache miss level, what kind of access. You cannot
do this even on Intel Core processors.

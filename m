Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZHTKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZHTKN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZHTKNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 06:13:25 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62243 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZHTKNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 06:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=deoCk7E3lCOepoy+G+9UK03woHGtKJAOA6vMD1JWd51Nvc0H2FoCranNZp5vD6yVlV
         CFY08pwfd//yo7DTncUGOutvZxt4SOBfPNDwBluzKcYkKI9dGwuItCFiGc+P0vURi4Mk
         Y4imfWe/Sz4hnAjQvJJkoOpp2c3+Ja/5pkezE=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1250686586.8282.12.camel@twins>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.980284148@chello.nl>
	 <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
	 <1250686586.8282.12.camel@twins>
Date: Thu, 20 Aug 2009 12:13:25 +0200
Message-ID: <7c86c4470908200313l112a8ff6q836d618d7ce6fcc8@mail.gmail.com>
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 2:56 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Wed, 2009-08-19 at 22:36 +1000, Paul Mackerras wrote:
>> Peter Zijlstra writes:
>>
>> > Provide the ability to configure a counter to send its output to
>> > another (already existing) counter's output stream.
>>
>> What sort of thing might this be useful for?
>
> Some people complained that its tedious to mmap() for every counter and
> would like to share the mmap() output buffer between counters.
>

> This saves on address space and mlock budget and I guess fd management
> logic.
>
Interesting to see, you seem to have changed your mind on this.
I recall pointing this out in my early comments.

But anyway, here are some more comments:

   - how does this work with the remapped counts?
     Probably only see the count for the target, i.e., output,  event

   - if samples from multiple events end up in the same buffer, how do
I tell them apart,
     i.e., how do I know sample X came from event A, sample X from event B?
     This may be useful to detect patterns.


> As long as you're not mixing counters for different tasks/cpus there
> should be no performance penalty, but even if you do that it might work
> well enough on slow samples/small systems..
>
>> Does this only apply to sampling counters?
>
> Yeah, everything that would otherwise go through the mmap() buffer.
>
> I'm not sure there's anything to be done about the read(2) thing.
>
>

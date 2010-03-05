Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab0CECeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:34:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:22111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0CECeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:34:15 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fic7A0KWzGtMkgJRG6L5y2o04U/LMjPR1KQHQfokLNHD292Iax21f63xbWHOAOvW8
	9arYhO1QWy16tzvt4T1nQ==
MIME-Version: 1.0
In-Reply-To: <20100304211332.GA3643@elte.hu>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
	 <20100304113212.GG21977@elte.hu>
	 <bd4cb8901003040925t28ddcc5bmfce11dcfa8b9b0ba@mail.gmail.com>
	 <20100304211332.GA3643@elte.hu>
Date: Thu, 4 Mar 2010 18:34:09 -0800
Message-ID: <bd4cb8901003041834l61bc510er21c9da4de8639d9b@mail.gmail.com>
Subject: Re: [PATCH] perf_events: add sampling period randomization support 
	(v2)
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com, davem@davemloft.net,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 1:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> On Thu, Mar 4, 2010 at 3:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * eranian@google.com <eranian@google.com> wrote:
>> >
>> >> This patch adds support for randomizing the sampling period. ??Randomization
>> >> is very useful to mitigate the bias that exists with sampling. The random
>> >> number generator does not need to be sophisticated. This patch uses the
>> >> builtin random32() generator.
>> >
>> >> + ?? ?? if (width > 63 || attr->freq)
>> >> + ?? ?? ?? ?? ?? ?? return -EINVAL;
>> >
>> > Why not for freq counters? Those are semi-randomized already, but it might
>> > make sense to make them 'more' randomized in special circumstances. That would
>> > also allow us to enable the randomization in perf top and perf record, by
>> > default.
>> >
>>
>> What's the goal of freq?
>> Achieve and maintain the target interrupt/rate.
>> In doing so, it has to adjust the period (not randomly).
>
> No, the goal of auto-freq is to keep a steady average rate of sampling.
>
rate of samples = rate of interrupts (if period < 32 bits on Intel).

> There is no requirement to keep it 'steady' - each sample comes with a
> specific weight.
>
>> Randomization may prevent achieving the rate, or it may slow
>> it down. What's the value add of that?
>
> Why do you assume that the two are incompatible? We can randomize auto-freq
> and still have a perfectly stable average rate.
>
What would that buy you compared to what you already have?

> We know how long each sample takes so the result is precise, via
> PERF_SAMPLE_PERIOD.
>
I understand that.

> -c is legacy in essence. The default is auto-freq and i doubt anyone uses -c
> anymore.
>
The -c option may be more convenient when not counting events correlated with
time.

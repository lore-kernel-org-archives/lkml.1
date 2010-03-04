Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab0CDR0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 12:26:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:55260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0CDR0B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 12:26:01 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KiHN1hrD2zA+2yXwiFW/KioDpWVwGbovRLAcc74xZMURn+0x+ATGBOVnmgyYPsPdg
	m3uis+1NlUlmbbFN+4HeQ==
MIME-Version: 1.0
In-Reply-To: <20100304113212.GG21977@elte.hu>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
	 <20100304113212.GG21977@elte.hu>
Date: Thu, 4 Mar 2010 09:25:56 -0800
Message-ID: <bd4cb8901003040925t28ddcc5bmfce11dcfa8b9b0ba@mail.gmail.com>
Subject: Re: [PATCH] perf_events: add sampling period randomization support 
	(v2)
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com, davem@davemloft.net,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 3:32 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * eranian@google.com <eranian@google.com> wrote:
>
>> This patch adds support for randomizing the sampling period.  Randomization
>> is very useful to mitigate the bias that exists with sampling. The random
>> number generator does not need to be sophisticated. This patch uses the
>> builtin random32() generator.
>
>> +     if (width > 63 || attr->freq)
>> +             return -EINVAL;
>
> Why not for freq counters? Those are semi-randomized already, but it might
> make sense to make them 'more' randomized in special circumstances. That would
> also allow us to enable the randomization in perf top and perf record, by
> default.
>
What's the goal of freq?
Achieve and maintain the target interrupt/rate.
In doing so, it has to adjust the period (not randomly).

Randomization may prevent achieving the rate, or it may slow
it down. What's the value add of that?

> Without that we'd have no immediate usecase and no way to ensure that this
> code works as intended.
>
Why?
With perf you also have fixed sampling period (-c option), you simply need to
express the fact you want it randomized.

> Thanks,
>
>        Ingo
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753801AbYKKRYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbYKKRYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:24:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYKKRYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:24:25 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:47122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565AbYKKRYX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:24:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qkZFAI1zh/HKtDYmIwNMvYWv+UNennSz5eIWvnRM6iqTN7FYmOyNBGAjimXkVFXy1H
         drIspC6o175EyQDcEVtAFiXi/Jc+Ymd8liOvygmO73QQAb6nSF1j7KEjBcE3CMAGkLpu
         p4qXo3PiuT1qPlInhAtXWthV1SMhmpziqmLcI=
Message-ID: <c62985530811110924p28d3ff7i3ce8ff0d86ca2fb8@mail.gmail.com>
Date: Tue, 11 Nov 2008 18:24:21 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC v3][PATCH 0/2] Make ftrace able to trace function return
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081111171455.GA8201@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu>
	 <c62985530811110730x13bc92abo891b49934ea2ae6f@mail.gmail.com>
	 <20081111171455.GA8201@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/11 Ingo Molnar <mingo@elte.hu>:
>
> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>
>> >  2) i cleaned up the arch/x86/Kconfig impact:
>> >
>> >      f1c4be5: tracing, x86: clean up FUNCTION_RET_TRACER Kconfig
>>
>>
>> Ok.
>> And concerning the constraint fixed in assembly. That's strange my
>> compiler didn't even warn me about it.
>
> yep, that's common with assembly constraints - often the bugs will
> only trigger with certain compilers and with certain config options.
> Generally we've got enough variations of these parameters in -tip
> testing (randconfig plus multiple tools versions) to reliably trigger
> such issues.


I love -tip testing :-)


>> > So lets use "function_full" and "function" tracing perhaps? The
>> > "full" tracer is what traces both entry and exit points, and
>> > establishes full function-call timings/costs. The "function"
>> > tracer is more lightweight and traces function entry events.
>>
>> Right. I first chose function_return but it was the largest tracer
>> name and so raised a bug that has been corrected since. And I kept
>> this confusing name.
>>
>> I'm not sure function_full is really the good one because it's not
>> really a full version of the function tracer. It doesn't do the same
>> thing: when you look into a trace done by the function tracer, the
>> functions appear in order of their call whereas with the function
>> return tracer, they appear in the order of their return which is not
>> the same. The effect is not the same. Why not function_return or
>> something like that?
>
> at the risk of bikeshed-painting this issue too much, the problem with
> function_return is that it has little meaning to actual users and even
> to developers. What does the "return" mean? We know what it means,
> because we know that opposed to function entry we'll also capture
> function returns, and hence be able to do full function call tracing.
>
> so function_full i thought to conduct this aspect of it better. But
> suggestions are welcome.


Ok. Let's change into function_full, after all, I think that this tool
will be mostly used  with a parsing pass
of its traces with a script to produce statistics and hierarchical
representation like does draw_functrace.py
After that, the order of apparition of the functions in the trace will
not really matter.

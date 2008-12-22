Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbYLVKq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbYLVKq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 05:46:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYLVKqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 05:46:49 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:23445 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbYLVKqs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 05:46:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KZiGkrW5m7J/8DB6jEGSZl27nrzBvPpVrUTY0NwnxJXtcE33KwGu0JCUdQzCv7f1EB
         XLxX8cfOyfPozxVx6WiZhVr3odkKhGzERuFnm1YbdV2DB08ltf+/aXZB80cKfO2Z6zyD
         zmcpod57xVjTzKUFK18KsLTUKZ6fe5u9+4F1Y=
Message-ID: <c62985530812220246m3801c3f0k8db435f8c9af04e0@mail.gmail.com>
Date: Mon, 22 Dec 2008 11:46:47 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH v2] tracing/function-graph-tracer: prevent from hrtimer interrupt infinite loop
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530812210421w8e2af3ai2cae7440b2297a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <4949A2CC.6040209@gmail.com>
	 <alpine.LFD.2.00.0812181136410.3492@localhost.localdomain>
	 <20081218112216.GE14332@elte.hu>
	 <c62985530812181307k4fc35770x3698101b3981879a@mail.gmail.com>
	 <20081218211637.GF24271@elte.hu>
	 <c62985530812181336m6ab39c8ah410dff763bd02d24@mail.gmail.com>
	 <20081218214458.GA30834@elte.hu> <20081221100047.GA31074@elte.hu>
	 <20081221101226.GA6021@elte.hu>
	 <c62985530812210421w8e2af3ai2cae7440b2297a2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/21 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/12/21 Ingo Molnar <mingo@elte.hu>:
>>
>> * Ingo Molnar <mingo@elte.hu> wrote:
>>
>>> btw., a graph-tracer buglet i noticed:
>>
>> another thing. I turned off all the options that come ahead of the 'meat'
>> of the trace data:
>>
>> # cat /debug/tracing/trace_options
>> print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock
>> nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate
>> nouserstacktrace nosym-userobj printk-msg-only nofuncgraph-overrun
>> nofuncgraph-cpu nofuncgraph-overhead nofuncgraph-proc
>>
>> but i still got the 'duration' field printed:
>>
>> # tracer: function_graph
>> #
>> # DURATION            FUNCTION CALLS
>> #     |               |   |   |   |
>>
>> 0.865 us    |    }
>>            |    alloc_page_vma() {
>> 0.295 us    |      get_vma_policy();
>> 0.268 us    |      policy_zonelist();
>>            |      __alloc_pages_internal() {
>> 0.257 us    |        __might_sleep();
>>            |        get_page_from_freelist() {
>>
>>
>> i'd have expected to only see the flow of execution as it happens.
>>
>>        Ingo
>>
>
>
> Strange. I will test that.
>

Did I say it was strange? No it isn't, there is no option to turn off
the duration :-)
I will add one.

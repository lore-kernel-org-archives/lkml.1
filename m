Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYJ1JCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYJ1JCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 05:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYJ1JCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 05:02:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:34383 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYJ1JCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 05:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kv4ZaHNuj4O0EeeeMcXwOW9AJRn8iGeVoDyPhq7f4a5SYfWSYakNA/IMD/a5JP0EZ7
         RFCOPG4ctg1r+Q63jb5Gb+EDqpGcVWWVoERM8GTiPDpabC3tXFreICUWe3CSDKiPFe3p
         mcn/e8zgehGrWFOfQrfryjXx56FAAVeyrlJfI=
Message-ID: <c62985530810280202r694a23e8l5233d892b3aa4330@mail.gmail.com>
Date: Tue, 28 Oct 2008 10:02:09 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: Ftrace doesn't work anymore on latest tip
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <c62985530810271618n11a8b674w5a60deaa335fdcc2@mail.gmail.com>
	 <alpine.DEB.1.10.0810271935320.20039@gandalf.stny.rr.com>
	 <c62985530810271644y1df6a13xbcd9d89b7a17ad75@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/28 Frédéric Weisbecker <fweisbec@gmail.com>:
> 2008/10/28 Steven Rostedt <rostedt@goodmis.org>:
>>
>> On Tue, 28 Oct 2008, Fr?d?ric Weisbecker wrote:
>>
>>> Hi,
>>>
>>> I tried to launch the function tracer with the latest -tip.
>>> With DYNAMIC_FTRACE (I just tried one time), I set "function" to
>>> current_trace and it blocks during writing. I can't
>>> even switch to another console.
>>> Without DYNAMIC_FTRACE I can set the tracer to function but it doesn't
>>> produce any trace, even on trace or tracing_pipe.
>>>
>>> My config is in attachment.
>>> I will try some revert...or some other tracers.
>>>
>>
>>
>> You might want to update your config (make oldconfig?) The latest tip has
>> FUNCTION_TRACER instead of FTRACE.
>>
>> Also, the config you sent me, does not even have FTRACE on :-/
>>
>> CONFIG_HAVE_FTRACE=y
>> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>> CONFIG_TRACER_MAX_TRACE=y
>> CONFIG_RING_BUFFER=y
>> CONFIG_TRACING=y
>> # CONFIG_FTRACE is not set
>> # CONFIG_IRQSOFF_TRACER is not set
>> # CONFIG_PREEMPT_TRACER is not set
>> # CONFIG_SYSPROF_TRACER is not set
>> CONFIG_SCHED_TRACER=y
>> CONFIG_CONTEXT_SWITCH_TRACER=y
>
> Sorry I sent a config for the mainline.
> This new one is the right.
>

One other point: I can't assign the sched_switch tracer.
echo sched_switch > current_tracer returns -EINVAL with
CONFIG_DYNAMIC_FTRACE disabled (didn't tested with enabled).

I will check that more deeper when I'll have more time.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYJZX0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYJZX0n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 19:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYJZX0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 19:26:34 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:53433 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbYJZX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 19:26:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=H/Q8KVd+1x/taD49SvPu+Ssw9z8GtiVQgGvCnyYHZeb19yTCWv/HU+mUiHNN6ejX89
         bXHWjdKjI58C4jOpWyPa0jw27hI2/ybPy+UEs0o7rm29bDNw44Ngj+rLoGpEN1c198rL
         Js/XORGHLI4p15CiihjQn2R/PfrEqJwDVC8lY=
Message-ID: <c62985530810261626r2b80a1ebne7d26fa71b3c364c@mail.gmail.com>
Date: Mon, 27 Oct 2008 00:26:31 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical view of a function trace
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4904DF39.9070203@gmail.com>
	 <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/27 Steven Rostedt <rostedt@goodmis.org>:
>
>
> On Sun, 26 Oct 2008, Frederic Weisbecker wrote:
>
>> This script parses a function trace and then produces a hierarchical view of the
>> function call stack after processing it into a tree.
>>
>> You can see the result on attachment. You will find the raw trace and the hierarchical view.
>
> Very nice and useful tool!
>
> Just one thing...
>
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>> diff --git a/scripts/draw_functrace.py b/scripts/draw_functrace.py
>> new file mode 100755
>> index 0000000..e6496bd
>> --- /dev/null
>> +++ b/scripts/draw_functrace.py
>> @@ -0,0 +1,119 @@
>> +#!/usr/bin/python
>> +
>> +"""
>> +Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
>> +Licensed under the terms of the GNU GPL License version 2
>> +
>> +This script parses a trace provided by the function tracer in
>> +kernel/trace/trace_functions.c
>> +The resulted trace is processed into a tree to produce a more human
>> +view of the call stack by drawing textual but hierarchical tree of
>> +calls. Only the functions's names and the the call time are provided.
>> +
>> +Usage:
>> +     Be sure that you have CONFIG_FUNCTION_TRACER
>> +     # mkdir /debugfs
>> +     # mount -t debug debug /debug
>> +     # echo function > /debug/tracing/current_tracer
>> +     # cat /debug/tracing/current_tracer > ~/raw_trace_func
>
> Do you really mean to write "function" into ~/raw_trace_func?


Oops. No I wanted to write

cat /debug/tracing/trace_pipe > ~/raw_trace_func

> Also, I just tried this out (replacing current_tracer with trace) and I
> just get ---Root (Nowhere)

Really? Could you send me your trace? Perhaps a problem with the
regular expression.

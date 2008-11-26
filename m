Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYKZSYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYKZSYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbYKZSYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:24:23 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:50857 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYKZSYW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:24:22 -0500
X-BigFish: VPS-49(z34a4jz1432R1453M98dR168aJ936eQ1805M936fO3117Kzzzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <492D940F.6090500@am.sony.com>
Date: Wed, 26 Nov 2008 10:23:11 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?UTF-8?B?77+9?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic
 ftrace on function return tracer
References: <491FA94E.9090207@gmail.com>	 <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com> <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
In-Reply-To: <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 26 Nov 2008 18:23:11.0895 (UTC) FILETIME=[0A39E270:01C94FF4]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

� wrote:
> 2008/11/24 Steven Rostedt <rostedt@goodmis.org>:
>> On Sun, 16 Nov 2008, Frederic Weisbecker wrote:
>>>  static void ftrace_replace_code(int enable)
>>> @@ -1405,10 +1417,17 @@ int register_ftrace_function(struct ftrace_ops *ops)
>>>               return -1;
>>>
>>>       mutex_lock(&ftrace_sysctl_lock);
>>> +
>>> +     if (ftrace_tracing_type == FTRACE_TYPE_RETURN) {
>>> +             ret = -EBUSY;
>>> +             goto out;
>>> +     }
>>> +
>> Why do we need to disable all new tracing functions when we do return
>> tracing??
>>
>> -- Steve
>>
>>>       ret = __register_ftrace_function(ops);
>>>       ftrace_startup();
>>> -     mutex_unlock(&ftrace_sysctl_lock);
>>>
>>> +out:
>>> +     mutex_unlock(&ftrace_sysctl_lock);
>>>       return ret;
>>>  }
>>>
> 
> You will see the same test when trying to register a return handler,
> it verifies that normal ftrace is not running.
> Otherwise it will fail.
> I made ftrace and ftrace-return not abled to work simultaneously for the moment.
> That made the integration of ftrace-return into dynamic tracing much
> more simpler...
> 
> But if someone needs to enable both tracing at the same time, I can change it...

Very sorry I'm coming to this thread late.  I didn't notice it until
today.

Not to question the whole approach, and sorry if this was
discussed before, but why wasn't -finstrument-functions used
to instrument the function exits.  This worked well for KFT
(See http://elinux.org/Kernel_Function_Trace).  I'm not sure if the
function prologue and epilogue modifications done by -mcount are
different than -finstrument-functions, but I thought I remember something
about Steven testing -finstrument-functions in an early version of ftrace.

By the way, I'm really excited to see this "function_cost" stuff being
worked on.  It has proven to be extremely useful for analyzing early boot
latencies at Sony.

Sorry again I didn't catch this and previous related threads
earlier.  I have some post-processing tools which might be useful here.
Also, I've found it very handy to have the capability to filter by minimum
function duration.  Is there any work to do that with the
current system.  If not, maybe I could take a look at that and see if
I can add something.

Regards,
 -- Tim


=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================


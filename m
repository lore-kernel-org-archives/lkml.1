Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYKXWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYKXWVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 17:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbYKXWVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 17:21:04 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:40934 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbYKXWVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 17:21:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nAV+WvBsrs4oCHI2PKHZFdWS+0a5dtbA1pxqi3f6uujD7rfSj8kVOmRtpFhBCmoa5Q
         b37GSQNnacRMZb+7kvXlRSYTTsFmVPwphe7ngoxlZ3+fjNRMLFtuzzRkR507ouAeMEg+
         VOAe8BIzxtALNgGCTvNf6QdprfmeQyHyMy80A=
Message-ID: <c62985530811241421t1cd56b4el1ada0754df9a229@mail.gmail.com>
Date: Mon, 24 Nov 2008 23:21:00 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH 4/4] tracing/function-return-tracer: Support for dynamic ftrace on function return tracer
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491FA94E.9090207@gmail.com>
	 <alpine.DEB.1.10.0811241707240.907@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/24 Steven Rostedt <rostedt@goodmis.org>:
>
> On Sun, 16 Nov 2008, Frederic Weisbecker wrote:
>>
>>  static void ftrace_replace_code(int enable)
>> @@ -1405,10 +1417,17 @@ int register_ftrace_function(struct ftrace_ops *ops)
>>               return -1;
>>
>>       mutex_lock(&ftrace_sysctl_lock);
>> +
>> +     if (ftrace_tracing_type == FTRACE_TYPE_RETURN) {
>> +             ret = -EBUSY;
>> +             goto out;
>> +     }
>> +
>
> Why do we need to disable all new tracing functions when we do return
> tracing??
>
> -- Steve
>
>>       ret = __register_ftrace_function(ops);
>>       ftrace_startup();
>> -     mutex_unlock(&ftrace_sysctl_lock);
>>
>> +out:
>> +     mutex_unlock(&ftrace_sysctl_lock);
>>       return ret;
>>  }
>>
>

You will see the same test when trying to register a return handler,
it verifies that normal ftrace is not running.
Otherwise it will fail.
I made ftrace and ftrace-return not abled to work simultaneously for the moment.
That made the integration of ftrace-return into dynamic tracing much
more simpler...

But if someone needs to enable both tracing at the same time, I can change it...

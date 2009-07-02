Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZGBF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZGBF4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 01:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZGBF4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 01:56:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52897 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbZGBF4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 01:56:03 -0400
Message-ID: <4A4C4C2D.3040709@cn.fujitsu.com>
Date: Thu, 02 Jul 2009 13:57:01 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix trace_print_seq()
References: <4A4B2351.5010300@cn.fujitsu.com> <20090701140111.GB5097@nowhere>
In-Reply-To: <20090701140111.GB5097@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> There have a example:
>> after reboot:
>> # echo kmemtrace > current_tracer
>> # echo 0 > options/kmem_minimalistic
>> # cat trace
>> # tracer: kmemtrace
>> #
>> #
>> Nothing is exported, because the first byte of trace_seq->buffer[ ]
>> is KMEMTRACE_USER_ALLOC.
>> ( the value of KMEMTRACE_USER_ALLOC is zero, seeing
>>   kmemtrace_print_alloc_user() in kernel/trace/kmemtrace.c)
>>
...
> Looks good, thanks.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> But having a '\0' in a non binary trace looks weird. Why do
> we have such plain KMEMTRACE_USER_ALLOC whereas binary tracing
> is not set, as your example shows it?
> 

Because of this commit:

| commit 42af9054c0eeed09ec58d13ec8bf52d225ebcfcc
| Author: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
| Date:   Mon Mar 23 15:12:26 2009 +0200
|
|    kmemtrace: restore original tracing data binary format, improve ABI

I think we should change it to use trace_event->binary() interface for
binary trace.


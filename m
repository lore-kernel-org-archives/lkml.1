Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbZHUTfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbZHUTfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZHUTfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734AbZHUTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:35:00 -0400
Message-ID: <4A8EF6B7.6080802@redhat.com>
Date: Fri, 21 Aug 2009 12:34:15 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <20090821144707.GB16810@elte.hu>
In-Reply-To: <20090821144707.GB16810@elte.hu>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 07:47 AM, Ingo Molnar wrote:
> 
> * Josh Stone <jistone@redhat.com> wrote:
> 
>> It's not strictly correct for the tracepoint reg/unreg callbacks 
>> to occur when a client is hooking up, because the actual 
>> tracepoint may no be present yet.  This happens to be fine for 
>> syscall, since that's in the core kernel, but it would cause 
>> problems for tracepoints defined in a module that hasn't been 
>> loaded yet.  It also means the reg/unreg has to be EXPORTed for 
>> any modules to use the tracepoint (as in SystemTap).
>>
>> This patch removes DECLARE_TRACE_WITH_CALLBACK, and instead 
>> introduces DEFINE_TRACE_WITH_CALLBACK which stores the callbacks 
>> in struct tracepoint.  The callbacks are used now when the active 
>> state of the tracepoint changes in set_tracepoint & 
>> disable_tracepoint.
>>
>> This also introduces TRACE_EVENT_WITH_CALLBACK, so those events 
>> can also provide callbacks if needed.
> 
> i think something shorter would be nicer, such as:
> 
>  DECLARE_TRACE_FN
>  TRACE_EVENT_FN

Well I took out the DECLARE_TRACE_ part, but sure, DEFINE_TRACE_FN and
TRACE_EVENT_FN sound fine to me.

Josh

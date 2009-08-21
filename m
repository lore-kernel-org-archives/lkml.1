Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZHUTfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZHUTfO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 15:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZHUTfC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 15:35:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754903AbZHUTfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 15:35:00 -0400
Message-ID: <4A8EF6C4.9010708@redhat.com>
Date: Fri, 21 Aug 2009 12:34:28 -0700
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com
Subject: Re: [PATCH v2 1/2] tracing: Move tracepoint callbacks into DEFINE
References: <1250580227-24363-1-git-send-email-jistone@redhat.com> <1250795373-32363-1-git-send-email-jistone@redhat.com> <20090821175212.GA2684@redhat.com>
In-Reply-To: <20090821175212.GA2684@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 10:52 AM, Jason Baron wrote:
> this means that when CONFIG_EVENT_TRACING is set, the 'generic' syscall
> enter/exit will show up as events in the debugfs, but enabling them
> wouldn't do anything. I think we should simply drop the
> 'CONFIG_FTRACE_SYSCALLS' 'ifdef' and 'else' clause. That will give us
> what we want - tying these callbacks directly to tracepoint.

But only x86 and s390 have TIF_SYSCALL_FTRACE, while kernel/tracepoint.c
must still compile everywhere that has CONFIG_TRACEPOINTS=y.

Maybe it would be better to make that #ifdef TIF_SYSCALL_FTRACE, and
then also #ifdef the TRACE_EVENT declaration, so it will only show up on
kernels that actually support it.

Also, since this event is now usable outside of ftrace, would you object
to renaming the flag TIF_SYSCALL_TRACEPOINT?

Josh

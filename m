Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZAECJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZAECJS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 21:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZAECJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 21:09:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51794 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbZAECJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:09:04 -0500
Message-ID: <49616B0B.5000102@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 10:06:03 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] ftrace: infrastructure for supporting binary record
References: <495ADF45.2030203@cn.fujitsu.com> <20081231045956.GC28472@nowhere> <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com>
In-Reply-To: <39e6f6c70901021424v28c1a7dbgbaaf67ac12ca9526@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>
>> Just for curiosity. Why do you need such a binary tracing?
>> Do you need it because a string output is really too slow for your needs?

Hi, Frederic Weisbecker,

We have 
1) lots of kinds events source(FUNCTION trace, TRACE_CTX, tracepoint, markers ...)
2) a generic and mature events log buffer - trace/ringbuffer.c
3) a generic and mature trace framework - trace/trace.c trace_ouput.c

But we don't have a generic events log format, we record different
events with different record formats: TRACE_FN, TRACE_CTX, TRACE_GRAPH_RET,
TRACE_SPECIAL, ... We use different struct for recording different
formats.

Too many kinds different formats, so we need a generic events log format.
This patch provide generic events log format.

Actually, We can use:
__ftrace_bprintk(0, "# %ld %ld %ld\n", arg1, arg2, arg3)
instead of TRACE_SPECIAL.
(maybe I should remove the "unsigned long ip" arg for __ftrace_bprintk()
and trace_vbprintk(), users need know the call_addr, just use "%pS")

And binary record is a little slower than string output.

Lai.


Arnaldo Carvalho de Melo wrote:
> 
> warning: I haven't looked at the patch details
> 
> But I would love to use something like this to provide the exact
> contents the userspace blktrace utilities want.
> 



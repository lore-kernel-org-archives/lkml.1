Return-Path: <linux-kernel-owner+w=401wt.eu-S1752163AbZEYJAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbZEYJAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbZEYJAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:00:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZEYJAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:00:37 -0400
Message-ID: <7BEB795002534E81BFA42E0464AEFD72@zhaoleiwin>
From: "Zhaolei" <zhaolei@cn.fujitsu.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Frederic Weisbecker" <fweisbec@gmail.com>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Tom Zanussi" <tzanussi@gmail.com>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <20090522115108.GA10992@elte.hu>
Subject: Re: [PATCH v2 0/2] ftrace: Add task_comm support for trace_event
Date: Mon, 25 May 2009 16:59:26 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5512
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n4P90p7M029863

* From: "Ingo Molnar" <mingo@elte.hu>
> 
> it still fails to build:
> 
> kernel/built-in.o: In function `ftrace_event_enable_disable':
> trace_events.c:(.text+0x4df08): undefined reference to `tracing_stop_cmdline_record'
> trace_events.c:(.text+0x4df1f): undefined reference to `tracing_start_cmdline_record'
> 
> config attached.

Hello, Ingo

Thanks for your report.

I found reason.
It is because CONFIG_TRACING is on(But CONFIG_FTRACE is off),
which compiles trace_events but leaves trace_sched_switch.
(It is different with problem that I fixed in v1->v2, but... sorry......)

I have fixed it, I'll send v3 after following test:
1: CONFIG_TRACING on, CONFIG_FTRACE off
2: CONFIG_ENABLE_EVENT_TRACING on, CONFIG_ENABLE_CONTEXT_SWITCH_TRACER off
2: CONFIG_ENABLE_EVENT_TRACING on, CONFIG_ENABLE_CONTEXT_SWITCH_TRACER on

And RFC:
IMHO, trace_sched_switch should not have relationship with trace_events,
in other words, trace_events should run without trace_sched_switch linked.

Can we move codes for record cmdline out of trace_sched_switch.c and put them
into new cmdline_record.c?
Then, trace_functions.c and trace_events.c will only need cmdline_record.c.

Thanks
Zhaolei
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

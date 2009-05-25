Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZEYKGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZEYKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZEYKGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:06:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61718 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZEYKGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:06:36 -0400
Message-ID: <4A1A6CE8.2050100@cn.fujitsu.com>
Date: Mon, 25 May 2009 18:03:20 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/2] ftrace: Add task_comm support for trace_event
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A16788F.2060802@cn.fujitsu.com> <20090522115108.GA10992@elte.hu>
In-Reply-To: <20090522115108.GA10992@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Ingo pointed out that v2 patch still cause kernel compile fail:
kernel/built-in.o: In function `ftrace_event_enable_disable':
trace_events.c:(.text+0x4df08): undefined reference to `tracing_stop_cmdline_record'
trace_events.c:(.text+0x4df1f): undefined reference to `tracing_start_cmdline_record'

It is because CONFIG_TRACING is on(But CONFIG_FTRACE is off),
which compiles trace_events but leaves trace_sched_switch.
(Which is different with problem that I fixed in v1->v2)

Changelog:
v1->v2: Update Kconfig to select CONTEXT_SWITCH_TRACER in ENABLE_EVENT_TRACING
v2->v3: v2 can solve problem that caused by config EVENT_TRACING alone,
        but when CONFIG_FTRACE is off and CONFIG_TRACING is selected by other
        config, compile fail happened again. This version solves it.

Thanks
Zhaolei


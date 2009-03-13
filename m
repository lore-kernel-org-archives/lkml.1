Return-Path: <linux-kernel-owner+w=401wt.eu-S1757764AbZCMDKL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757764AbZCMDKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:10:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZCMDJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:09:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36093 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165AbZCMDJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:09:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/16] tracing: have event_trace_printk use static tracer
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090313023826.503765882@goodmis.org>
References: <20090313023704.971438367@goodmis.org> <20090313023826.503765882@goodmis.org>
Message-Id: <20090313120855.43E8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 12:09:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define event_trace_printk(ip, fmt, args...)				\
> +do {									\
> +	__trace_printk_check_format(fmt, ##args);			\
> +	tracing_record_cmdline(current);				\
> +	if (__builtin_constant_p(fmt)) {				\
> +		static const char *trace_printk_fmt			\
> +		  __attribute__((section("__trace_printk_fmt"))) =	\
> +			__builtin_constant_p(fmt) ? fmt : NULL;		\

Why __builtin_constant_p(fmt) evaluate twice?


> +									\
> +		__trace_bprintk(ip, trace_printk_fmt, ##args);		\
> +	} else								\
> +		__trace_printk(ip, fmt, ##args);			\
> +} while (0)



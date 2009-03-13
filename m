Return-Path: <linux-kernel-owner+w=401wt.eu-S1757780AbZCMDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780AbZCMDGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbZCMDF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:05:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57029 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZCMDF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:05:58 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 05/16] tracing: show that buffer size is not expanded
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090313023825.869949732@goodmis.org>
References: <20090313023704.971438367@goodmis.org> <20090313023825.869949732@goodmis.org>
Message-Id: <20090313114953.43E2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Fri, 13 Mar 2009 12:05:53 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: do not confuse user on small trace buffer sizes
> 
> When the system boots up, the trace buffer is small to conserve memory.
> It is only two pages per online CPU. When the tracer is used, it expands
> to the default value.
> 
> This can confuse the user if they look at the buffer size and see only
> 7, but then later they see 1408.
> 
>  # cat /debug/tracing/buffer_size_kb
> 7
> 
>  # echo sched_switch > /debug/tracing/current_tracer
> 
>  # cat /debug/tracing/buffer_size_kb
> 1408
> 
> This patch tries to help remove this confustion by showing that the
> buffer has not been expanded.
> 
>  # cat /debug/tracing/buffer_size_kb
> 7 (expanded: 1408)

Hi,

I have one question.
Why souldn't use following output?

sprintf(buf, "%lu\n", trace_buf_size >> 10);


My point is:
  - pure number output can hadle easily.
  - nobody need to know internal memory saving logic.




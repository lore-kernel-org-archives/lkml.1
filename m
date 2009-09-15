Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbZIODog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbZIODog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZIODob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:44:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56426 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757314AbZIODob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:44:31 -0400
Message-ID: <4AAF0D54.2040506@cn.fujitsu.com>
Date: Tue, 15 Sep 2009 11:43:16 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: Re: [PATCH 5/8] trace: Convert the power tracer into an event tracer
References: <20090912130306.5d0086ea@infradead.org> <20090912130542.6d314860@infradead.org>
In-Reply-To: <20090912130542.6d314860@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
>>From f591a0f126263733d606838a5d113b9807b12c84 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sat, 12 Sep 2009 07:53:03 +0200
> Subject: [PATCH] trace: Convert the power tracer into an event tracer
> 
> This patch converts the existing power tracer into an event tracer,
> so that power events (C states and frequency changes) can be tracked
> via "perf".
> 
> This also removes the perl script that was used to demo the tracer;
> its functionality is being replaced entirely with timechart.
> 

And Documentation/power.txt needs update, or just remove it?

> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

...

> diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
> new file mode 100644
> index 0000000..cb4fc51
> --- /dev/null
> +++ b/kernel/trace/power-traces.c

This file is not necessarily needed.

You can just add definition of CREATE_TRACE_POINTS in process.c.

> @@ -0,0 +1,18 @@
> +/*
> + * Power trace points
> + *
> + * Copyright (C) 2009 Arjan van de Ven <arjan@linux.intel.com>
> + */
> +
> +#include <linux/string.h>
> +#include <linux/types.h>
> +#include <linux/workqueue.h>
> +#include <linux/sched.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/power.h>
> +
> +EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
> +

I think it's power_frequency that needs to be exported?


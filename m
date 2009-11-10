Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZKJRte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZKJRte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbZKJRtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:49:33 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19924 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbZKJRtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:49:32 -0500
Message-ID: <4AF9A77E.6020908@caviumnetworks.com>
Date: Tue, 10 Nov 2009 09:48:46 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Zhangjin <wuzhangjin@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       zhangfx@lemote.com, zhouqg@gmail.com,
       Ralf Baechle <ralf@linux-mips.org>, rostedt@goodmis.org,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nicholas Mc Guire <der.herr@hofr.at>,
       Richard Sandiford <rdsandiford@googlemail.com>,
       Patrik Kluba <kpajko79@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH v7 03/17] tracing: add MIPS specific trace_clock_local()
References: <9dc81a7a9e5a292cccdf465c533a2b08d19d6021.1257779502.git.wuzhangjin@gmail.com> <b99c08397d9ff92ac5a72bda9131df41b702fc71.1257779502.git.wuzhangjin@gmail.com> <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
In-Reply-To: <8f579e2cece16cd22358a4ec143ef6a8c462639b.1257779502.git.wuzhangjin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 17:48:47.0544 (UTC) FILETIME=[0DF1AB80:01CA622E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin wrote:
[...]
> + * trace_clock_local(): the simplest and least coherent tracing clock.
> + *
> + * Useful for tracing that does not cross to other CPUs nor
> + * does it go through idle events.
> + */
> +u64 trace_clock_local(void)
> +{
> +	unsigned long flags;
> +	u64 clock;
> +
> +	raw_local_irq_save(flags);
> +
> +	clock = mips_timecounter_read();
> +
> +	raw_local_irq_restore(flags);
> +
> +	return clock;
> +}

Why disable interrupts?

Also you call the new function mips_timecounter_read().  Since 
sched_clock() is a weak function, you can override the definition with a 
more accurate version when possible.  Then you could just directly call 
it here, instead of adding the new mips_timecounter_read() that the 
'[PATCH v7 02/17] tracing: add mips_timecounter_read() for MIPS' adds.

David Daney

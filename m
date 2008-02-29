Return-Path: <linux-kernel-owner+w=401wt.eu-S933145AbYB2P6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbYB2P6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 10:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbYB2P6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 10:58:44 -0500
Received: from www.tglx.de ([62.245.132.106]:57573 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbYB2P6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 10:58:43 -0500
Date: Fri, 29 Feb 2008 16:57:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Karsten Wiese <fzu@wemgehoertderstaat.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Optimise tick_nohz_stop_sched_tick() a bit
In-Reply-To: <20080228171634.f6fab4de.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802291657090.6427@apollo.tec.linutronix.de>
References: <200802281510.51191.fzu@wemgehoertderstaat.de> <20080228171634.f6fab4de.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Andrew Morton wrote:
> On Thu, 28 Feb 2008 15:10:50 +0100 Karsten Wiese <fzu@wemgehoertderstaat.de> wrote:
> -static ktime_t tick_nohz_start_idle(int cpu, struct tick_sched *ts)
> +static ktime_t tick_nohz_start_idle(struct tick_sched *ts)
>  {
>  	ktime_t now, delta;
>  
> @@ -200,7 +200,7 @@ void tick_nohz_stop_sched_tick(void)
>  
>  	cpu = smp_processor_id();
>  	ts = &per_cpu(tick_cpu_sched, cpu);
> -	now = tick_nohz_start_idle(cpu, ts);
> +	now = tick_nohz_start_idle(ts);
>  
>  	/*
>  	 * If this cpu is offline and it is the one which updates

Combined patch applied to hrt.git

Thanks,

	tglx


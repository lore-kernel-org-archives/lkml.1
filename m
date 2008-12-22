Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbYLVWNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbYLVWNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760411AbYLVWMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:12:33 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:46035 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760396AbYLVWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:12:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=AsAsX+tc0OKr7Jvxh8B1LIulKOgkg3D2iapNd2CEOKcUF4aIH0ugYX3Wfq9KR4M+qm
         nfji3i2PwpQgOz3wKF7Oj/RADbsgOCwRKBignTxu0R1GojfsNSKZo1aK3kTPmkmP7qE2
         /sZGKwe8IV8LyJokB1iiIwY+CyhZfFBXk2QVg=
Message-ID: <b637ec0b0812221412w396337embad90f599a02d3d9@mail.gmail.com>
Date: Mon, 22 Dec 2008 23:12:30 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: TSC not updating after resume: Bug or Feature?
Cc: "Ingo Molnar" <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <srostedt@redhat.com>, dsaxena@plexity.net,
       LKML <linux-kernel@vger.kernel.org>,
       "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>, toralf.foerster@gmx.de
In-Reply-To: <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
	 <b637ec0b0812211443u1ca9c11du5d61c41e3d82bc16@mail.gmail.com>
	 <alpine.LFD.2.00.0812221543550.3723@localhost.localdomain>
	 <20081222150021.GA13839@elte.hu>
	 <alpine.LFD.2.00.0812221921460.3723@localhost.localdomain>
	 <alpine.LFD.2.00.0812222056190.3723@localhost.localdomain>
	 <b637ec0b0812221239p169967aemf14b2e591779f5cd@mail.gmail.com>
	 <alpine.LFD.2.00.0812222212191.3723@localhost.localdomain>
	 <b637ec0b0812221335w54fe11ecwf05e0302bc27b5a3@mail.gmail.com>
	 <alpine.LFD.2.00.0812222238192.3723@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Won't apply:

fcomolli@hawking:~/software/GIT-TREES/linux-2.6> patch -p1 --dry-run <
/home/fcomolli/0009c-tglx-debug.patch
patching file kernel/sched_clock.c
patching file kernel/time/timekeeping.c
Hunk #1 succeeded at 49 with fuzz 2 (offset 3 lines).
Hunk #2 succeeded at 100 with fuzz 2 (offset 5 lines).
Hunk #3 FAILED at 309.
1 out of 3 hunks FAILED -- saving rejects to file kernel/time/timekeeping.c.rej

Should I revert you previous one?

Regards,
Fabio



On Mon, Dec 22, 2008 at 11:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> Fabio,
>
> On Mon, 22 Dec 2008, Fabio Comolli wrote:
>> On Mon, Dec 22, 2008 at 10:13 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> >
>> > Can please you revert the last patch and apply the following ? Does
>> > the WARN_ON trigger ?
>> >
>
>> Yes, it does:
>
>> [  159.768005]  [<c01389a2>] getnstimeofday+0x21/0xcd
>> [  159.768005]  [<c0135e26>] ktime_get_ts+0x1d/0x3f
>> [  159.768005]  [<c0135e57>] ktime_get+0xf/0x2b
>> [  159.768005]  [<c013736b>] sched_clock_tick+0x46/0x83
>> [  159.768005]  [<c01373ad>] sched_clock_idle_wakeup_event+0x5/0xa
>> [  159.768005]  [<c0108670>] set_cyc2ns_scale+0x3f/0x5e
>> [  159.768005]  [<c01088af>] time_cpufreq_notifier+0xf9/0x103
>> [  159.768005]  [<c0136782>] notifier_call_chain+0x2a/0x52
>> [  159.768005]  [<c0136866>] __srcu_notifier_call_chain+0x35/0x4a
>> [  159.768005]  [<c0136884>] srcu_notifier_call_chain+0x9/0xc
>> [  159.768005]  [<c031cbca>] cpufreq_resume+0xf3/0x112
>> [  159.768005]  [<c028c3f3>] __sysdev_resume+0x24/0x34
>> [  159.768005]  [<c028c421>] sysdev_resume+0x1e/0x50
>
> Thanks for testing. It's exaclty the code path I described :)
>
> So my code analysis holds and your test confirms my suspicion that
> Shaggy's patch just unearthed some other weirdness in the
> suspend/resume code.
>
> Can you please apply the following hack^Wpatch and retest ? It
> restores Shaggys patch, but prevents the sched_clock_tick() call when
> timekeeping is not resumed. The WARN_ON should not longer trigger
> except there is some other code path which fiddles with that as well.
>
> If I'm not completely nuts then this should solve your suspend/resume
> problem really instead of papering over the root cause.
>
> The patch should work on top of 2.6.27.10 as well, so whatever is
> easier to verify for you is fine.
>
> Thanks,
>
>        tglx
> ---
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index e8ab096..dd97801 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -124,7 +124,7 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
>
>        clock = scd->tick_gtod + delta;
>        min_clock = wrap_max(scd->tick_gtod, scd->clock);
> -       max_clock = scd->tick_gtod + TICK_NSEC;
> +       max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
>
>        clock = wrap_max(clock, min_clock);
>        clock = wrap_min(clock, max_clock);
> @@ -222,11 +222,16 @@ void sched_clock_idle_sleep_event(void)
>  }
>  EXPORT_SYMBOL_GPL(sched_clock_idle_sleep_event);
>
> +extern int timekeeping_suspended;
> +
>  /*
>  * We just idled delta nanoseconds (called with irqs disabled):
>  */
>  void sched_clock_idle_wakeup_event(u64 delta_ns)
>  {
> +       if (timekeeping_suspended)
> +               return;
> +
>        sched_clock_tick();
>        touch_softlockup_watchdog();
>  }
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index fa05e88..50ba3d0 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -46,6 +46,9 @@ struct timespec xtime __attribute__ ((aligned (16)));
>  struct timespec wall_to_monotonic __attribute__ ((aligned (16)));
>  static unsigned long total_sleep_time;         /* seconds */
>
> +/* flag for if timekeeping is suspended */
> +int timekeeping_suspended;
> +
>  static struct timespec xtime_cache __attribute__ ((aligned (16)));
>  void update_xtime_cache(u64 nsec)
>  {
> @@ -92,6 +95,8 @@ void getnstimeofday(struct timespec *ts)
>        unsigned long seq;
>        s64 nsecs;
>
> +       WARN_ON(timekeeping_suspended);
> +
>        do {
>                seq = read_seqbegin(&xtime_lock);
>
> @@ -299,8 +304,6 @@ void __init timekeeping_init(void)
>        write_sequnlock_irqrestore(&xtime_lock, flags);
>  }
>
> -/* flag for if timekeeping is suspended */
> -static int timekeeping_suspended;
>  /* time in seconds when suspend began */
>  static unsigned long timekeeping_suspend_time;
>
>

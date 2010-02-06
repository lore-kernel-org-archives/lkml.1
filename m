Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab0BFOVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 09:21:44 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33375 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866Ab0BFOVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 09:21:42 -0500
Date: Sat, 6 Feb 2010 15:21:41 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       John Stultz <johnstul@us.ibm.com>
Subject: clocksource mutex deadlock, cat current_clocksource (2.6.33-rc6)
Message-ID: <20100206142141.GA12871@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I did

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource




[oh yes indeed, that's the full output]


This is on Dell Inspiron 8000 P3/700 UP (after some suspend/resume cycles).

Haven't checked yet whether this occurs on fresh boot, too.

clocksource / event device setup is (from memory) PIT (TSC disabled due
to C2 stall) and acpi_pm (lapic is _enabled_, and CPU support only,
not BIOS).

Thanks,

Andreas Mohr

echo t > /proc/sysrq-trigger shows (full output on request):

cat           D 00000000     0 19361   2959 0x00000000
 de215ef8 00000046 00000000 00000000 c13b0294 dd45c380 dd45c5fc df9c6ef0
 de215f28 de215f08 c13b0260 00000202 de215f28 c124fcae dd45c380 c13b0280
 c13b0280 c13b0280 dd45c380 de215f08 ffffffff d9de1000 c13b0338 df9c6ef0
Call Trace:
 [<c124fcae>] mutex_lock_nested+0x157/0x23d
 [<c104873e>] sysfs_show_current_clocksources+0x17/0x41
 [<c1048727>] ? sysfs_show_current_clocksources+0x0/0x41
 [<c1196a75>] sysdev_show+0x1d/0x21
 [<c10dea91>] sysfs_read_file+0x9b/0x135
 [<c10de9f6>] ? sysfs_read_file+0x0/0x135
 [<c109fc1b>] vfs_read+0x8c/0x13d
 [<c109fd6f>] sys_read+0x40/0x65
 [<c1002890>] sysenter_do_call+0x12/0x36
Sched Debug Version: v0.09, 2.6.33-rc6 #3
now at 43142470.181620 msecs
  .jiffies                                 : 4283441
  .sysctl_sched_latency                    : 5.000000
  .sysctl_sched_min_granularity            : 1.000000
  .sysctl_sched_wakeup_granularity         : 1.000000
  .sysctl_sched_child_runs_first           : 0.000000
  .sysctl_sched_features                   : 7917179
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

cpu#0, 698.566 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 17910608
  .nr_load_updates               : 4313441
  .nr_uninterruptible            : 1
  .next_balance                  : 0.000000
  .curr->pid                     : 9119
  .clock                         : 43142407.895281
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 1033
  .cpu_load[2]                   : 706
  .cpu_load[3]                   : 465
  .cpu_load[4]                   : 406
  .yld_count                     : 8871
  .sched_switch                  : 0
  .sched_count                   : 18023143
  .sched_goidle                  : 4265782
  .ttwu_count                    : 0
  .ttwu_local                    : 0
  .bkl_count                     : 0

cfs_rq[0]:
  .exec_clock                    : 11345719.395963
  .MIN_vruntime                  : 232465648.024326
  .min_vruntime                  : 232465649.026399
  .max_vruntime                  : 232465648.024326
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 492453

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
   x-www-browser  3345 232465648.024326   1053319   120 232465648.024326
2047447.788077  39329053.727630
R           bash  9119 232465646.526399       514   120 232465646.526399
250.811110  33621456.410620

INFO: lockdep is turned off.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753417AbYCXUS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbYCXUS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 16:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYCXUSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 16:18:16 -0400
Received: from www17.your-server.de ([213.133.104.17]:45289 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbYCXUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 16:18:06 -0400
Message-ID: <47E80C64.7020907@m3y3r.de>
Date: Mon, 24 Mar 2008 21:17:40 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
 regressions from 2.6.24)
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E59B39.90306@s5r6.in-berlin.de> <20080323063524.GA13018@elte.hu> <47E80247.8090702@m3y3r.de> <20080324194706.GA1391@elte.hu>
In-Reply-To: <20080324194706.GA1391@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------030505070705020305090703"
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030505070705020305090703
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar schrieb:
> * Thomas Meyer <thomas@m3y3r.de> wrote:
>
>   
>>> send us the cfs-debug-info file that gets generated. We'll be able to 
>>> tell from that whether your ioremap's are OK. (x86/latest will also 
>>> printk all ioremap()s and results that are done)
>>>       
>> See attached file.
>>     
>
> could you send the full bootlog too? (the dmesg in the cfs-debug-info 
> log is truncated - probably CONFIG_LOG_BUF_SHIFT is too low?)
>
> the bootlog should have such entries:
>
>   ioremap: 0x12340000(0x00001000) => 0x12340000
>
> near the ohci1394 initialization messages.
>
> 	Ingo
>
>   
Second try. See attached file.


--------------030505070705020305090703
Content-Type: text/plain;
 name="cfs-debug-info-2008.03.24-21.15.02"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="cfs-debug-info-2008.03.24-21.15.02"

-- /proc/sched_debug: --
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 262431.395065 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 99192
  .nr_load_updates               : 14157
  .nr_uninterruptible            : 4294967178
  .jiffies                       : 4294956026
  .next_balance                  : 4294.956058
  .curr->pid                     : 0
  .clock                         : 259326.857479
  .idle_clock                    : 236536.161219
  .prev_clock_raw                : 163922.123766
  .clock_warps                   : 0
  .clock_overflows               : 95976
  .clock_underflows              : 4006
  .clock_deep_idle_events        : 31862
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1032
  .cpu_load[2]                   : 623
  .cpu_load[3]                   : 547
  .cpu_load[4]                   : 537

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 37374.361378
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 84815
  .nr_load_updates               : 15790
  .nr_uninterruptible            : 118
  .jiffies                       : 4294956026
  .next_balance                  : 4294.956070
  .curr->pid                     : 3492
  .clock                         : 261857.702769
  .idle_clock                    : 242274.825171
  .prev_clock_raw                : 163922.589019
  .clock_warps                   : 0
  .clock_overflows               : 55897
  .clock_underflows              : 5473
  .clock_deep_idle_events        : 33794
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 640
  .cpu_load[2]                   : 472
  .cpu_load[3]                   : 303
  .cpu_load[4]                   : 183

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 35414.084669
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1960.276709
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3492     35414.084669         1   120               0               0               0.000000               0.000000               0.000000

-- /proc/*/task/*/sched: --
cqueue/0 (129, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           291.748599
se.vruntime                        :           172.966694
se.sum_exec_runtime                :             0.004804
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  222
cqueue/1 (130, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            53.991405
se.vruntime                        :           766.801717
se.sum_exec_runtime                :             0.004299
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ata/0 (134, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25816.969520
se.vruntime                        :         26832.747011
se.sum_exec_runtime                :             0.929711
se.avg_overlap                     :             0.000201
nr_switches                        :                   52
nr_voluntary_switches              :                   52
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ata/1 (135, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25137.965718
se.vruntime                        :         24125.161119
se.sum_exec_runtime                :             1.962854
se.avg_overlap                     :             0.003918
nr_switches                        :                   28
nr_voluntary_switches              :                   28
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ata_aux (136, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            54.373976
se.vruntime                        :           819.300834
se.sum_exec_runtime                :             0.004648
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kseriod (138, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           353.942384
se.vruntime                        :           838.989495
se.sum_exec_runtime                :             0.008767
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kondemand/0 (157, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259314.695967
se.vruntime                        :         37348.769861
se.sum_exec_runtime                :             7.839201
se.avg_overlap                     :             0.003876
nr_switches                        :                 2313
nr_voluntary_switches              :                 2313
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kondemand/1 (158, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        261857.702769
se.vruntime                        :         35374.115310
se.sum_exec_runtime                :            15.537259
se.avg_overlap                     :             0.006410
nr_switches                        :                 2561
nr_voluntary_switches              :                 2561
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  210
pdflush (180, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           116.579339
se.vruntime                        :          1035.910481
se.sum_exec_runtime                :             0.004654
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
pdflush (181, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        208356.824631
se.vruntime                        :         34914.728363
se.sum_exec_runtime                :             0.640007
se.avg_overlap                     :             0.053428
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kswapd0 (182, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           116.750620
se.vruntime                        :          1062.159745
se.sum_exec_runtime                :             0.004167
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ksuspend_usbd (1909, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          3714.978705
se.vruntime                        :         11215.654118
se.sum_exec_runtime                :             0.055240
se.avg_overlap                     :             0.000000
nr_switches                        :                    6
nr_voluntary_switches              :                    6
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
khubd (1911, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5236.390631
se.vruntime                        :         16806.312317
se.sum_exec_runtime                :             3.788397
se.avg_overlap                     :             0.019819
nr_switches                        :                  161
nr_voluntary_switches              :                  161
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  210
init (1, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        258771.802984
se.vruntime                        :         33859.856781
se.sum_exec_runtime                :           230.596006
se.avg_overlap                     :             0.013717
nr_switches                        :                 1339
nr_voluntary_switches              :                 1336
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
aio/0 (225, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           356.307273
se.vruntime                        :           947.590168
se.sum_exec_runtime                :             0.004846
se.avg_overlap                     :             0.000046
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
aio/1 (226, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           118.773028
se.vruntime                        :          1055.599103
se.sum_exec_runtime                :             0.002112
se.avg_overlap                     :             0.000045
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_4 (2274, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          4012.291783
se.vruntime                        :         16515.620976
se.sum_exec_runtime                :             0.008587
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
usb-storage (2278, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        258025.275575
se.vruntime                        :         35219.058620
se.sum_exec_runtime                :             1.533452
se.avg_overlap                     :             0.000239
nr_switches                        :                  708
nr_voluntary_switches              :                  708
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
applesmc-led (2300, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          4101.702575
se.vruntime                        :         16601.436489
se.sum_exec_runtime                :             0.000002
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kdmflush (2431, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5614.707241
se.vruntime                        :         17387.407667
se.sum_exec_runtime                :             0.003660
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd_io (2440, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         11549.596510
se.vruntime                        :         19089.763344
se.sum_exec_runtime                :             2.725872
se.avg_overlap                     :             0.030823
nr_switches                        :                  214
nr_voluntary_switches              :                  214
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd (2441, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         11574.736281
se.vruntime                        :         17459.046066
se.sum_exec_runtime                :            18.968986
se.avg_overlap                     :             0.203604
nr_switches                        :                   54
nr_voluntary_switches              :                   54
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kdmflush (2491, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         10286.743935
se.vruntime                        :         12946.068094
se.sum_exec_runtime                :             0.010510
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd_io (2493, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259290.850075
se.vruntime                        :         37348.819984
se.sum_exec_runtime                :           107.515779
se.avg_overlap                     :             0.038494
nr_switches                        :                 4163
nr_voluntary_switches              :                 4162
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd (2496, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259291.039242
se.vruntime                        :         35226.479512
se.sum_exec_runtime                :          1148.920447
se.avg_overlap                     :             0.166397
nr_switches                        :                 3778
nr_voluntary_switches              :                 3739
nr_involuntary_switches            :                   39
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  211
kjournald (2547, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        210498.021008
se.vruntime                        :         33715.090193
se.sum_exec_runtime                :             1.285614
se.avg_overlap                     :             0.062437
nr_switches                        :                   19
nr_voluntary_switches              :                   19
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ifplugd (2653, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        261048.525155
se.vruntime                        :         35166.726027
se.sum_exec_runtime                :             7.425993
se.avg_overlap                     :             0.021869
nr_switches                        :                  250
nr_voluntary_switches              :                  250
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
metalog (2824, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        221485.257895
se.vruntime                        :         35007.610622
se.sum_exec_runtime                :            36.416183
se.avg_overlap                     :             1.695784
nr_switches                        :                   83
nr_voluntary_switches              :                   80
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
metalog (2825, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        221485.257894
se.vruntime                        :         34987.631743
se.sum_exec_runtime                :             5.177298
se.avg_overlap                     :             0.134587
nr_switches                        :                   31
nr_voluntary_switches              :                   31
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
acpid (2834, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         21627.127456
se.vruntime                        :         25584.020012
se.sum_exec_runtime                :             0.239354
se.avg_overlap                     :             0.000000
nr_switches                        :                   10
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
dbus-daemon (2844, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        197312.573600
se.vruntime                        :         34931.419760
se.sum_exec_runtime                :           117.683071
se.avg_overlap                     :             0.038911
nr_switches                        :                 1751
nr_voluntary_switches              :                 1746
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
nscd (2913, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261825.007702
se.vruntime                        :         35293.909988
se.sum_exec_runtime                :            10.881379
se.avg_overlap                     :             0.003087
nr_switches                        :                  569
nr_voluntary_switches              :                  536
nr_involuntary_switches            :                   33
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2914, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        259296.290499
se.vruntime                        :         35227.150570
se.sum_exec_runtime                :             2.667650
se.avg_overlap                     :             0.087583
nr_switches                        :                   74
nr_voluntary_switches              :                   71
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2915, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261822.971249
se.vruntime                        :         35294.025510
se.sum_exec_runtime                :             2.532864
se.avg_overlap                     :             0.058672
nr_switches                        :                   69
nr_voluntary_switches              :                   69
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2916, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261824.948409
se.vruntime                        :         35301.179272
se.sum_exec_runtime                :             2.168609
se.avg_overlap                     :             0.015392
nr_switches                        :                   77
nr_voluntary_switches              :                   73
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2917, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261823.730127
se.vruntime                        :         35294.020751
se.sum_exec_runtime                :             2.195818
se.avg_overlap                     :             0.051026
nr_switches                        :                   59
nr_voluntary_switches              :                   57
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
nscd (2918, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261823.813697
se.vruntime                        :         35300.768749
se.sum_exec_runtime                :             1.481253
se.avg_overlap                     :             0.013566
nr_switches                        :                   55
nr_voluntary_switches              :                   55
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2919, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261824.182571
se.vruntime                        :         35301.093583
se.sum_exec_runtime                :             2.092544
se.avg_overlap                     :             0.026951
nr_switches                        :                   55
nr_voluntary_switches              :                   55
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2920, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        259293.219858
se.vruntime                        :         35226.799347
se.sum_exec_runtime                :             1.646507
se.avg_overlap                     :             0.050386
nr_switches                        :                   54
nr_voluntary_switches              :                   54
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
nscd (2921, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        261824.563881
se.vruntime                        :         35301.139448
se.sum_exec_runtime                :             1.701287
se.avg_overlap                     :             0.009547
nr_switches                        :                   55
nr_voluntary_switches              :                   55
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
hald (2932, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        256903.461390
se.vruntime                        :         37342.379293
se.sum_exec_runtime                :           480.785738
se.avg_overlap                     :             0.007338
nr_switches                        :                 3503
nr_voluntary_switches              :                 3206
nr_involuntary_switches            :                  297
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-runner (2933, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25695.354198
se.vruntime                        :         26684.938942
se.sum_exec_runtime                :             7.336908
se.avg_overlap                     :             0.072446
nr_switches                        :                   89
nr_voluntary_switches              :                   84
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
hald-addon-inpu (2979, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259235.562561
se.vruntime                        :         37328.791530
se.sum_exec_runtime                :             4.258651
se.avg_overlap                     :             0.028059
nr_switches                        :                  904
nr_voluntary_switches              :                  900
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
hald-addon-macb (2981, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         17660.682445
se.vruntime                        :         23611.241597
se.sum_exec_runtime                :             2.364293
se.avg_overlap                     :             0.027122
nr_switches                        :                   11
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-addon-cpuf (2984, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         17445.343747
se.vruntime                        :         20827.808986
se.sum_exec_runtime                :             1.828741
se.avg_overlap                     :             0.017303
nr_switches                        :                   16
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    8
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-addon-acpi (2985, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         17982.665532
se.vruntime                        :         23790.385399
se.sum_exec_runtime                :             0.299386
se.avg_overlap                     :             0.020502
nr_switches                        :                   14
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    6
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dhcpcd (2990, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         17686.427061
se.vruntime                        :         20963.717293
se.sum_exec_runtime                :             0.000001
se.avg_overlap                     :             0.000000
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  211
kthreadd (2, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        223454.855285
se.vruntime                        :         33887.877514
se.sum_exec_runtime                :             1.842415
se.avg_overlap                     :             0.004744
nr_switches                        :                  236
nr_voluntary_switches              :                  205
nr_involuntary_switches            :                   31
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
hald-addon-stor (3003, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        260548.511890
se.vruntime                        :         34606.388415
se.sum_exec_runtime                :            11.293920
se.avg_overlap                     :             0.000449
nr_switches                        :                  294
nr_voluntary_switches              :                  254
nr_involuntary_switches            :                   40
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm (3044, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         41101.153580
se.vruntime                        :         27891.826478
se.sum_exec_runtime                :             3.771903
se.avg_overlap                     :             0.027383
nr_switches                        :                  437
nr_voluntary_switches              :                  434
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
X (3054, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259259.391688
se.vruntime                        :         37379.055632
se.sum_exec_runtime                :         12387.762378
se.avg_overlap                     :             0.829655
nr_switches                        :                32458
nr_voluntary_switches              :                10994
nr_involuntary_switches            :                21464
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm (3101, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         40437.506360
se.vruntime                        :         27426.718818
se.sum_exec_runtime                :             4.634114
se.avg_overlap                     :             0.020982
nr_switches                        :                  181
nr_voluntary_switches              :                  142
nr_involuntary_switches            :                   39
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
cupsd (3109, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         24499.943098
se.vruntime                        :         23924.411901
se.sum_exec_runtime                :           168.582926
se.avg_overlap                     :             0.003976
nr_switches                        :                  157
nr_voluntary_switches              :                   89
nr_involuntary_switches            :                   68
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
ifplugd (3162, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        254891.175392
se.vruntime                        :         37151.955847
se.sum_exec_runtime                :             0.629686
se.avg_overlap                     :             0.000000
nr_switches                        :                   36
nr_voluntary_switches              :                   36
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
pktcdvd0 (3216, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25140.708319
se.vruntime                        :         24178.246083
se.sum_exec_runtime                :             0.000003
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                88761
policy                             :                    0
prio                               :                  100
clock-delta                        :                  198
smartd (3234, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26685.676205
se.vruntime                        :         27037.146371
se.sum_exec_runtime                :             0.496238
se.avg_overlap                     :             0.005364
nr_switches                        :                    3
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
sshd (3248, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         28076.167075
se.vruntime                        :         27201.360984
se.sum_exec_runtime                :             0.620143
se.avg_overlap                     :             0.002209
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
cron (3259, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        260949.910384
se.vruntime                        :         33092.731250
se.sum_exec_runtime                :             0.196480
se.avg_overlap                     :             0.000000
nr_switches                        :                   25
nr_voluntary_switches              :                   15
nr_involuntary_switches            :                   10
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
agetty (3268, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29749.361838
se.vruntime                        :         27570.167245
se.sum_exec_runtime                :             0.706102
se.avg_overlap                     :             0.040031
nr_switches                        :                   11
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3269, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29749.996472
se.vruntime                        :         27588.248340
se.sum_exec_runtime                :             0.476876
se.avg_overlap                     :             0.002028
nr_switches                        :                   11
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3270, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29749.511804
se.vruntime                        :         27588.121945
se.sum_exec_runtime                :             1.379849
se.avg_overlap                     :             0.117485
nr_switches                        :                    9
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3271, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29015.664991
se.vruntime                        :         25257.173792
se.sum_exec_runtime                :             1.150871
se.avg_overlap                     :             0.078383
nr_switches                        :                   10
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3272, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29015.213770
se.vruntime                        :         25243.655884
se.sum_exec_runtime                :             0.226294
se.avg_overlap                     :             0.000616
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
agetty (3275, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29015.631442
se.vruntime                        :         25257.154918
se.sum_exec_runtime                :             1.644013
se.avg_overlap                     :             0.016465
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
dbus-launch (3296, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         53110.495321
se.vruntime                        :         30139.386602
se.sum_exec_runtime                :             0.698928
se.avg_overlap                     :             0.020959
nr_switches                        :                   11
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-daemon (3297, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         41120.073496
se.vruntime                        :         27892.323482
se.sum_exec_runtime                :             1.579203
se.avg_overlap                     :             0.037676
nr_switches                        :                   22
nr_voluntary_switches              :                   13
nr_involuntary_switches            :                    9
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
startkde (3305, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         44997.973950
se.vruntime                        :         29092.274537
se.sum_exec_runtime                :            24.037792
se.avg_overlap                     :             0.061835
nr_switches                        :                  110
nr_voluntary_switches              :                   76
nr_involuntary_switches            :                   34
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
dbus-launch (3356, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         53110.495332
se.vruntime                        :         30147.436437
se.sum_exec_runtime                :             0.657004
se.avg_overlap                     :             0.004647
nr_switches                        :                   16
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                   13
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-daemon (3357, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        252750.755574
se.vruntime                        :         37066.782979
se.sum_exec_runtime                :           116.623368
se.avg_overlap                     :             0.014017
nr_switches                        :                 1835
nr_voluntary_switches              :                 1625
nr_involuntary_switches            :                  210
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdeinit4 (3362, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         80823.370971
se.vruntime                        :         31983.029843
se.sum_exec_runtime                :            23.689218
se.avg_overlap                     :             0.038014
nr_switches                        :                  144
nr_voluntary_switches              :                  118
nr_involuntary_switches            :                   26
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
klauncher (3363, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        252877.654837
se.vruntime                        :         35108.369375
se.sum_exec_runtime                :            89.945755
se.avg_overlap                     :             0.088175
nr_switches                        :                  223
nr_voluntary_switches              :                  157
nr_involuntary_switches            :                   66
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kded4 (3365, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        256650.331477
se.vruntime                        :         37043.140983
se.sum_exec_runtime                :           573.540486
se.avg_overlap                     :             0.143918
nr_switches                        :                 1202
nr_voluntary_switches              :                  737
nr_involuntary_switches            :                  465
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
gam_server (3367, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50325.150996
se.vruntime                        :         29585.827044
se.sum_exec_runtime                :             1.059109
se.avg_overlap                     :             0.058525
nr_switches                        :                   14
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kwrapper4 (3372, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259109.852968
se.vruntime                        :         35553.296342
se.sum_exec_runtime                :             5.123062
se.avg_overlap                     :             0.005117
nr_switches                        :                  221
nr_voluntary_switches              :                  219
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
ksmserver (3374, #threads: 2)
---------------------------------------------------------
se.exec_start                      :        252750.755556
se.vruntime                        :         37046.867420
se.sum_exec_runtime                :           126.760913
se.avg_overlap                     :             0.130525
nr_switches                        :                  598
nr_voluntary_switches              :                  367
nr_involuntary_switches            :                  231
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
ksmserver (3377, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         45052.344856
se.vruntime                        :         28983.335784
se.sum_exec_runtime                :             0.000002
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
kwin (3379, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259236.421478
se.vruntime                        :         37328.970097
se.sum_exec_runtime                :           472.636661
se.avg_overlap                     :             0.028646
nr_switches                        :                 6739
nr_voluntary_switches              :                 6374
nr_involuntary_switches            :                  365
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
plasma (3382, #threads: 2)
---------------------------------------------------------
se.exec_start                      :        259236.338833
se.vruntime                        :         37339.195777
se.sum_exec_runtime                :          1061.821519
se.avg_overlap                     :             0.359948
nr_switches                        :                 4060
nr_voluntary_switches              :                 2457
nr_involuntary_switches            :                 1603
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
plasma (3384, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         47003.498184
se.vruntime                        :         29727.560455
se.sum_exec_runtime                :           150.590849
se.avg_overlap                     :             0.990633
nr_switches                        :                   38
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                   24
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
knotify4 (3383, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        252750.755570
se.vruntime                        :         37047.293405
se.sum_exec_runtime                :           490.422356
se.avg_overlap                     :             1.024362
nr_switches                        :                  298
nr_voluntary_switches              :                  175
nr_involuntary_switches            :                  123
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
kio_file (3385, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        232676.625105
se.vruntime                        :         34456.090153
se.sum_exec_runtime                :            11.597564
se.avg_overlap                     :             0.046199
nr_switches                        :                   36
nr_voluntary_switches              :                   16
nr_involuntary_switches            :                   20
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
krunner (3387, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        192964.601360
se.vruntime                        :         34871.545493
se.sum_exec_runtime                :           805.388097
se.avg_overlap                     :             0.049025
nr_switches                        :                 9808
nr_voluntary_switches              :                 8967
nr_involuntary_switches            :                  841
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
krunner (3401, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        119336.243106
se.vruntime                        :         32496.298784
se.sum_exec_runtime                :            30.624500
se.avg_overlap                     :             0.036059
nr_switches                        :                  228
nr_voluntary_switches              :                  192
nr_involuntary_switches            :                   36
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
krunner (3402, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        120722.281688
se.vruntime                        :         31799.205166
se.sum_exec_runtime                :            12.118200
se.avg_overlap                     :             0.080823
nr_switches                        :                  283
nr_voluntary_switches              :                  282
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
krunner (3403, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        119336.419824
se.vruntime                        :         32497.251038
se.sum_exec_runtime                :            36.649631
se.avg_overlap                     :             0.244159
nr_switches                        :                  207
nr_voluntary_switches              :                  169
nr_involuntary_switches            :                   38
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
krunner (3404, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        119412.871342
se.vruntime                        :         32497.248278
se.sum_exec_runtime                :            90.693326
se.avg_overlap                     :             0.104006
nr_switches                        :                  175
nr_voluntary_switches              :                  159
nr_involuntary_switches            :                   16
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
krunner (3405, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        119874.775463
se.vruntime                        :         32647.213006
se.sum_exec_runtime                :             0.065376
se.avg_overlap                     :             0.000442
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kaccess (3396, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        257858.921611
se.vruntime                        :         37326.604252
se.sum_exec_runtime                :            58.870161
se.avg_overlap                     :             0.085278
nr_switches                        :                  273
nr_voluntary_switches              :                  146
nr_involuntary_switches            :                  127
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
kmix (3397, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        135638.616553
se.vruntime                        :         33795.018413
se.sum_exec_runtime                :           203.672383
se.avg_overlap                     :             0.070015
nr_switches                        :                  598
nr_voluntary_switches              :                  130
nr_involuntary_switches            :                  468
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
konsole (3407, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259336.798075
se.vruntime                        :         37374.421603
se.sum_exec_runtime                :          1980.077076
se.avg_overlap                     :             0.164180
nr_switches                        :                 8240
nr_voluntary_switches              :                 7794
nr_involuntary_switches            :                  446
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3408, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        133907.651623
se.vruntime                        :         32451.253104
se.sum_exec_runtime                :             5.120026
se.avg_overlap                     :             0.025167
nr_switches                        :                   60
nr_voluntary_switches              :                   42
nr_involuntary_switches            :                   18
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
su (3414, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        133764.577657
se.vruntime                        :         33721.071431
se.sum_exec_runtime                :             5.668860
se.avg_overlap                     :             0.008229
nr_switches                        :                   42
nr_voluntary_switches              :                   41
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3417, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259235.788636
se.vruntime                        :         37354.714113
se.sum_exec_runtime                :            33.619866
se.avg_overlap                     :             0.027967
nr_switches                        :                  424
nr_voluntary_switches              :                  341
nr_involuntary_switches            :                   83
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
khpsbpkt (3441, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        162485.145683
se.vruntime                        :         33237.277299
se.sum_exec_runtime                :             0.018285
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
bash (3487, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        261863.991182
se.vruntime                        :         35399.695796
se.sum_exec_runtime                :             6.117673
se.avg_overlap                     :             0.017057
nr_switches                        :                   12
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
migration/0 (3, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :             0.005089
se.sum_exec_runtime                :             0.606982
se.avg_overlap                     :             0.000000
nr_switches                        :                  303
nr_voluntary_switches              :                  303
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  198
kblockd/0 (46, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259241.453495
se.vruntime                        :         35221.444412
se.sum_exec_runtime                :            14.305344
se.avg_overlap                     :             0.034567
nr_switches                        :                  792
nr_voluntary_switches              :                  792
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kblockd/1 (47, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         54540.351494
se.vruntime                        :         30235.565498
se.sum_exec_runtime                :             3.468810
se.avg_overlap                     :             0.000000
nr_switches                        :                  105
nr_voluntary_switches              :                  105
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  211
kacpid (49, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        256900.715073
se.vruntime                        :         37314.356011
se.sum_exec_runtime                :             7.358445
se.avg_overlap                     :             0.025756
nr_switches                        :                  860
nr_voluntary_switches              :                  860
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ksoftirqd/0 (4, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        259332.771882
se.vruntime                        :         37353.439883
se.sum_exec_runtime                :            17.136849
se.avg_overlap                     :             0.000161
nr_switches                        :                 9060
nr_voluntary_switches              :                 9060
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kacpi_notify (50, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             3.333671
se.vruntime                        :           333.613373
se.sum_exec_runtime                :             0.000002
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
migration/1 (5, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :            -4.329575
se.sum_exec_runtime                :             0.499760
se.avg_overlap                     :             0.000000
nr_switches                        :                  287
nr_voluntary_switches              :                  287
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  198
ksoftirqd/1 (6, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        261864.013976
se.vruntime                        :         33480.264031
se.sum_exec_runtime                :            12.961472
se.avg_overlap                     :             0.001784
nr_switches                        :                 8185
nr_voluntary_switches              :                 8185
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
events/0 (7, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        258993.605101
se.vruntime                        :         37335.250664
se.sum_exec_runtime                :             4.043801
se.avg_overlap                     :             0.003803
nr_switches                        :                  553
nr_voluntary_switches              :                  553
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_0 (845, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1291.715168
se.vruntime                        :          6894.885377
se.sum_exec_runtime                :             0.759313
se.avg_overlap                     :             0.000609
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_1 (847, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           304.992609
se.vruntime                        :          2068.514386
se.sum_exec_runtime                :             3.442346
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_2 (852, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           553.297530
se.vruntime                        :          7163.474068
se.sum_exec_runtime                :            15.400331
se.avg_overlap                     :             0.000343
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_3 (854, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           353.310994
se.vruntime                        :          2107.860859
se.sum_exec_runtime                :             3.335006
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kstriped (875, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           354.068096
se.vruntime                        :          2218.333981
se.sum_exec_runtime                :             0.004101
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kjournald (881, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        208366.628184
se.vruntime                        :         34961.051215
se.sum_exec_runtime                :             0.731259
se.avg_overlap                     :             0.000000
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
events/1 (8, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        261048.495365
se.vruntime                        :         35166.648930
se.sum_exec_runtime                :             6.159816
se.avg_overlap                     :             0.418181
nr_switches                        :                  287
nr_voluntary_switches              :                  287
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
udevd (951, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        223457.193058
se.vruntime                        :         33907.821876
se.sum_exec_runtime                :           368.903588
se.avg_overlap                     :             0.262037
nr_switches                        :                  993
nr_voluntary_switches              :                  292
nr_involuntary_switches            :                  701
se.load.weight                     :                 2501
policy                             :                    0
prio                               :                  116
clock-delta                        :                  205
khelper (9, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         44990.417536
se.vruntime                        :         28939.325175
se.sum_exec_runtime                :             6.698986
se.avg_overlap                     :             0.000974
nr_switches                        :                 1758
nr_voluntary_switches              :                 1741
nr_involuntary_switches            :                   17
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
-- /proc/sys/kernel/sched: --
/proc/sys/kernel/sched_batch_wakeup_granularity_ns:
20000000
/proc/sys/kernel/sched_child_runs_first:
1
/proc/sys/kernel/sched_compat_yield:
0
/proc/sys/kernel/sched_domain:
/proc/sys/kernel/sched_features:
15
/proc/sys/kernel/sched_latency_ns:
40000000
/proc/sys/kernel/sched_migration_cost:
500000
/proc/sys/kernel/sched_min_granularity_ns:
8000000
/proc/sys/kernel/sched_nr_migrate:
32
/proc/sys/kernel/sched_rt_period_us:
1000000
/proc/sys/kernel/sched_rt_runtime_us:
950000
/proc/sys/kernel/sched_wakeup_granularity_ns:
10000000
/proc/sys/kernel/sched_domain/cpu0/domain0/busy_factor:
64
/proc/sys/kernel/sched_domain/cpu0/domain0/busy_idx:
2
/proc/sys/kernel/sched_domain/cpu0/domain0/cache_nice_tries:
1
/proc/sys/kernel/sched_domain/cpu0/domain0/flags:
559
/proc/sys/kernel/sched_domain/cpu0/domain0/forkexec_idx:
1
/proc/sys/kernel/sched_domain/cpu0/domain0/idle_idx:
0
/proc/sys/kernel/sched_domain/cpu0/domain0/imbalance_pct:
125
/proc/sys/kernel/sched_domain/cpu0/domain0/max_interval:
4
/proc/sys/kernel/sched_domain/cpu0/domain0/min_interval:
1
/proc/sys/kernel/sched_domain/cpu0/domain0/newidle_idx:
0
/proc/sys/kernel/sched_domain/cpu0/domain0/wake_idx:
1
/proc/sys/kernel/sched_domain/cpu0/domain1/busy_factor:
64
/proc/sys/kernel/sched_domain/cpu0/domain1/busy_idx:
2
/proc/sys/kernel/sched_domain/cpu0/domain1/cache_nice_tries:
1
/proc/sys/kernel/sched_domain/cpu0/domain1/flags:
303
/proc/sys/kernel/sched_domain/cpu0/domain1/forkexec_idx:
1
/proc/sys/kernel/sched_domain/cpu0/domain1/idle_idx:
1
/proc/sys/kernel/sched_domain/cpu0/domain1/imbalance_pct:
125
/proc/sys/kernel/sched_domain/cpu0/domain1/max_interval:
4
/proc/sys/kernel/sched_domain/cpu0/domain1/min_interval:
1
/proc/sys/kernel/sched_domain/cpu0/domain1/newidle_idx:
2
/proc/sys/kernel/sched_domain/cpu0/domain1/wake_idx:
1
/proc/sys/kernel/sched_domain/cpu1/domain0/busy_factor:
64
/proc/sys/kernel/sched_domain/cpu1/domain0/busy_idx:
2
/proc/sys/kernel/sched_domain/cpu1/domain0/cache_nice_tries:
1
/proc/sys/kernel/sched_domain/cpu1/domain0/flags:
559
/proc/sys/kernel/sched_domain/cpu1/domain0/forkexec_idx:
1
/proc/sys/kernel/sched_domain/cpu1/domain0/idle_idx:
0
/proc/sys/kernel/sched_domain/cpu1/domain0/imbalance_pct:
125
/proc/sys/kernel/sched_domain/cpu1/domain0/max_interval:
4
/proc/sys/kernel/sched_domain/cpu1/domain0/min_interval:
1
/proc/sys/kernel/sched_domain/cpu1/domain0/newidle_idx:
0
/proc/sys/kernel/sched_domain/cpu1/domain0/wake_idx:
1
/proc/sys/kernel/sched_domain/cpu1/domain1/busy_factor:
64
/proc/sys/kernel/sched_domain/cpu1/domain1/busy_idx:
2
/proc/sys/kernel/sched_domain/cpu1/domain1/cache_nice_tries:
1
/proc/sys/kernel/sched_domain/cpu1/domain1/flags:
303
/proc/sys/kernel/sched_domain/cpu1/domain1/forkexec_idx:
1
/proc/sys/kernel/sched_domain/cpu1/domain1/idle_idx:
1
/proc/sys/kernel/sched_domain/cpu1/domain1/imbalance_pct:
125
/proc/sys/kernel/sched_domain/cpu1/domain1/max_interval:
4
/proc/sys/kernel/sched_domain/cpu1/domain1/min_interval:
1
/proc/sys/kernel/sched_domain/cpu1/domain1/newidle_idx:
2
/proc/sys/kernel/sched_domain/cpu1/domain1/wake_idx:
1
-- modules: --
Module                  Size  Used by
ieee1394               90164  0 
firmware_class          9600  0 
fuse                   49564  1 
snd_seq                52400  0 
snd_seq_device          8460  1 snd_seq
nls_iso8859_15          4864  1 
nls_cp850               5120  1 
vfat                   13952  1 
fat                    52512  1 vfat
usbhid                 23716  0 
appletouch             10240  0 
applesmc               20652  0 
input_polldev           5128  1 applesmc
led_class               5508  1 applesmc
dummy                   3584  0 
binfmt_misc            12040  1 
tun                    11904  0 
pktcdvd                35548  1 
loop                   18180  0 
msr                     4868  0 
cpuid                   4740  0 
coretemp                8192  0 
eeprom                  7440  0 
cpufreq_powersave       2048  0 
cpufreq_conservative     8072  0 
acpi_cpufreq            9484  1 
usb_storage            79424  0 
i2c_i801               10128  0 
i2c_core               24852  2 eeprom,i2c_i801
tpm_infineon            9640  0 
tpm                    15936  1 tpm_infineon
tpm_bios                7168  1 tpm
snd_hda_intel         339380  1 
ehci_hcd               35980  0 
battery                13188  0 
rng_core                5252  0 
thermal                18972  0 
iTCO_wdt               11812  0 
uhci_hcd               25232  0 
ac                      6148  0 
usbcore               144496  6 usbhid,appletouch,usb_storage,ehci_hcd,uhci_hcd
snd_pcm                69764  1 snd_hda_intel
snd_timer              23432  2 snd_seq,snd_pcm
snd                    48628  7 snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
soundcore               8032  1 snd
snd_page_alloc         10632  2 snd_hda_intel,snd_pcm
button                  8336  0 
evdev                  12160  12 
firewire_ohci          19200  0 
firewire_core          43584  1 firewire_ohci
processor              39112  4 acpi_cpufreq,thermal
intel_agp              27076  0 
sg                     32820  0 
sr_mod                 18372  1 
cdrom                  36512  2 pktcdvd,sr_mod
-- hw: --
-- pagetables: --
---[ User Space ]---
0x00000000-0xc0000000           3G                           pgd
---[ Kernel Mapping ]---
0xc0000000-0xc0001000           4K     RW PWT PCD     GLB x  pte
0xc0001000-0xc0400000        4092K     RW             GLB x  pte
0xc0400000-0xf8000000         892M     RW         PSE GLB x  pgd
0xf8000000-0xf8800000           8M                           pgd
---[ vmalloc() Area ]---
0xf8800000-0xf8801000           4K     RW PWT PCD     GLB x  pte
0xf8801000-0xf8802000           4K                           pte
0xf8802000-0xf8803000           4K     RW PWT PCD     GLB x  pte
0xf8803000-0xf8804000           4K                           pte
0xf8804000-0xf8805000           4K     RW PWT PCD     GLB x  pte
0xf8805000-0xf8806000           4K                           pte
0xf8806000-0xf8807000           4K     RW PWT PCD     GLB x  pte
0xf8807000-0xf8808000           4K                           pte
0xf8808000-0xf880d000          20K     RW PWT PCD     GLB x  pte
0xf880d000-0xf880e000           4K                           pte
0xf880e000-0xf880f000           4K     RW PWT PCD     GLB x  pte
0xf880f000-0xf8810000           4K                           pte
0xf8810000-0xf8811000           4K     RW PWT PCD     GLB x  pte
0xf8811000-0xf8812000           4K                           pte
0xf8812000-0xf8813000           4K     RW PWT PCD     GLB x  pte
0xf8813000-0xf8814000           4K                           pte
0xf8814000-0xf8815000           4K     RW PWT PCD     GLB x  pte
0xf8815000-0xf8816000           4K                           pte
0xf8816000-0xf8817000           4K     RW PWT PCD     GLB x  pte
0xf8817000-0xf8818000           4K                           pte
0xf8818000-0xf8819000           4K     RW PWT PCD     GLB x  pte
0xf8819000-0xf881a000           4K                           pte
0xf881a000-0xf881b000           4K     RW PWT PCD     GLB x  pte
0xf881b000-0xf881c000           4K                           pte
0xf881c000-0xf881d000           4K     RW PWT PCD     GLB x  pte
0xf881d000-0xf881e000           4K                           pte
0xf881e000-0xf881f000           4K     RW PWT PCD     GLB x  pte
0xf881f000-0xf8820000           4K                           pte
0xf8820000-0xf8821000           4K     RW PWT PCD     GLB x  pte
0xf8821000-0xf8822000           4K                           pte
0xf8822000-0xf8827000          20K     RW             GLB x  pte
0xf8827000-0xf8828000           4K                           pte
0xf8828000-0xf882c000          16K     RW PWT PCD     GLB x  pte
0xf882c000-0xf882d000           4K                           pte
0xf882d000-0xf8837000          40K     RW             GLB x  pte
0xf8837000-0xf8839000           8K                           pte
0xf8839000-0xf8842000          36K     RW             GLB x  pte
0xf8842000-0xf8843000           4K                           pte
0xf8843000-0xf884c000          36K     RW             GLB x  pte
0xf884c000-0xf884d000           4K                           pte
0xf884d000-0xf8854000          28K     RW             GLB x  pte
0xf8854000-0xf8856000           8K                           pte
0xf8856000-0xf8857000           4K     RW PWT PCD     GLB x  pte
0xf8857000-0xf8858000           4K                           pte
0xf8858000-0xf8859000           4K     RW PWT PCD     GLB x  pte
0xf8859000-0xf885a000           4K                           pte
0xf885a000-0xf885b000           4K     RW PWT PCD     GLB x  pte
0xf885b000-0xf885c000           4K                           pte
0xf885c000-0xf885d000           4K     RW PWT PCD     GLB x  pte
0xf885d000-0xf885e000           4K                           pte
0xf885e000-0xf8861000          12K     RW             GLB x  pte
0xf8861000-0xf8862000           4K                           pte
0xf8862000-0xf8864000           8K     RW             GLB x  pte
0xf8864000-0xf8865000           4K                           pte
0xf8865000-0xf886a000          20K     RW             GLB x  pte
0xf886a000-0xf886c000           8K                           pte
0xf886c000-0xf8877000          44K     RW             GLB x  pte
0xf8877000-0xf8878000           4K                           pte
0xf8878000-0xf887b000          12K     RW             GLB x  pte
0xf887b000-0xf887c000           4K                           pte
0xf887c000-0xf887f000          12K     RW             GLB x  pte
0xf887f000-0xf8880000           4K                           pte
0xf8880000-0xf8881000           4K     RW PWT PCD     GLB x  pte
0xf8881000-0xf8882000           4K                           pte
0xf8882000-0xf8883000           4K     RW             GLB x  pte
0xf8883000-0xf8884000           4K                           pte
0xf8884000-0xf8886000           8K     RW             GLB x  pte
0xf8886000-0xf8888000           8K                           pte
0xf8888000-0xf8889000           4K     RW PWT PCD     GLB x  pte
0xf8889000-0xf888a000           4K                           pte
0xf888a000-0xf888f000          20K     RW             GLB x  pte
0xf888f000-0xf8890000           4K                           pte
0xf8890000-0xf8896000          24K     RW             GLB x  pte
0xf8896000-0xf8897000           4K                           pte
0xf8897000-0xf88a3000          48K     RW             GLB x  pte
0xf88a3000-0xf88a4000           4K                           pte
0xf88a4000-0xf88ab000          28K     RW             GLB x  pte
0xf88ab000-0xf88ac000           4K                           pte
0xf88ac000-0xf88af000          12K     RW             GLB x  pte
0xf88af000-0xf88b0000           4K                           pte
0xf88b0000-0xf88b2000           8K     RW             GLB x  pte
0xf88b2000-0xf88b3000           4K                           pte
0xf88b3000-0xf88b5000           8K     RW             GLB x  pte
0xf88b5000-0xf88b6000           4K                           pte
0xf88b6000-0xf88b8000           8K     RW             GLB x  pte
0xf88b8000-0xf88b9000           4K                           pte
0xf88b9000-0xf88cb000          72K     RW             GLB x  pte
0xf88cb000-0xf88cc000           4K                           pte
0xf88cc000-0xf88cd000           4K     RW             GLB x  pte
0xf88cd000-0xf88ce000           4K                           pte
0xf88ce000-0xf88d1000          12K     RW             GLB x  pte
0xf88d1000-0xf88d2000           4K                           pte
0xf88d2000-0xf88d6000          16K     RW             GLB x  pte
0xf88d6000-0xf88d7000           4K                           pte
0xf88d7000-0xf88d9000           8K     RW             GLB x  pte
0xf88d9000-0xf88da000           4K                           pte
0xf88da000-0xf88de000          16K     RW             GLB x  pte
0xf88de000-0xf88df000           4K                           pte
0xf88df000-0xf88e2000          12K     RW             GLB x  pte
0xf88e2000-0xf88e3000           4K                           pte
0xf88e3000-0xf88ec000          36K     RW             GLB x  pte
0xf88ec000-0xf88ed000           4K                           pte
0xf88ed000-0xf88f0000          12K     RW             GLB x  pte
0xf88f0000-0xf88f1000           4K                           pte
0xf88f1000-0xf88f4000          12K     RW             GLB x  pte
0xf88f4000-0xf88f5000           4K                           pte
0xf88f5000-0xf88f7000           8K     RW             GLB x  pte
0xf88f7000-0xf88f8000           4K                           pte
0xf88f8000-0xf891c000         144K     RW             GLB x  pte
0xf891c000-0xf891d000           4K                           pte
0xf891d000-0xf8924000          28K     RW             GLB x  pte
0xf8924000-0xf8925000           4K                           pte
0xf8925000-0xf8927000           8K     RW             GLB x  pte
0xf8927000-0xf8928000           4K                           pte
0xf8928000-0xf892c000          16K     RW PWT PCD     GLB x  pte
0xf892c000-0xf892d000           4K                           pte
0xf892d000-0xf892f000           8K     RW             GLB x  pte
0xf892f000-0xf8930000           4K                           pte
0xf8930000-0xf8931000           4K     RW             GLB x  pte
0xf8931000-0xf8933000           8K                           pte
0xf8933000-0xf8934000           4K     RW             GLB x  pte
0xf8934000-0xf8937000          12K                           pte
0xf8937000-0xf893c000          20K     RW             GLB x  pte
0xf893c000-0xf893d000           4K                           pte
0xf893d000-0xf8940000          12K     RW             GLB x  pte
0xf8940000-0xf8941000           4K                           pte
0xf8941000-0xf8943000           8K     RW             GLB x  pte
0xf8943000-0xf8944000           4K                           pte
0xf8944000-0xf8946000           8K     RW             GLB x  pte
0xf8946000-0xf8949000          12K                           pte
0xf8949000-0xf895d000          80K     RW             GLB x  pte
0xf895d000-0xf895e000           4K                           pte
0xf895e000-0xf8967000          36K     RW             GLB x  pte
0xf8967000-0xf8968000           4K                           pte
0xf8968000-0xf896c000          16K     RW             GLB x  pte
0xf896c000-0xf896d000           4K                           pte
0xf896d000-0xf8970000          12K     RW             GLB x  pte
0xf8970000-0xf8971000           4K                           pte
0xf8971000-0xf8977000          24K     RW             GLB x  pte
0xf8977000-0xf897b000          16K                           pte
0xf897b000-0xf897d000           8K     RW             GLB x  pte
0xf897d000-0xf897e000           4K                           pte
0xf897e000-0xf8980000           8K     RW             GLB x  pte
0xf8980000-0xf8981000           4K                           pte
0xf8981000-0xf8987000          24K     RW             GLB x  pte
0xf8987000-0xf898b000          16K                           pte
0xf898b000-0xf89de000         332K     RW             GLB x  pte
0xf89de000-0xf89df000           4K                           pte
0xf89df000-0xf89e2000          12K     RW             GLB x  pte
0xf89e2000-0xf89e3000           4K                           pte
0xf89e3000-0xf89e6000          12K     RW             GLB x  pte
0xf89e6000-0xf89ef000          36K                           pte
0xf89ef000-0xf89fc000          52K     RW             GLB x  pte
0xf89fc000-0xf89fd000           4K                           pte
0xf89fd000-0xf8a92000         596K     RW             GLB x  pte
0xf8a92000-0xf8aa4000          72K                           pte
0xf8aa4000-0xf8ab1000          52K     RW             GLB x  pte
0xf8ab1000-0xf8ab2000           4K                           pte
0xf8ab2000-0xf8abf000          52K     RW             GLB x  pte
0xf8abf000-0xf8adc000         116K                           pte
0xf8adc000-0xf8af3000          92K     RW             GLB x  pte
0xf8af3000-0xf8c00000        1076K                           pte
0xf8c00000-0xff800000         108M                           pgd
---[ vmalloc() End ]---
0xff800000-0xff801000           4K                           pte
---[ Persisent kmap() Area ]---
0xff801000-0xffb68000        3484K     RW             GLB x  pte
0xffb68000-0xfff9b000        4300K                           pte
---[ Fixmap Area ]---
0xfff9b000-0xfff9c000           4K                           pte
0xfff9c000-0xfff9d000           4K     RW PWT PCD     GLB x  pte
0xfff9d000-0xfff9e000           4K     RW             GLB x  pte
0xfff9e000-0xffffa000         368K                           pte
0xffffa000-0xffffc000           8K     RW PWT PCD     GLB x  pte
0xffffc000-0x00000000          16K                           pte
-- interrupts: --
           CPU0       CPU1       
  0:      21623          0   IO-APIC-edge      timer
  9:       4742          0   IO-APIC-fasteoi   acpi
 14:         85          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         40          0   IO-APIC-fasteoi   uhci_hcd:usb4
 18:         39          0   IO-APIC-fasteoi   uhci_hcd:usb3
 19:       6717          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb2
 22:        304          0   IO-APIC-fasteoi   HDA Intel
 23:       2241          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5
219:         14          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:       6555      23917   Local timer interrupts
RES:       3436       7156   Rescheduling interrupts
CAL:        186        147   function call interrupts
TLB:        271        339   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0
-- cpuinfo: --
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping	: 8
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
apicid		: 0
initial apicid	: 0
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
bogomips	: 3666.80
clflush size	: 64
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 14
model name	: Genuine Intel(R) CPU           T2400  @ 1.83GHz
stepping	: 8
cpu MHz		: 1000.000
cache size	: 2048 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
apicid		: 1
initial apicid	: 1
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 10
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
bogomips	: 3663.34
clflush size	: 64
power management:

-- cpufreq: --
0
1000000
1833000
1000000
1833000 1667000 1500000 1333000 1000000 
powersave conservative ondemand performance 
1000000
acpi-cpufreq
ondemand
1833000
1000000
<unsupported>
1
1000000
1833000
1000000
1833000 1667000 1500000 1333000 1000000 
powersave conservative ondemand performance 
1000000
acpi-cpufreq
ondemand
1833000
1000000
<unsupported>
-- meminfo: --
MemTotal:      2060460 kB
MemFree:       1871820 kB
Buffers:         10172 kB
Cached:          86696 kB
SwapCached:          0 kB
Active:         108808 kB
Inactive:        57916 kB
HighTotal:     1164064 kB
HighFree:      1004440 kB
LowTotal:       896396 kB
LowFree:        867380 kB
SwapTotal:     1214416 kB
SwapFree:      1214416 kB
Dirty:             492 kB
Writeback:           0 kB
AnonPages:       69908 kB
Mapped:          32152 kB
Slab:            13396 kB
SReclaimable:     6816 kB
SUnreclaim:       6580 kB
PageTables:       1576 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2244644 kB
Committed_AS:   151168 kB
VmallocTotal:   114680 kB
VmallocUsed:      2752 kB
VmallocChunk:   111656 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB
-- buddyinfo: --
Node 0, zone      DMA      6      5      3      4      5      3      3      1      2      2      1 
Node 0, zone   Normal      1      2      1      1      1      0      1      1      2      2    207 
Node 0, zone  HighMem      0      2     56     65     29      5      4      1      2      0    243 
-- vmstat: --
nr_free_pages 467955
nr_inactive 14479
nr_active 27202
nr_anon_pages 17477
nr_mapped 8038
nr_file_pages 24217
nr_dirty 123
nr_writeback 0
nr_slab_reclaimable 1704
nr_slab_unreclaimable 1645
nr_page_table_pages 394
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
pgpgin 95525
pgpgout 2177
pswpin 0
pswpout 0
pgalloc_dma 1
pgalloc_normal 56782
pgalloc_high 154244
pgalloc_movable 0
pgfree 679204
pgactivate 10655
pgdeactivate 0
pgfault 602022
pgmajfault 979
pgrefill_dma 0
pgrefill_normal 0
pgrefill_high 0
pgrefill_movable 0
pgsteal_dma 0
pgsteal_normal 0
pgsteal_high 0
pgsteal_movable 0
pgscan_kswapd_dma 0
pgscan_kswapd_normal 0
pgscan_kswapd_high 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_normal 0
pgscan_direct_high 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 0
kswapd_steal 0
kswapd_inodesteal 0
pageoutrun 0
allocstall 0
pgrotated 0
-- zoneinfo: --
Node 0, zone      DMA
  pages free     3116
        min      17
        low      21
        high     25
        scanned  0 (a: 0 i: 0)
        spanned  4096
        present  4064
    nr_free_pages 3116
    nr_inactive  0
    nr_active    0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 1
    nr_page_table_pages 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 873, 2001, 2001)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
Node 0, zone   Normal
  pages free     213729
        min      936
        low      1170
        high     1404
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  223520
    nr_free_pages 213729
    nr_inactive  1001
    nr_active    1540
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 2541
    nr_dirty     41
    nr_writeback 0
    nr_slab_reclaimable 1704
    nr_slab_unreclaimable 1644
    nr_page_table_pages 394
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 9023, 9023)
  pagesets
    cpu: 0
              count: 47
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 40
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     251110
        min      128
        low      430
        high     733
        scanned  0 (a: 0 i: 0)
        spanned  291016
        present  288743
    nr_free_pages 251110
    nr_inactive  13478
    nr_active    25662
    nr_anon_pages 17477
    nr_mapped    8037
    nr_file_pages 21676
    nr_dirty     82
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 0
    nr_page_table_pages 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 73
              high:  186
              batch: 31
  vm stats threshold: 20
    cpu: 1
              count: 71
              high:  186
              batch: 31
  vm stats threshold: 20
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         229376
-- pagetypeinfo: --
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10 
Node    0, zone      DMA, type    Unmovable      1      1      1      1      1      1      1      1      1      1      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable      5      4      2      3      4      2      2      0      1      1      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone   Normal, type    Unmovable      0      1      1      0      0      0      0      1      1      1      0 
Node    0, zone   Normal, type  Reclaimable      1      0      0      0      0      0      1      0      1      0      0 
Node    0, zone   Normal, type      Movable      0      1      0      1      1      0      0      0      0      1    206 
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone   Normal, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type    Unmovable      0      1      1      0      0      1      1      0      1      0      0 
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type      Movable      0      1     55     65     29      4      3      1      1      0    242 
Node    0, zone  HighMem, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone  HighMem, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone   Normal            4            2          213            1            0 
Node 0, zone  HighMem            1            0          283            1            0 
-- slabinfo: --
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fuse_request           0      0    368   11    1 : tunables    0    0    0 : slabdata      0      0      0
fuse_inode             0      0    448    9    1 : tunables    0    0    0 : slabdata      0      0      0
fat_inode_cache       10     10    400   10    1 : tunables    0    0    0 : slabdata      1      1      0
fat_cache              0      0     24  170    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc_dma-512        8      8    512    8    1 : tunables    0    0    0 : slabdata      1      1      0
flow_cache             0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2464    3    2 : tunables    0    0    0 : slabdata      0      0      0
cfq_io_context        84     84     96   42    1 : tunables    0    0    0 : slabdata      2      2      0
bsg_cmd                0      0    288   14    1 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache      7      7    576    7    1 : tunables    0    0    0 : slabdata      1      1      0
hugetlbfs_inode_cache     11     11    344   11    1 : tunables    0    0    0 : slabdata      1      1      0
ext2_inode_cache       0      0    464    8    1 : tunables    0    0    0 : slabdata      0      0      0
journal_handle       340    340     24  170    1 : tunables    0    0    0 : slabdata      2      2      0
journal_head         197    584     56   73    1 : tunables    0    0    0 : slabdata      8      8      0
revoke_record        256    256     16  256    1 : tunables    0    0    0 : slabdata      1      1      0
ext3_inode_cache    4760   4760    472    8    1 : tunables    0    0    0 : slabdata    595    595      0
configfs_dir_cache     73     73     56   73    1 : tunables    0    0    0 : slabdata      1      1      0
shmem_inode_cache   3158   3159    440    9    1 : tunables    0    0    0 : slabdata    351    351      0
xfrm_dst_cache         0      0    320   12    1 : tunables    0    0    0 : slabdata      0      0      0
UDP                   14     14    576    7    1 : tunables    0    0    0 : slabdata      2      2      0
TCP                   12     12   1216    6    2 : tunables    0    0    0 : slabdata      2      2      0
sgpool-128             4      4   2048    4    2 : tunables    0    0    0 : slabdata      1      1      0
scsi_io_context        0      0    104   39    1 : tunables    0    0    0 : slabdata      0      0      0
blkdev_queue          21     21   1080    7    2 : tunables    0    0    0 : slabdata      3      3      0
biovec-256            66     66   3072    2    2 : tunables    0    0    0 : slabdata     33     33      0
biovec-128            75     75   1536    5    2 : tunables    0    0    0 : slabdata     15     15      0
biovec-64             76     80    768    5    1 : tunables    0    0    0 : slabdata     16     16      0
sock_inode_cache     173    180    384   10    1 : tunables    0    0    0 : slabdata     18     18      0
file_lock_cache       72     72    112   36    1 : tunables    0    0    0 : slabdata      2      2      0
Acpi-Operand        2953   2958     40  102    1 : tunables    0    0    0 : slabdata     29     29      0
Acpi-Namespace      1599   1700     24  170    1 : tunables    0    0    0 : slabdata     10     10      0
proc_inode_cache     847    847    360   11    1 : tunables    0    0    0 : slabdata     77     77      0
sigqueue              56     56    144   28    1 : tunables    0    0    0 : slabdata      2      2      0
radix_tree_node     2560   2561    296   13    1 : tunables    0    0    0 : slabdata    197    197      0
bdev_cache            24     24    512    8    1 : tunables    0    0    0 : slabdata      3      3      0
sysfs_dir_cache    11640  11645     48   85    1 : tunables    0    0    0 : slabdata    137    137      0
inode_cache         4037   4037    344   11    1 : tunables    0    0    0 : slabdata    367    367      0
dentry             17470  17472    128   32    1 : tunables    0    0    0 : slabdata    546    546      0
names_cache            4      4   4096    2    2 : tunables    0    0    0 : slabdata      2      2      0
idr_layer_cache      363    364    144   28    1 : tunables    0    0    0 : slabdata     13     13      0
buffer_head         6016   6016     64   64    1 : tunables    0    0    0 : slabdata     94     94      0
vm_area_struct      4545   4646     88   46    1 : tunables    0    0    0 : slabdata    101    101      0
files_cache           67     70    384   10    1 : tunables    0    0    0 : slabdata      7      7      0
signal_cache         310    324    448    9    1 : tunables    0    0    0 : slabdata     36     36      0
sighand_cache        106    108   1344    6    2 : tunables    0    0    0 : slabdata     18     18      0
task_struct          131    135    864    9    2 : tunables    0    0    0 : slabdata     15     15      0
anon_vma            1782   1792     16  256    1 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-4096          49     56   4096    8    8 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-2048         239    240   2048   16    8 : tunables    0    0    0 : slabdata     15     15      0
kmalloc-1024         254    256   1024    4    1 : tunables    0    0    0 : slabdata     64     64      0
kmalloc-512         1016   1024    512    8    1 : tunables    0    0    0 : slabdata    128    128      0
kmalloc-256           93     96    256   16    1 : tunables    0    0    0 : slabdata      6      6      0
kmalloc-128         2514   2528    128   32    1 : tunables    0    0    0 : slabdata     79     79      0
kmalloc-64          1850   1984     64   64    1 : tunables    0    0    0 : slabdata     31     31      0
kmalloc-32          1138   1152     32  128    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-16          4031   4096     16  256    1 : tunables    0    0    0 : slabdata     16     16      0
kmalloc-8           4592   4608      8  512    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-192          396    420    192   21    1 : tunables    0    0    0 : slabdata     20     20      0
kmalloc-96           438    504     96   42    1 : tunables    0    0    0 : slabdata     12     12      0
-- dmesg: --
[    0.000000] Linux version 2.6.25-rc6-x86-latest.git (thomas@hotzenplotz) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #5 SMP Mon Mar 24 21:06:47 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ede00 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f0c8000 (usable)
[    0.000000]  BIOS-e820: 000000007f0c8000 - 000000007f2c9000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f2c9000 - 000000007feb9000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007feb9000 - 000000007feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007feef000 - 000000007ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff00000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 1136MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] CPU and/or kernel does not support PAT.
[    0.000000] Entering add_active_range(0, 0, 520392) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   520392
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   520392
[    0.000000] On node 0 totalpages: 520392
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2273 pages used for memmap
[    0.000000]   HighMem zone: 288743 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 7FEFD120, 0074 (r1 APPLE   Apple00       55       1000013)
[    0.000000] ACPI: FACP 7FEFB000, 00F4 (r3 APPLE   Apple00       55 Loki       5F)
[    0.000000] ACPI: DSDT 7FEF0000, 48C0 (r1 APPLE  MacBookP    10001 INTL 20050309)
[    0.000000] ACPI: FACS 7FEBB000, 0040
[    0.000000] ACPI: HPET 7FEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: APIC 7FEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: MCFG 7FEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ASF! 7FEF7000, 009C (r32 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SBST 7FEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: ECDT 7FEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
[    0.000000] ACPI: SSDT 7FEB6000, 064F (r1 APPLE   SataPri     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEB5000, 069C (r1 APPLE   SataSec     1000 INTL 20050309)
[    0.000000] ACPI: SSDT 7FEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ee000
[    0.000000] PM: Registered nosave memory: 00000000000ee000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 34176 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516327
[    0.000000] Kernel command line: root=/dev/sda3 lapic_timer_c2_ok BOOT_IMAGE=bzImage 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c0430000 soft=c042e000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Detected 1830.950 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 2059436k/2081568k available (2202k kernel code, 20956k reserved, 780k data, 240k init, 1164064k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc03ef000 - 0xc042b000   ( 240 kB)
[    0.003333]       .data : 0xc0326b31 - 0xc03e9d40   ( 780 kB)
[    0.003333]       .text : 0xc0100000 - 0xc0326b31   (2202 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333] ioremap: fed00000(00000400) => f8800000<7>hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 3666.80 BogoMIPS (lpj=6108494)
[    0.083435] Mount-cache hash table entries: 512
[    0.083597] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083669] CPU: L2 cache: 2048K
[    0.083710] CPU: Physical Processor ID: 0
[    0.083750] CPU: Processor Core ID: 0
[    0.083792] Intel machine check architecture supported.
[    0.083836] Intel machine check reporting enabled on CPU#0.
[    0.083878] using mwait in idle threads.
[    0.083921] Compat vDSO mapped to ffffe000.
[    0.083966] Checking 'hlt' instruction... OK.
[    0.097017] ACPI: Core revision 20070126
[    0.097082] ioremap: 7fef0000(000048c0) => f8808000ioremap: 7feb6000(0000064f) => f8802000ioremap: 7feb5000(0000069c) => f8804000ioremap: 7feef000(000004dc) => f8806000ENABLING IO-APIC IRQs
[    0.107128] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.140838] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.143324] CPU 1 irqstacks, hard=c0431000 soft=c042f000
[    0.143324] Booting processor 1/1 ip 4000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3663.34 BogoMIPS (lpj=6102949)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.233828] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.234279] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.236661] Brought up 2 CPUs
[    0.236705] Total of 2 processors activated (7329.15 BogoMIPS).
[    0.236770] CPU0 attaching sched-domain:
[    0.236772]  domain 0: span 3
[    0.236774]   groups: 1 2
[    0.236778] CPU1 attaching sched-domain:
[    0.236780]  domain 0: span 3
[    0.236781]   groups: 2 1
[    0.237035] net_namespace: 448 bytes
[    0.237238] NET: Registered protocol family 16
[    0.237449] No dock devices found.
[    0.237563] ACPI: bus type pci registered
[    0.237673] ioremap: 7fef8000(0000003c) => f880e000<5>PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.237795] PCI: Not using MMCONFIG.
[    0.237836] PCI: Fatal: No config space access function found
[    0.237878] Setting up standard PCI resources
[    0.240487] ioremap: 7febb000(00000040) => f8810000ioremap: 7fef5000(00000053) => f8812000<6>ACPI: EC: EC description table is found, configuring boot EC
[    0.241009] ioremap: 7fed5c1f(000000f1) => f8814c1f<6>ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.243396] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.243471] ioremap: 7fed5c10(00000100) => f8814c10<6>ACPI: Interpreter enabled
[    0.246429] ACPI: (supports S0 S3 S4 S5)
[    0.246591] ACPI: Using IOAPIC for interrupt routing
[    0.246677] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.246904] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.247019] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.247142] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.247308] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.247462] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.247575] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.247690] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.247855] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.248008] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.248122] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.248236] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.248401] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.248553] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.248666] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.248781] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.248946] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.249098] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.250022] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.250136] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.250301] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.250453] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.250567] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.250680] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.250846] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.250998] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.251111] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.251225] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.251390] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.251542] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.251655] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.251769] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.251935] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.252203] ioremap: fed1f404(00000bfc) => f8816404<5>PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.256977] PCI: Using MMCONFIG for extended config space
[    0.269809] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.269854] ACPI: EC: driver started in poll mode
[    0.271136] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.271786] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.271840] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.272613] PCI: Transparent bridge - 0000:00:1e.0
[    0.272688] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.273045] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.273182] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.273319] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.273452] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.273593] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.280500] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.281010] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.281484] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.281987] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.282449] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.282989] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.283509] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.284009] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.284468] ioremap: 7fefb000(000000f4) => f8818000ioremap: 7fefa000(00000038) => f881a000ioremap: 7fef9000(00000068) => f881c000ioremap: 7fef7000(0000009c) => f881e000ioremap: 7fef6000(00000030) => f8820000<6>Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.285106] pnp: PnP ACPI init
[    0.285150] ACPI: bus type pnp registered
[    0.287340] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.291485] pnp: PnP ACPI: found 10 devices
[    0.291526] ACPI: ACPI bus type pnp unregistered
[    0.291897] SCSI subsystem initialized
[    0.292067] libata version 3.00 loaded.
[    0.292205] PCI: Using ACPI for IRQ routing
[    0.292266] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.292336] PCI: System does not support PCI
[    0.292375] PCI: System does not support PCI
[    0.296662] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.296817] hpet0: 3 64-bit timers, 14318180 Hz
[    0.299979] Time: tsc clocksource has been installed.
[    0.303325] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.303378] system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.303430] system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.303481] system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.303533] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.303584] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.303633] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.303680] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.303724] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.303766] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.303810] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.303852] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.303895] system 00:08: ioport range 0x1640-0x164f has been reserved
[    0.334457] PCI: Bridge: 0000:00:01.0
[    0.334499]   IO window: 2000-2fff
[    0.334539]   MEM window: 0x94000000-0x940fffff
[    0.334581]   PREFETCH window: 0x0000000088000000-0x0000000093ffffff
[    0.334636] PCI: Bridge: 0000:00:1c.0
[    0.334676]   IO window: 3000-3fff
[    0.334719]   MEM window: 0x94100000-0x941fffff
[    0.334761]   PREFETCH window: 0x0000000094200000-0x00000000942fffff
[    0.334815] PCI: Bridge: 0000:00:1c.1
[    0.334854]   IO window: disabled.
[    0.334898]   MEM window: 0x94300000-0x943fffff
[    0.334941]   PREFETCH window: disabled.
[    0.334984] PCI: Bridge: 0000:00:1c.2
[    0.335023]   IO window: disabled.
[    0.335067]   MEM window: disabled.
[    0.335108]   PREFETCH window: disabled.
[    0.335155] PCI: Bridge: 0000:00:1e.0
[    0.335194]   IO window: disabled.
[    0.335238]   MEM window: 0x00000000-0x000fffff
[    0.335280]   PREFETCH window: disabled.
[    0.335331] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.335413] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.335432] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.335515] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.335533] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.335617] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.335635] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.335718] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.335730] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.335739] NET: Registered protocol family 2
[    0.346684] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.346924] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.347633] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.348005] TCP: Hash tables configured (established 131072 bind 65536)
[    0.348049] TCP reno registered
[    0.116129] Machine check exception polling timer started.
[    0.116626] highmem bounce pool size: 64 pages
[    0.116663] Total HugeTLB memory allocated, 0
[    0.118624] VFS: Disk quotas dquot_6.5.1
[    0.118689] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.119269] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.119321] io scheduler noop registered
[    0.119362] io scheduler anticipatory registered
[    0.119403] io scheduler deadline registered
[    0.119491] io scheduler cfq registered (default)
[    0.119603] ioremap: 94405000(00000400) => f8822000<7>pci 0000:01:00.0: Boot video device
[    0.119907] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.119924] assign_interrupt_mode Found MSI capability
[    0.119979] Allocate Port Service[0000:00:01.0:pcie00]
[    0.120028] Allocate Port Service[0000:00:01.0:pcie03]
[    0.120089] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.120125] assign_interrupt_mode Found MSI capability
[    0.120200] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.120233] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.120267] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.120351] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.120387] assign_interrupt_mode Found MSI capability
[    0.120462] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.120495] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.120528] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.120612] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.120649] assign_interrupt_mode Found MSI capability
[    0.120723] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.120758] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.120791] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.141833] ioremap: fed00000(00000400) => f8822000<7>hpet_resources: 0xfed00000 is busy
[    0.141993] Linux agpgart interface v0.103
[    0.142073] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.142162] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    0.142173] ioremap: 94100000(00004000) => f8828000<6>sky2 0000:02:00.0: v1.21 addr 0x94100000 irq 16 Yukon-EC (0xb6) rev 2
[    0.380373] sky2 eth0: addr 00:16:cb:8c:b2:65
[    0.380465] console [netcon0] enabled
[    0.383310] netconsole: network logging started
[    0.383404] input: Macintosh mouse button emulation as /class/input/input0
[    0.383491] Driver 'sd' needs updating - please use bus_type methods
[    0.383611] ata_piix 0000:00:1f.1: version 2.12
[    0.383618] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.383724] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.383802] scsi0 : ata_piix
[    0.383904] scsi1 : ata_piix
[    0.384470] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 irq 14
[    0.384515] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 irq 15
[    0.273322] Switched to high resolution mode on CPU 1
[    0.503303] Switched to high resolution mode on CPU 0
[    0.287241] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    0.297178] ata1.00: configured for UDMA/66
[    0.506633] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAEA PQ: 0 ANSI: 5
[    0.506633] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
[    0.506633] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    0.506633] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.513308] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.513349] scsi2 : ata_piix
[    0.513458] scsi3 : ata_piix
[    0.514451] ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10d0 bmdma 0x10b0 irq 19
[    0.514496] ata4: SATA max UDMA/133 cmd 0x10c8 ctl 0x10d4 bmdma 0x10b8 irq 19
[    0.533298] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    0.533298] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    0.537212] ata3.01: configured for UDMA/133
[    0.543298] scsi 2:0:1:0: Direct-Access     ATA      WDC WD1600BEVS-0 04.0 PQ: 0 ANSI: 5
[    0.543298] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    0.543298] sd 2:0:1:0: [sda] Write Protect is off
[    0.543298] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.543298] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.543298] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    0.543298] sd 2:0:1:0: [sda] Write Protect is off
[    0.543298] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.543298] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.543298]  sda: sda1 sda2 sda3 sda4 sda6
[    0.553297] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.553297] PNP: No PS/2 controller found. Probing ports directly.
[    0.553297] i8042.c: No controller found.
[    0.553338] mice: PS/2 mouse device common for all mice
[    0.554824] device-mapper: uevent: version 1.0.3
[    0.554920] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    0.554981] cpuidle: using governor ladder
[    0.555021] cpuidle: using governor menu
[    0.555452] TCP cubic registered
[    0.555499] NET: Registered protocol family 1
[    0.555549] NET: Registered protocol family 17
[    0.555594] Using IPI No-Shortcut mode
[    0.366643] kjournald starting.  Commit interval 5 seconds
[    0.566630] EXT3-fs: mounted filesystem with ordered data mode.
[    0.566630] VFS: Mounted root (ext3 filesystem) readonly.
[    0.566630] Freeing unused kernel memory: 240k freed
[    1.306583] Driver 'sr' needs updating - please use bus_type methods
[    1.308441] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.308445] Uniform CD-ROM driver Revision: 3.20
[    1.308701] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.341790] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.342294] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.467453] ioremap: 7feb3c90(0000022a) => f8856c90ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[    1.467743] ioremap: 7feb2c10(000002c3) => f8858c10ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[    1.468143] Monitor-Mwait will be used to enter C-1 state
[    1.468146] Monitor-Mwait will be used to enter C-2 state
[    1.468149] Monitor-Mwait will be used to enter C-3 state
[    1.468199] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.468225] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.468229] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.468535] ioremap: 7feb3f10(00000087) => f885af10ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[    1.468765] ioremap: 7feb2f10(00000085) => f885cf10ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[    1.161734] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.161752] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.161756] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.163746] Marking TSC unstable due to: TSC halts in idle.
[    1.473239] Time: hpet clocksource has been installed.
[    1.496945] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[    1.496945] firewire_ohci: Failed to remap registers
[    1.496945] ACPI: PCI interrupt for device 0000:0c:03.0 disabled
[    1.272498] input: Power Button (FF) as /class/input/input1
[    1.285930] ACPI: Power Button (FF) [PWRF]
[    1.285930] input: Lid Switch as /class/input/input2
[    1.286774] ACPI: Lid Switch [LID0]
[    1.286826] input: Power Button (CM) as /class/input/input3
[    1.312476] ACPI: Power Button (CM) [PWRB]
[    1.312570] input: Sleep Button (CM) as /class/input/input4
[    1.317199] ACPI: Sleep Button (CM) [SLPB]
[    1.336586] usbcore: registered new interface driver usbfs
[    1.336608] usbcore: registered new interface driver hub
[    1.339257] usbcore: registered new device driver usb
[    1.651847] ACPI: AC Adapter [ADP1] (on-line)
[    1.353034] USB Universal Host Controller Interface driver v3.0
[    1.353082] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    1.353093] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    1.353096] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.353317] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
[    1.353352] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001000
[    1.353477] usb usb1: configuration #1 chosen from 1 choice
[    1.353501] hub 1-0:1.0: USB hub found
[    1.353507] hub 1-0:1.0: 2 ports detected
[    1.700311] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    1.700367] ioremap: fed1f410(00000004) => f8888410<6>iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
[    1.700414] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    1.721612] ioremap: ffff0000(00000002) => f88cc000<3>intel_rng: FWH not detected
[    1.454609] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    1.454623] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    1.454627] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.454654] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
[    1.454691] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
[    1.454804] usb usb2: configuration #1 chosen from 1 choice
[    1.454828] hub 2-0:1.0: USB hub found
[    1.454834] hub 2-0:1.0: 2 ports detected
[    1.786163] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[    1.786163] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    1.826602] ACPI: Battery Slot [BAT0] (battery present)
[    1.558327] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    1.558344] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    1.558351] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.558393] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
[    1.558456] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    1.558563] usb usb3: configuration #1 chosen from 1 choice
[    1.558586] hub 3-0:1.0: USB hub found
[    1.558592] hub 3-0:1.0: 2 ports detected
[    1.665147] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    1.665165] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    1.665171] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    1.665212] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
[    1.665253] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001060
[    1.665420] usb usb4: configuration #1 chosen from 1 choice
[    1.665448] hub 4-0:1.0: USB hub found
[    1.665453] hub 4-0:1.0: 2 ports detected
[    1.955976] Clocksource tsc unstable (delta = -69275702 ns)
[    1.975436] usb 1-2: new full speed USB device using uhci_hcd and address 2
[    2.059225] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    2.059225] ioremap: 94400000(00004000) => f8928000<7>PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    2.091213] hda_codec: STAC922x, Apple subsys_id=106b0200
[    2.124646] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    2.124646] ioremap: 94405000(00000400) => f8880000<7>PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    2.124646] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.124646] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
[    2.126158] ehci_hcd 0000:00:1d.7: debug port 1
[    2.126165] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    2.126172] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94405000
[    2.139366] usb 1-2: string descriptor 0 read error: -71
[    2.139623] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    2.139762] usb usb5: configuration #1 chosen from 1 choice
[    2.139785] hub 5-0:1.0: USB hub found
[    2.139793] hub 5-0:1.0: 8 ports detected
[    2.147185] usb 1-2: string descriptor 0 read error: -71
[    2.147185] usb 1-2: configuration #1 chosen from 1 choice
[    2.151605] usb 1-2: can't set config #1, error -71
[    1.959605] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    3.082503] usb 5-3: new high speed USB device using ehci_hcd and address 3
[    3.208527] usb 5-3: configuration #1 chosen from 1 choice
[    3.009304] Initializing USB Mass Storage driver...
[    3.432480] usb 5-4: new high speed USB device using ehci_hcd and address 4
[    3.229839] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    3.513827] EXT3 FS on sda3, internal journal
[    3.557981] usb 5-4: configuration #1 chosen from 1 choice
[    3.612078] loop: module loaded
[    3.953906] tun: Universal TUN/TAP device driver, 1.6
[    3.953912] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.008798] usb 1-2: USB disconnect, address 2
[    3.734537] scsi4 : SCSI emulation for USB Mass Storage devices
[    4.017052] usb-storage: device found at 3
[    4.017056] usb-storage: waiting for device to settle before scanning
[    3.734888] usbcore: registered new interface driver usb-storage
[    3.735168] USB Mass Storage support registered.
[    4.046859] applesmc: Apple MacBook Pro detected:
[    4.046865] applesmc:  - Model with accelerometer
[    4.046868] applesmc:  - Model with light sensors and backlight
[    4.046872] applesmc:  - Model with 12 temperature sensors
[    4.101110] applesmc: device successfully initialized (0xe0, 0x00).
[    4.101110] applesmc: device successfully initialized.
[    4.101110] applesmc: 2 fans found.
[    4.101110] input: applesmc as /class/input/input5
[    4.102336] Registered led device: smc::kbd_backlight
[    4.102374] applesmc: driver successfully loaded.
[    4.243609] usb 1-2: new full speed USB device using uhci_hcd and address 3
[    4.423428] usb 1-2: configuration #1 chosen from 1 choice
[    4.661462] usb 3-2: new full speed USB device using uhci_hcd and address 2
[    4.832578] usb 3-2: configuration #1 chosen from 1 choice
[    5.063403] usb 4-1: new full speed USB device using uhci_hcd and address 2
[    5.231625] usb 4-1: configuration #1 chosen from 1 choice
[    5.239973] appletouch: Geyser mode initialized.
[    5.239973] input: appletouch as /class/input/input6
[    5.277313] usbcore: registered new interface driver appletouch
[    5.281361] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input7
[    5.291654] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    5.295176] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input8
[    5.295176] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    5.300053] HID device claimed by neither input, hiddev nor hidraw
[    5.319080] input: HID 05ac:1000 as /class/input/input9
[    5.319080] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
[    5.337071] input: HID 05ac:1000 as /class/input/input10
[    5.346708] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[    5.346748] usbcore: registered new interface driver usbhid
[    5.346754] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    9.038842] usb-storage: device scan complete
[    8.758044] scsi 4:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
[    8.760509] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    8.761373] sd 4:0:0:0: [sdb] Write Protect is off
[    8.761378] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    8.761383] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    8.764370] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    8.765245] sd 4:0:0:0: [sdb] Write Protect is off
[    8.765250] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    8.765254] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    8.765259]  sdb: sdb1 sdb2
[    8.766132] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    8.766196] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   11.078698] kjournald starting.  Commit interval 90 seconds
[   11.078698] EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
[   11.078836] EXT3 FS on dm-1, internal journal
[   11.078836] EXT3-fs: mounted filesystem with ordered data mode.
[   11.574736] Adding 1214416k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1214416k
[   13.079338] sky2 eth0: enabling interface
[   14.869515] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   24.476769] fuse init (API version 7.9)
[   24.618131] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   25.817183] pktcdvd: writer pktcdvd0 mapped to sr0
[   28.616180] CPU0 attaching NULL sched-domain.
[   28.616191] CPU1 attaching NULL sched-domain.
[   28.616718] CPU0 attaching sched-domain:
[   28.616725]  domain 0: span 3
[   28.616728]   groups: 1 2
[   28.616734]   domain 1: span 3
[   28.616737]    groups: 3
[   28.616742] CPU1 attaching sched-domain:
[   28.616745]  domain 0: span 3
[   28.616748]   groups: 2 1
[   28.616753]   domain 1: span 3
[   28.616756]    groups: 3
[  162.485605] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[  162.485695] ioremap: 00000000(00000800) => f8978000<3>ohci1394: fw-host0: Get PHY Reg timeout [0x00008400/0x00000000/100]
[  162.642198] ohci1394: fw-host0: Set PHY Reg timeout [0x000044c0/0x00004000/100]
[  162.642232] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]
[  162.645531] ohci1394: fw-host0: Get PHY Reg timeout [0x00008200/0x00000000/100]
[  162.645536] ohci1394: fw-host0: Serial EEPROM has suspicious values, attempting to set max_packet_size to 512 bytes
[  163.648889] ohci1394: fw-host0: Get PHY Reg timeout [0x00008500/0x00000000/100]
[  163.652222] ohci1394: fw-host0: Set PHY Reg timeout [0x00004540/0x00004000/100]
[  208.022643] ohci1394: fw-host0: Unrecoverable error!
[  208.022643] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.022643] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.022643] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.022643] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.022643] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.022643] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.022643] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.022643] ohci1394: fw-host0: physical posted write error
[  208.022643] ohci1394: fw-host0: isochronous cycle too long
[  208.022643] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.022643] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.022643] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.022643] ohci1394: fw-host0: Unrecoverable error!
[  208.022643] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.022644] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.022644] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.022644] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.022644] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.022644] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.022644] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.022644] ohci1394: fw-host0: physical posted write error
[  208.022644] ohci1394: fw-host0: isochronous cycle too long
[  208.022644] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.022644] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.022644] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.325303] ohci1394: fw-host0: Unrecoverable error!
[  208.325303] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.325303] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.325303] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.325303] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.325303] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.325303] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.325303] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.325303] ohci1394: fw-host0: physical posted write error
[  208.325303] ohci1394: fw-host0: isochronous cycle too long
[  208.325303] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.325303] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.325303] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.353491] ohci1394: fw-host0: Unrecoverable error!
[  208.353491] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.353491] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.353491] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.353491] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.353491] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.353491] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.353491] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.353491] ohci1394: fw-host0: physical posted write error
[  208.353491] ohci1394: fw-host0: isochronous cycle too long
[  208.353491] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.353491] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.353491] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.353491] ohci1394: fw-host0: Unrecoverable error!
[  208.353491] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.353491] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.353491] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.353491] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.353491] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.353491] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.353491] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.353491] ohci1394: fw-host0: physical posted write error
[  208.353491] ohci1394: fw-host0: isochronous cycle too long
[  208.353491] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.353491] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.353491] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.353491] ohci1394: fw-host0: Unrecoverable error!
[  208.353491] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.353491] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.353491] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.353491] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.353491] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.353491] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.353491] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.353491] ohci1394: fw-host0: physical posted write error
[  208.353491] ohci1394: fw-host0: isochronous cycle too long
[  208.353491] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.353491] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.353491] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.353785] ohci1394: fw-host0: Unrecoverable error!
[  208.353792] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.353803] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.353812] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.353819] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.353825] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.353833] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.353840] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.353845] ohci1394: fw-host0: physical posted write error
[  208.353849] ohci1394: fw-host0: isochronous cycle too long
[  208.353854] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.353859] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.353863] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.354238] ohci1394: fw-host0: Unrecoverable error!
[  208.354244] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.354256] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.354265] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.354271] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.354278] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.354286] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.354292] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.354298] ohci1394: fw-host0: physical posted write error
[  208.354301] ohci1394: fw-host0: isochronous cycle too long
[  208.354306] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.354311] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.354316] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.354745] ohci1394: fw-host0: Unrecoverable error!
[  208.354752] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.354763] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.354772] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.354778] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.354785] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.354793] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.354799] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.354805] ohci1394: fw-host0: physical posted write error
[  208.354809] ohci1394: fw-host0: isochronous cycle too long
[  208.354813] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.354818] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.354823] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.355222] ohci1394: fw-host0: Unrecoverable error!
[  208.355229] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.355240] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.355249] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.355256] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.355262] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.355270] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.355276] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.355282] ohci1394: fw-host0: physical posted write error
[  208.355286] ohci1394: fw-host0: isochronous cycle too long
[  208.355291] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.355296] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.355300] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.355648] ohci1394: fw-host0: Unrecoverable error!
[  208.355655] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.355666] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.355675] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.355681] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.355688] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.355696] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.355702] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.355708] ohci1394: fw-host0: physical posted write error
[  208.355713] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.355718] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.355722] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.356056] ohci1394: fw-host0: Unrecoverable error!
[  208.356063] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.356074] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.356083] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.356090] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.356096] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.356104] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.356110] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.356116] ohci1394: fw-host0: physical posted write error
[  208.356121] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.356126] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.356130] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.356719] ohci1394: fw-host0: Unrecoverable error!
[  208.356724] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.356736] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.356744] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.356751] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.356758] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.356765] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.356772] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.356777] ohci1394: fw-host0: physical posted write error
[  208.356782] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.356788] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.356792] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.356824] ohci1394: fw-host0: Unrecoverable error!
[  208.356824] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.356824] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.356824] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.356824] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.356824] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.356824] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.356824] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.356824] ohci1394: fw-host0: physical posted write error
[  208.356824] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.356824] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.356824] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.356824] ohci1394: fw-host0: Unrecoverable error!
[  208.356824] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.356824] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.356824] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.356824] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.356824] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.356824] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.356824] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.356824] ohci1394: fw-host0: physical posted write error
[  208.356824] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.356824] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.356824] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.356977] ohci1394: fw-host0: Unrecoverable error!
[  208.356982] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.356994] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.357002] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.357009] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.357016] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.357023] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.357030] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.357036] ohci1394: fw-host0: physical posted write error
[  208.357041] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.357046] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.357050] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.357294] ohci1394: fw-host0: Unrecoverable error!
[  208.357299] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.357310] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.357319] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.357326] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.357333] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.357340] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.357347] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.357352] ohci1394: fw-host0: physical posted write error
[  208.357357] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.357362] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.357367] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.357730] ohci1394: fw-host0: Unrecoverable error!
[  208.357736] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.357747] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.357756] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.357762] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.357769] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.357776] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.357783] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.357789] ohci1394: fw-host0: physical posted write error
[  208.357794] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.357799] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.357803] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.358098] ohci1394: fw-host0: Unrecoverable error!
[  208.358104] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.358117] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.358128] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.358136] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.358145] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.358154] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.358163] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.358170] ohci1394: fw-host0: physical posted write error
[  208.358176] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.358183] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.358189] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.358513] ohci1394: fw-host0: Unrecoverable error!
[  208.358520] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.358533] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.358543] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.358551] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.358560] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.358569] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.358577] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.358584] ohci1394: fw-host0: physical posted write error
[  208.358591] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.358598] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.358604] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.358899] ohci1394: fw-host0: Unrecoverable error!
[  208.358905] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.358918] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.358928] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.358937] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.358945] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.358954] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.358963] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.358970] ohci1394: fw-host0: physical posted write error
[  208.358976] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.358982] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.358989] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.359514] ohci1394: fw-host0: Unrecoverable error!
[  208.359523] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.359534] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.359543] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.359550] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.359556] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.359564] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.359570] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.359576] ohci1394: fw-host0: physical posted write error
[  208.359581] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.359586] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.359590] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.359894] ohci1394: fw-host0: Unrecoverable error!
[  208.359899] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.359911] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.359919] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.359926] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.359933] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.359941] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.359947] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.359953] ohci1394: fw-host0: physical posted write error
[  208.359958] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.359963] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.359967] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.360408] ohci1394: fw-host0: Unrecoverable error!
[  208.360413] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.360424] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.360433] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.360439] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.360446] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.360454] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.360461] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.360466] ohci1394: fw-host0: physical posted write error
[  208.360471] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.360476] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.360480] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.360906] ohci1394: fw-host0: Unrecoverable error!
[  208.360912] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.360923] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.360932] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.360939] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.360945] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.360953] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.360959] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.360965] ohci1394: fw-host0: physical posted write error
[  208.360970] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.360975] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.360979] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.361530] ohci1394: fw-host0: Unrecoverable error!
[  208.361535] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.361547] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.361556] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.361562] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.361569] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.361577] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.361583] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.361589] ohci1394: fw-host0: physical posted write error
[  208.361594] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.361599] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.361603] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.361890] ohci1394: fw-host0: Unrecoverable error!
[  208.361895] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.361906] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.361915] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.361922] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.361928] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.361936] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.361943] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.361948] ohci1394: fw-host0: physical posted write error
[  208.361953] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.361958] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.361962] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.362197] ohci1394: fw-host0: Unrecoverable error!
[  208.362202] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.362214] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.362222] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.362229] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.362236] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.362243] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.362250] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.362256] ohci1394: fw-host0: physical posted write error
[  208.362260] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.362266] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.362270] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.362611] ohci1394: fw-host0: Unrecoverable error!
[  208.362616] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.362628] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.362636] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.362643] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.362650] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.362657] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.362664] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.362670] ohci1394: fw-host0: physical posted write error
[  208.362674] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.362680] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.362684] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.363007] ohci1394: fw-host0: Unrecoverable error!
[  208.363012] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.363023] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.363032] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.363039] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.363045] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.363053] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.363060] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.363065] ohci1394: fw-host0: physical posted write error
[  208.363070] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.363075] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.363080] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.363625] ohci1394: fw-host0: Unrecoverable error!
[  208.363632] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.363645] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.363655] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.363664] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.363672] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.363682] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.363690] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.363697] ohci1394: fw-host0: physical posted write error
[  208.363703] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.363710] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.363716] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.364003] ohci1394: fw-host0: Unrecoverable error!
[  208.364010] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.364022] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.364033] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.364041] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.364050] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.364059] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.364067] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.364074] ohci1394: fw-host0: physical posted write error
[  208.364081] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.364088] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.364094] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.364432] ohci1394: fw-host0: Unrecoverable error!
[  208.364439] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.364452] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.364463] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.364471] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.364479] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.364489] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.364497] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.364504] ohci1394: fw-host0: physical posted write error
[  208.364511] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.364518] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.364524] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.364939] ohci1394: fw-host0: Unrecoverable error!
[  208.364945] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.364958] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.364968] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.364977] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.364985] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.364994] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.365003] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.365010] ohci1394: fw-host0: physical posted write error
[  208.365017] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.365023] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.365029] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.365748] ohci1394: fw-host0: Unrecoverable error!
[  208.365756] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.365767] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.365776] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.365783] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.365789] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.365797] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.365804] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.365809] ohci1394: fw-host0: physical posted write error
[  208.365814] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.365819] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.365824] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.366224] ohci1394: fw-host0: Unrecoverable error!
[  208.366230] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.366241] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.366250] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.366257] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.366263] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.366271] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.366278] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.366283] ohci1394: fw-host0: physical posted write error
[  208.366288] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.366293] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.366297] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  208.366778] ohci1394: fw-host0: Unrecoverable error!
[  208.366783] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[  208.366794] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00142c19] match[00000000]
[  208.366803] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[  208.366809] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[  208.366816] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[  208.366823] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[  208.366823] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[  208.366823] ohci1394: fw-host0: physical posted write error
[  208.366823] ohci1394: fw-host0: respTxComplete: dma prg stopped
[  208.366823] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[  208.366823] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[  223.341408] ohci1394: fw-host0: Get PHY Reg timeout [0x00008400/0x00000000/100]
[  223.344741] ohci1394: fw-host0: Set PHY Reg timeout [0x00004400/0x00004000/100]
[  223.348074] ohci1394: fw-host0: Get PHY Reg timeout [0x00008100/0x00000000/100]
[  223.351407] ohci1394: fw-host0: Set PHY Reg timeout [0x00004140/0x00004000/100]
-- /proc/timer_list: --
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 262679837115 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206389439961368821 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6005ebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 262679973732 nsecs [in 136617 nsecs]
 #1: <f6005ebc>, hrtimer_wakeup, S:01, do_nanosleep, kwrapper4/3372
 # expires at 263209908675 nsecs [in 530071560 nsecs]
 #2: <f6005ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2914
 # expires at 273516171482 nsecs [in 10836334367 nsecs]
 #3: <f6005ebc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3234
 # expires at 1828817282936 nsecs [in 1566137445821 nsecs]
  .expires_next   : 262679973732 nsecs
  .hres_active    : 1
  .nr_events      : 14428
  .nohz_mode      : 2
  .idle_tick      : 262646640402 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294956090
  .idle_calls     : 38651
  .idle_sleeps    : 19330
  .idle_entrytime : 262678771896 nsecs
  .idle_waketime  : 262647484819 nsecs
  .idle_exittime  : 262647503816 nsecs
  .idle_sleeptime : 240455326644 nsecs
  .last_jiffies   : 4294956100
  .next_jiffies   : 4294956150
  .idle_expires   : 262843307049 nsecs
jiffies: 4294956100

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206389439961368821 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f6005ebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 262680807065 nsecs [in 969950 nsecs]
 #1: <f6005ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2916
 # expires at 273514296035 nsecs [in 10834458920 nsecs]
 #2: <f6005ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2915
 # expires at 273517313108 nsecs [in 10837475993 nsecs]
 #3: <f6005ebc>, hrtimer_wakeup, S:01, do_nanosleep, cron/3259
 # expires at 321521301743 nsecs [in 58841464628 nsecs]
  .expires_next   : 262680807065 nsecs
  .hres_active    : 1
  .nr_events      : 23844
  .nohz_mode      : 2
  .idle_tick      : 262627473737 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294956084
  .idle_calls     : 28612
  .idle_sleeps    : 9182
  .idle_entrytime : 262677540944 nsecs
  .idle_waketime  : 262593359854 nsecs
  .idle_exittime  : 262643330311 nsecs
  .idle_sleeptime : 246772797743 nsecs
  .last_jiffies   : 4294956100
  .next_jiffies   : 4294956150
  .idle_expires   : 262843307049 nsecs
jiffies: 4294956100


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     262679973732 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000001


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   806338790
 min_delta_ns:   1441
 mult:           44681954
 shift:          32
 mode:           1
 next_event:     262679973732 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   806338790
 min_delta_ns:   1441
 mult:           44681954
 shift:          32
 mode:           3
 next_event:     262680807065 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

-- /proc/timer_info: --
-- /proc/config.gz: --
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc6
# Mon Mar 24 20:59:30 2008
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
CONFIG_KTIME_SCALAR=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
# CONFIG_CGROUPS is not set
# CONFIG_GROUP_SCHED is not set
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
# CONFIG_RELAY is not set
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_ALL is not set
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
# CONFIG_MARKERS is not set
CONFIG_HAVE_OPROFILE=y
# CONFIG_KPROBES is not set
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBD=y
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_LSF=y
CONFIG_BLK_DEV_BSG=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_NUMAQ is not set
# CONFIG_X86_SUMMIT is not set
# CONFIG_X86_BIGSMP is not set
# CONFIG_X86_VISWS is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_ES7000 is not set
# CONFIG_X86_RDC321X is not set
# CONFIG_X86_VSMP is not set
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
CONFIG_MCORE2=y
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_GENERIC=y
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_GOOD_APIC=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=2
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_NONFATAL=y
# CONFIG_X86_MCE_P4THERMAL is not set
CONFIG_VM86=y
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
CONFIG_X86_CPUID=m
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_HIGHPTE is not set
# CONFIG_MATH_EMULATION is not set
CONFIG_MTRR=y
CONFIG_X86_PAT=y
CONFIG_EFI=y
# CONFIG_IRQBALANCE is not set
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
CONFIG_HZ_300=y
# CONFIG_HZ_1000 is not set
CONFIG_HZ=300
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x100000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x100000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management options
#
CONFIG_PM=y
# CONFIG_PM_LEGACY is not set
# CONFIG_PM_DEBUG is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=m
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=m
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=m
# CONFIG_ACPI_WMI is not set
# CONFIG_ACPI_ASUS is not set
# CONFIG_ACPI_TOSHIBA is not set
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=m
CONFIG_ACPI_SBS=m
# CONFIG_APM is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=m
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
# CONFIG_X86_POWERNOW_K6 is not set
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
# CONFIG_X86_GX_SUSPMOD is not set
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_SPEEDSTEP_ICH is not set
# CONFIG_X86_SPEEDSTEP_SMI is not set
# CONFIG_X86_P4_CLOCKMOD is not set
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
CONFIG_PCI_GOMMCONFIG=y
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOANY is not set
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_LEGACY is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
# CONFIG_MCA is not set
# CONFIG_SCx200 is not set
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=m
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=m
# CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
# CONFIG_HOTPLUG_PCI_SHPC is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

#
# Networking
#
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=m
# CONFIG_XFRM_SUB_POLICY is not set
# CONFIG_XFRM_MIGRATE is not set
# CONFIG_XFRM_STATISTICS is not set
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
# CONFIG_IP_MULTIPLE_TABLES is not set
# CONFIG_IP_ROUTE_MULTIPATH is not set
# CONFIG_IP_ROUTE_VERBOSE is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE is not set
# CONFIG_IP_MROUTE is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=y
# CONFIG_INET_LRO is not set
# CONFIG_INET_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IP_VS is not set
# CONFIG_IPV6 is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CT_ACCT is not set
# CONFIG_NF_CONNTRACK_MARK is not set
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CT_PROTO_SCTP is not set
# CONFIG_NF_CT_PROTO_UDPLITE is not set
# CONFIG_NF_CONNTRACK_AMANDA is not set
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_PPTP is not set
# CONFIG_NF_CONNTRACK_SANE is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CONNTRACK_TFTP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
# CONFIG_NETFILTER_XT_TARGET_MARK is not set
# CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
# CONFIG_NETFILTER_XT_MATCH_DCCP is not set
# CONFIG_NETFILTER_XT_MATCH_DSCP is not set
# CONFIG_NETFILTER_XT_MATCH_ESP is not set
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
# CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
# CONFIG_NETFILTER_XT_MATCH_MARK is not set
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
# CONFIG_NETFILTER_XT_MATCH_POLICY is not set
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_STATE is not set
# CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
# CONFIG_NETFILTER_XT_MATCH_STRING is not set
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
# CONFIG_NETFILTER_XT_MATCH_TIME is not set
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=m
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
CONFIG_IP_NF_IPTABLES=m
# CONFIG_IP_NF_MATCH_RECENT is not set
# CONFIG_IP_NF_MATCH_ECN is not set
# CONFIG_IP_NF_MATCH_AH is not set
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_MATCH_ADDRTYPE is not set
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
# CONFIG_IP_NF_TARGET_LOG is not set
# CONFIG_IP_NF_TARGET_ULOG is not set
# CONFIG_NF_NAT is not set
# CONFIG_IP_NF_MANGLE is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_ARPTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_BRIDGE is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_NET_SCHED is not set
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIUSB=m
# CONFIG_BT_HCIUSB_SCO is not set
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
# CONFIG_BT_HCIVHCI is not set
# CONFIG_AF_RXRPC is not set

#
# Wireless
#
CONFIG_CFG80211=m
# CONFIG_NL80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_DEFAULT_PID=y
# CONFIG_MAC80211_RC_DEFAULT_SIMPLE is not set
# CONFIG_MAC80211_RC_DEFAULT_NONE is not set

#
# Selecting 'y' for an algorithm will
#

#
# build the algorithm into mac80211.
#
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_RC_PID=y
# CONFIG_MAC80211_RC_SIMPLE is not set
# CONFIG_MAC80211_LEDS is not set
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
# CONFIG_MAC80211_DEBUG is not set
# CONFIG_IEEE80211 is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
# CONFIG_NET_9P is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
# CONFIG_ATA_OVER_ETH is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ACER_WMI is not set
# CONFIG_ASUS_LAPTOP is not set
# CONFIG_FUJITSU_LAPTOP is not set
# CONFIG_TC1100_WMI is not set
# CONFIG_MSI_LAPTOP is not set
# CONFIG_SONY_LAPTOP is not set
# CONFIG_THINKPAD_ACPI is not set
# CONFIG_INTEL_MENLOW is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
# CONFIG_SCSI_3W_9XXX is not set
# CONFIG_SCSI_ACARD is not set
# CONFIG_SCSI_AACRAID is not set
# CONFIG_SCSI_AIC7XXX is not set
# CONFIG_SCSI_AIC7XXX_OLD is not set
# CONFIG_SCSI_AIC79XX is not set
# CONFIG_SCSI_AIC94XX is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
# CONFIG_SCSI_ARCMSR is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
# CONFIG_MEGARAID_SAS is not set
# CONFIG_SCSI_HPTIOP is not set
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_MVSAS is not set
# CONFIG_SCSI_STEX is not set
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
# CONFIG_SCSI_QLA_FC is not set
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_DC390T is not set
# CONFIG_SCSI_NSP32 is not set
# CONFIG_SCSI_DEBUG is not set
# CONFIG_SCSI_SRP is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_PATA_ACPI is not set
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5535 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
CONFIG_BLK_DEV_DM=y
# CONFIG_DM_DEBUG is not set
CONFIG_DM_CRYPT=y
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_MIRROR=m
CONFIG_DM_ZERO=m
# CONFIG_DM_MULTIPATH is not set
CONFIG_DM_DELAY=m
CONFIG_DM_UEVENT=y
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_IEEE1394=m

#
# Subsystem Options
#
# CONFIG_IEEE1394_VERBOSEDEBUG is not set

#
# Controllers
#
# CONFIG_IEEE1394_PCILYNX is not set
CONFIG_IEEE1394_OHCI1394=m

#
# Protocols
#
# CONFIG_IEEE1394_VIDEO1394 is not set
# CONFIG_IEEE1394_SBP2 is not set
# CONFIG_IEEE1394_ETH1394_ROM_ENTRY is not set
# CONFIG_IEEE1394_ETH1394 is not set
# CONFIG_IEEE1394_DV1394 is not set
# CONFIG_IEEE1394_RAWIO is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
# CONFIG_NETDEVICES_MULTIQUEUE is not set
CONFIG_DUMMY=m
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=m
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_E1000E_ENABLED is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
# CONFIG_SK98LIN is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
# CONFIG_LIBERTAS is not set
# CONFIG_AIRO is not set
# CONFIG_HERMES is not set
# CONFIG_ATMEL is not set
# CONFIG_PRISM54 is not set
# CONFIG_USB_ZD1201 is not set
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ATH5K is not set
# CONFIG_IWL4965 is not set
# CONFIG_IWL3945 is not set
# CONFIG_HOSTAP is not set
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_ZD1211RW is not set
# CONFIG_RT2X00 is not set

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_WAN is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_PPP is not set
# CONFIG_SLIP is not set
# CONFIG_NET_FC is not set
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=m
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
CONFIG_MOUSE_APPLETOUCH=m
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_INPUT_JOYSTICK=y
# CONFIG_JOYSTICK_ANALOG is not set
# CONFIG_JOYSTICK_A3D is not set
# CONFIG_JOYSTICK_ADI is not set
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
# CONFIG_JOYSTICK_GRIP is not set
# CONFIG_JOYSTICK_GRIP_MP is not set
# CONFIG_JOYSTICK_GUILLEMOT is not set
# CONFIG_JOYSTICK_INTERACT is not set
# CONFIG_JOYSTICK_SIDEWINDER is not set
# CONFIG_JOYSTICK_TMDC is not set
# CONFIG_JOYSTICK_IFORCE is not set
# CONFIG_JOYSTICK_WARRIOR is not set
# CONFIG_JOYSTICK_MAGELLAN is not set
# CONFIG_JOYSTICK_SPACEORB is not set
# CONFIG_JOYSTICK_SPACEBALL is not set
# CONFIG_JOYSTICK_STINGER is not set
# CONFIG_JOYSTICK_TWIDJOY is not set
# CONFIG_JOYSTICK_JOYDUMP is not set
# CONFIG_JOYSTICK_XPAD is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_GTCO is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_UCB1400 is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_PCSPKR is not set
# CONFIG_INPUT_APANEL is not set
# CONFIG_INPUT_WISTRON_BTNS is not set
# CONFIG_INPUT_ATLAS_BTNS is not set
# CONFIG_INPUT_ATI_REMOTE is not set
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_UINPUT is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_JSM is not set
CONFIG_UNIX98_PTYS=y
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
CONFIG_HW_RANDOM_INTEL=m
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_GEODE is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_NVRAM is not set
# CONFIG_RTC is not set
# CONFIG_GEN_RTC is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_SONYPI is not set
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
# CONFIG_NSC_GPIO is not set
# CONFIG_CS5535_GPIO is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_RTC_IRQ=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCF=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
CONFIG_I2C_I801=m
# CONFIG_I2C_I810 is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_PROSAVAGE is not set
# CONFIG_I2C_SAVAGE4 is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_STUB is not set
# CONFIG_I2C_TINY_USB is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set
# CONFIG_I2C_VOODOO3 is not set

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_SENSORS_EEPROM=m
# CONFIG_SENSORS_PCF8574 is not set
# CONFIG_PCF8575 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_TPS65010 is not set
# CONFIG_SENSORS_MAX6875 is not set
# CONFIG_SENSORS_TSL2550 is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set

#
# SPI support
#
# CONFIG_SPI is not set
# CONFIG_SPI_MASTER is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7473 is not set
# CONFIG_SENSORS_K8TEMP is not set
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHER is not set
# CONFIG_SENSORS_FSCPOS is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
CONFIG_SENSORS_CORETEMP=m
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_HDAPS is not set
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
# CONFIG_ALIM1535_WDT is not set
# CONFIG_ALIM7101_WDT is not set
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
# CONFIG_IBMASR is not set
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
# CONFIG_HP_WATCHDOG is not set
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_SBC7240_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_W83627HF_WDT is not set
# CONFIG_W83697HF_WDT is not set
# CONFIG_W83877F_WDT is not set
# CONFIG_W83977F_WDT is not set
# CONFIG_MACHZ_WDT is not set
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
# CONFIG_PCIPCWATCHDOG is not set
# CONFIG_WDTPCI is not set

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
# CONFIG_SSB is not set

#
# Multifunction device drivers
#
# CONFIG_MFD_SM501 is not set

#
# Multimedia devices
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
# CONFIG_VIDEO_V4L1 is not set
# CONFIG_VIDEO_V4L1_COMPAT is not set
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_CX88 is not set
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
# CONFIG_VIDEO_PVRUSB2 is not set
# CONFIG_VIDEO_EM28XX is not set
# CONFIG_VIDEO_USBVISION is not set
# CONFIG_USB_ET61X251 is not set
# CONFIG_USB_SN9C102 is not set
# CONFIG_USB_ZC0301 is not set
# CONFIG_USB_ZR364XX is not set
# CONFIG_USB_STKWEBCAM is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CORE=m
# CONFIG_DVB_CORE_ATTACH is not set
# CONFIG_DVB_CAPTURE_DRIVERS is not set
# CONFIG_DAB is not set

#
# Graphics support
#
CONFIG_AGP=y
# CONFIG_AGP_ALI is not set
# CONFIG_AGP_ATI is not set
# CONFIG_AGP_AMD is not set
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=m
# CONFIG_AGP_NVIDIA is not set
# CONFIG_AGP_SIS is not set
# CONFIG_AGP_SWORKS is not set
# CONFIG_AGP_VIA is not set
# CONFIG_AGP_EFFICEON is not set
# CONFIG_DRM is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_CFB_FILLRECT is not set
# CONFIG_FB_CFB_COPYAREA is not set
# CONFIG_FB_CFB_IMAGEBLIT is not set
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_SYS_FOPS is not set
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_EFI is not set
# CONFIG_FB_IMAC is not set
# CONFIG_FB_HECUBA is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I810 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_CYBLA is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_VIRTUAL is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
# CONFIG_BACKLIGHT_PROGEAR is not set

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
CONFIG_FONTS=y
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_FONT_6x11 is not set
# CONFIG_FONT_7x14 is not set
# CONFIG_FONT_PEARL_8x8 is not set
# CONFIG_FONT_ACORN_8x8 is not set
# CONFIG_FONT_MINI_4x6 is not set
# CONFIG_FONT_SUN8x16 is not set
# CONFIG_FONT_SUN12x22 is not set
# CONFIG_FONT_10x18 is not set
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y

#
# Sound
#
CONFIG_SOUND=m

#
# Advanced Linux Sound Architecture
#
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
# CONFIG_SND_SEQUENCER_OSS is not set
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set

#
# Generic devices
#
# CONFIG_SND_DUMMY is not set
# CONFIG_SND_VIRMIDI is not set
# CONFIG_SND_MTPAV is not set
# CONFIG_SND_SERIAL_U16550 is not set
# CONFIG_SND_MPU401 is not set

#
# PCI devices
#
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
# CONFIG_SND_ALI5451 is not set
# CONFIG_SND_ATIIXP is not set
# CONFIG_SND_ATIIXP_MODEM is not set
# CONFIG_SND_AU8810 is not set
# CONFIG_SND_AU8820 is not set
# CONFIG_SND_AU8830 is not set
# CONFIG_SND_AZT3328 is not set
# CONFIG_SND_BT87X is not set
# CONFIG_SND_CA0106 is not set
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
# CONFIG_SND_CS4281 is not set
# CONFIG_SND_CS46XX is not set
# CONFIG_SND_CS5530 is not set
# CONFIG_SND_CS5535AUDIO is not set
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
# CONFIG_SND_DARLA24 is not set
# CONFIG_SND_GINA24 is not set
# CONFIG_SND_LAYLA24 is not set
# CONFIG_SND_MONA is not set
# CONFIG_SND_MIA is not set
# CONFIG_SND_ECHO3G is not set
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
# CONFIG_SND_INDIGODJ is not set
# CONFIG_SND_EMU10K1 is not set
# CONFIG_SND_EMU10K1X is not set
# CONFIG_SND_ENS1370 is not set
# CONFIG_SND_ENS1371 is not set
# CONFIG_SND_ES1938 is not set
# CONFIG_SND_ES1968 is not set
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=m
# CONFIG_SND_HDA_HWDEP is not set
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=3
# CONFIG_SND_HDSP is not set
# CONFIG_SND_HDSPM is not set
# CONFIG_SND_HIFIER is not set
# CONFIG_SND_ICE1712 is not set
# CONFIG_SND_ICE1724 is not set
# CONFIG_SND_INTEL8X0 is not set
# CONFIG_SND_INTEL8X0M is not set
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_MAESTRO3 is not set
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
# CONFIG_SND_PCXHR is not set
# CONFIG_SND_RIPTIDE is not set
# CONFIG_SND_RME32 is not set
# CONFIG_SND_RME96 is not set
# CONFIG_SND_RME9652 is not set
# CONFIG_SND_SIS7019 is not set
# CONFIG_SND_SONICVIBES is not set
# CONFIG_SND_TRIDENT is not set
# CONFIG_SND_VIA82XX is not set
# CONFIG_SND_VIA82XX_MODEM is not set
# CONFIG_SND_VIRTUOSO is not set
# CONFIG_SND_VX222 is not set
# CONFIG_SND_YMFPCI is not set

#
# USB devices
#
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set

#
# System on Chip audio support
#
# CONFIG_SND_SOC is not set

#
# SoC Audio support for SuperH
#

#
# ALSA SoC audio for Freescale SOCs
#

#
# Open Sound System
#
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
# CONFIG_HID_DEBUG is not set
# CONFIG_HIDRAW is not set

#
# USB Input Devices
#
CONFIG_USB_HID=m
CONFIG_USB_HIDINPUT_POWERBOOK=y
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
# CONFIG_USB_KBD is not set
# CONFIG_USB_MOUSE is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_SUSPEND=y
# CONFIG_USB_PERSIST is not set
# CONFIG_USB_OTG is not set

#
# USB Host Controller Drivers
#
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=m
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set
# CONFIG_USB_MON is not set

#
# USB port drivers
#
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_AUERSWALD is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_BERRY_CHARGE is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_PHIDGET is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_GADGET is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
# CONFIG_LEDS_CLEVO_MAIL is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
# CONFIG_INFINIBAND is not set
# CONFIG_EDAC is not set
CONFIG_RTC_LIB=m
CONFIG_RTC_CLASS=m

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
# CONFIG_RTC_INTF_PROC is not set
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_S35390A is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set

#
# Userspace I/O
#
CONFIG_UIO=m
CONFIG_UIO_CIF=m

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_EFI_VARS=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y

#
# File systems
#
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4DEV_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_XFS_FS=m
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_SECURITY is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=m
CONFIG_QUOTACTL=y
# CONFIG_AUTOFS_FS is not set
# CONFIG_AUTOFS4_FS is not set
CONFIG_FUSE_FS=m

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=m
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_ROMFS_FS is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=m
CONFIG_UFS_FS_WRITE=y
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
# CONFIG_NFS_FS is not set
# CONFIG_NFSD is not set
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
# CONFIG_CIFS_WEAK_PW_HASH is not set
# CONFIG_CIFS_XATTR is not set
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_EXPERIMENTAL is not set
# CONFIG_NCP_FS is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=m
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
# CONFIG_DLM_DEBUG is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
# CONFIG_DETECT_SOFTLOCKUP is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
CONFIG_TIMER_STATS=y
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_SPINLOCK_SLEEP is not set
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
# CONFIG_DEBUG_KOBJECT is not set
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_FRAME_POINTER is not set
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_FAULT_INJECTION is not set
# CONFIG_LATENCYTOP is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_SAMPLES is not set
# CONFIG_KGDB is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_NONPROMISC_DEVMEM=y
CONFIG_EARLY_PRINTK=y
# CONFIG_DEBUG_STACKOVERFLOW is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
# CONFIG_DEBUG_NX_TEST is not set
CONFIG_4KSTACKS=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_DOUBLEFAULT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITY_FILE_CAPABILITIES is not set
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_BLKCIPHER=y
# CONFIG_CRYPTO_SEQIV is not set
CONFIG_CRYPTO_HASH=m
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_HMAC=m
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_NULL is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
# CONFIG_CRYPTO_SHA512 is not set
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_TGR192 is not set
# CONFIG_CRYPTO_GF128MUL is not set
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_PCBC=m
# CONFIG_CRYPTO_LRW is not set
# CONFIG_CRYPTO_XTS is not set
# CONFIG_CRYPTO_CTR is not set
# CONFIG_CRYPTO_GCM is not set
# CONFIG_CRYPTO_CCM is not set
CONFIG_CRYPTO_CRYPTD=m
# CONFIG_CRYPTO_DES is not set
CONFIG_CRYPTO_FCRYPT=m
# CONFIG_CRYPTO_BLOWFISH is not set
# CONFIG_CRYPTO_TWOFISH is not set
# CONFIG_CRYPTO_TWOFISH_586 is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_586 is not set
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_KHAZAD is not set
# CONFIG_CRYPTO_ANUBIS is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SALSA20 is not set
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_DEFLATE is not set
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_CRC32C is not set
CONFIG_CRYPTO_CAMELLIA=m
# CONFIG_CRYPTO_TEST is not set
# CONFIG_CRYPTO_AUTHENC is not set
# CONFIG_CRYPTO_LZO is not set
CONFIG_CRYPTO_HW=y
# CONFIG_CRYPTO_DEV_PADLOCK is not set
# CONFIG_CRYPTO_DEV_GEODE is not set
# CONFIG_CRYPTO_DEV_HIFN_795X is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
# CONFIG_KVM_AMD is not set
# CONFIG_LGUEST is not set
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
-- current kernel config: --
-- filesystems: --
rootfs on / type rootfs (rw)
/dev/root on / type ext3 (rw,noatime,errors=continue,commit=90,data=ordered)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec)
udev on /dev type tmpfs (rw,nosuid,size=10240k,mode=755)
none on /dev/pts type devpts (rw,nosuid,noexec,gid=5,mode=620)
none on /dev/shm type tmpfs (rw)
none on /lib/rc/init.d type tmpfs (rw,nosuid,nodev,noexec,size=1024k,mode=755)
/dev/sda1 on /boot type vfat (rw)
/dev/mapper/crypt-root on /mnt/crypt-root type ext3 (rw,noatime,commit=90)
/mnt/crypt-root/usr on /usr type none (rw,bind)
/mnt/crypt-root/opt on /opt type none (rw,bind)
/mnt/crypt-root/var on /var type none (rw,bind)
/mnt/crypt-root/home on /home type none (rw,bind)
/mnt/crypt-root/tmp on /tmp type none (rw,bind)
usbfs on /proc/bus/usb type usbfs (rw,noexec,nosuid,devmode=0664,devgid=85)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,noexec,nosuid,nodev)
debugfs on /sys/kernel/debug type debugfs (rw,noexec,nosuid,nodev)
none on /sys/fs/fuse/connections type fusectl (rw)
-- uptime: --
 21:15:02 up 4 min,  2 users,  load average: 0.10, 0.13, 0.06
-- uname: --
Linux hotzenplotz 2.6.25-rc6-x86-latest.git #5 SMP Mon Mar 24 21:06:47 CET 2008 i686 Genuine Intel(R) CPU T2400 @ 1.83GHz GenuineIntel GNU/Linux
-- /sys/devices/system: --
/sys/devices/system/cpu/sched_mc_power_savings:
1
/sys/devices/system/cpu/cpuidle/current_driver:
acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:
menu
/sys/devices/system/cpu/cpu0/crash_notes:
37c600c0
/sys/devices/system/cpu/cpu0/cache/index0/type:
Data
/sys/devices/system/cpu/cpu0/cache/index0/level:
1
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size:
64
/sys/devices/system/cpu/cpu0/cache/index0/physical_line_partition:
1
/sys/devices/system/cpu/cpu0/cache/index0/ways_of_associativity:
8
/sys/devices/system/cpu/cpu0/cache/index0/number_of_sets:
64
/sys/devices/system/cpu/cpu0/cache/index0/size:
32K
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_map:
1
/sys/devices/system/cpu/cpu0/cache/index1/type:
Instruction
/sys/devices/system/cpu/cpu0/cache/index1/level:
1
/sys/devices/system/cpu/cpu0/cache/index1/coherency_line_size:
64
/sys/devices/system/cpu/cpu0/cache/index1/physical_line_partition:
1
/sys/devices/system/cpu/cpu0/cache/index1/ways_of_associativity:
8
/sys/devices/system/cpu/cpu0/cache/index1/number_of_sets:
64
/sys/devices/system/cpu/cpu0/cache/index1/size:
32K
/sys/devices/system/cpu/cpu0/cache/index1/shared_cpu_map:
1
/sys/devices/system/cpu/cpu0/cache/index2/type:
Unified
/sys/devices/system/cpu/cpu0/cache/index2/level:
2
/sys/devices/system/cpu/cpu0/cache/index2/coherency_line_size:
64
/sys/devices/system/cpu/cpu0/cache/index2/physical_line_partition:
1
/sys/devices/system/cpu/cpu0/cache/index2/ways_of_associativity:
8
/sys/devices/system/cpu/cpu0/cache/index2/number_of_sets:
4096
/sys/devices/system/cpu/cpu0/cache/index2/size:
2048K
/sys/devices/system/cpu/cpu0/cache/index2/shared_cpu_map:
3
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:
C0
/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:
CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:
0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:
4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:
2
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:
9084
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:
C1
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:
ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:
1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:
1000
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:
0
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:
0
/sys/devices/system/cpu/cpu0/cpuidle/state2/name:
C2
/sys/devices/system/cpu/cpu0/cpuidle/state2/desc:
ACPI FFH INTEL MWAIT 0x10
/sys/devices/system/cpu/cpu0/cpuidle/state2/latency:
1
/sys/devices/system/cpu/cpu0/cpuidle/state2/power:
500
/sys/devices/system/cpu/cpu0/cpuidle/state2/usage:
1090
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:
95509
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:
31333
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:
237031818
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:
1000000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:
1833000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:
1000000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:
1833000
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:
0
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:
ondemand
/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:
acpi-cpufreq
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:
powersave conservative ondemand performance 
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:
<unsupported>
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:
1833000 1667000 1500000 1333000 1000000 
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:
1000000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:
1000000
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_max:
33333000
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate_min:
33333
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/sampling_rate:
66666
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/up_threshold:
80
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load:
0
/sys/devices/system/cpu/cpu0/cpufreq/ondemand/powersave_bias:
0
/sys/devices/system/cpu/cpu1/online:
1
/sys/devices/system/cpu/cpu1/crash_notes:
37c60180
/sys/devices/system/cpu/cpu1/cache/index0/type:
Data
/sys/devices/system/cpu/cpu1/cache/index0/level:
1
/sys/devices/system/cpu/cpu1/cache/index0/coherency_line_size:
64
/sys/devices/system/cpu/cpu1/cache/index0/physical_line_partition:
1
/sys/devices/system/cpu/cpu1/cache/index0/ways_of_associativity:
8
/sys/devices/system/cpu/cpu1/cache/index0/number_of_sets:
64
/sys/devices/system/cpu/cpu1/cache/index0/size:
32K
/sys/devices/system/cpu/cpu1/cache/index0/shared_cpu_map:
2
/sys/devices/system/cpu/cpu1/cache/index1/type:
Instruction
/sys/devices/system/cpu/cpu1/cache/index1/level:
1
/sys/devices/system/cpu/cpu1/cache/index1/coherency_line_size:
64
/sys/devices/system/cpu/cpu1/cache/index1/physical_line_partition:
1
/sys/devices/system/cpu/cpu1/cache/index1/ways_of_associativity:
8
/sys/devices/system/cpu/cpu1/cache/index1/number_of_sets:
64
/sys/devices/system/cpu/cpu1/cache/index1/size:
32K
/sys/devices/system/cpu/cpu1/cache/index1/shared_cpu_map:
2
/sys/devices/system/cpu/cpu1/cache/index2/type:
Unified
/sys/devices/system/cpu/cpu1/cache/index2/level:
2
/sys/devices/system/cpu/cpu1/cache/index2/coherency_line_size:
64
/sys/devices/system/cpu/cpu1/cache/index2/physical_line_partition:
1
/sys/devices/system/cpu/cpu1/cache/index2/ways_of_associativity:
8
/sys/devices/system/cpu/cpu1/cache/index2/number_of_sets:
4096
/sys/devices/system/cpu/cpu1/cache/index2/size:
2048K
/sys/devices/system/cpu/cpu1/cache/index2/shared_cpu_map:
3
/sys/devices/system/cpu/cpu1/cpuidle/state0/name:
C0
/sys/devices/system/cpu/cpu1/cpuidle/state0/desc:
CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu1/cpuidle/state0/latency:
0
/sys/devices/system/cpu/cpu1/cpuidle/state0/power:
4294967295
/sys/devices/system/cpu/cpu1/cpuidle/state0/usage:
4
/sys/devices/system/cpu/cpu1/cpuidle/state0/time:
159
/sys/devices/system/cpu/cpu1/cpuidle/state1/name:
C1
/sys/devices/system/cpu/cpu1/cpuidle/state1/desc:
ACPI FFH INTEL MWAIT 0x0
/sys/devices/system/cpu/cpu1/cpuidle/state1/latency:
1
/sys/devices/system/cpu/cpu1/cpuidle/state1/power:
1000
/sys/devices/system/cpu/cpu1/cpuidle/state1/usage:
0
/sys/devices/system/cpu/cpu1/cpuidle/state1/time:
0
/sys/devices/system/cpu/cpu1/cpuidle/state2/name:
C2
/sys/devices/system/cpu/cpu1/cpuidle/state2/desc:
ACPI FFH INTEL MWAIT 0x10
/sys/devices/system/cpu/cpu1/cpuidle/state2/latency:
1
/sys/devices/system/cpu/cpu1/cpuidle/state2/power:
500
/sys/devices/system/cpu/cpu1/cpuidle/state2/usage:
3704
/sys/devices/system/cpu/cpu1/cpuidle/state2/time:
79465
/sys/devices/system/cpu/cpu1/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu1/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu1/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu1/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu1/cpuidle/state3/usage:
31809
/sys/devices/system/cpu/cpu1/cpuidle/state3/time:
242857993
/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_min_freq:
1000000
/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_max_freq:
1833000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_min_freq:
1000000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_max_freq:
1833000
/sys/devices/system/cpu/cpu1/cpufreq/affected_cpus:
1
/sys/devices/system/cpu/cpu1/cpufreq/scaling_governor:
ondemand
/sys/devices/system/cpu/cpu1/cpufreq/scaling_driver:
acpi-cpufreq
/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_governors:
powersave conservative ondemand performance 
/sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed:
<unsupported>
/sys/devices/system/cpu/cpu1/cpufreq/scaling_available_frequencies:
1833000 1667000 1500000 1333000 1000000 
/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq:
1000000
/sys/devices/system/cpu/cpu1/cpufreq/scaling_cur_freq:
1000000
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate_max:
33333000
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate_min:
33333
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/sampling_rate:
66666
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/up_threshold:
80
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/ignore_nice_load:
0
/sys/devices/system/cpu/cpu1/cpufreq/ondemand/powersave_bias:
0
/sys/devices/system/clocksource/clocksource0/current_clocksource:
hpet
/sys/devices/system/clocksource/clocksource0/available_clocksource:
hpet acpi_pm jiffies tsc 
-- top: --
top - 21:15:03 up 4 min,  2 users,  load average: 0.10, 0.13, 0.06
Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s):  4.7%us,  1.6%sy,  0.0%ni, 85.5%id,  8.2%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   189244k used,  1871216k free,    10188k buffers
Swap:  1214416k total,        0k used,  1214416k free,    87016k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3363 thomas    20   0 28292 8616 7476 S    2  0.4   0:00.08 klauncher          
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   46 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   47 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   49 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   50 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/0]         
  130 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/1]         
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  136 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  158 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  182 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  226 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  845 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  847 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  852 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  854 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  875 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  881 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  951 root      16  -4  2612 1448  468 S    0  0.1   0:00.35 /sbin/udevd --daemo
 1909 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1911 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2274 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2278 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2300 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2431 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2440 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2491 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2493 root      15  -5     0    0    0 S    0  0.0   0:00.09 [kcryptd_io]       
 2496 root      15  -5     0    0    0 S    0  0.0   0:01.14 [kcryptd]          
 2547 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2653 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2824 root      20   0  1916  584  460 S    0  0.0   0:00.02 metalog [MASTER]   
 2825 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2834 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2844 messageb  20   0  2396  944  672 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 2913 root      20   0  106m  980  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2932 haldaemo  20   0  4776 2948 2280 S    0  0.1   0:00.47 /usr/sbin/hald --us
 2933 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 2979 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2981 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2984 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2985 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 2990 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3003 root      20   0  3144 1008  864 S    0  0.0   0:00.00 hald-addon-storage:
 3044 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3054 root      20   0  166m  32m 3608 S    0  1.6   0:12.39 /usr/bin/X -br -nov
 3101 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3109 root      20   0  7040 2288 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3162 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3216 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3234 root      20   0  2996  540  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3248 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3259 root      20   0  1948  392  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3268 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3269 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3270 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3271 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3272 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3275 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3296 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3297 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3305 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.01 /bin/sh /usr/kde/4.
 3356 thomas    20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3357 thomas    20   0  2188  872  640 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 3362 thomas    20   0 27476 4616 3556 S    0  0.2   0:00.01 kdeinit4: kdeinit4 
 3365 thomas    20   0 67804  17m  13m S    0  0.9   0:00.56 kded4              
 3367 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3372 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3374 thomas    20   0 59932  11m 9.9m S    0  0.6   0:00.11 ksmserver          
 3379 thomas    20   0 47552  13m  10m S    0  0.7   0:00.46 kwin -session 1013c
 3382 thomas    20   0 71724  20m  15m S    0  1.0   0:01.21 /usr/kde/4.0/bin/pl
 3383 thomas    20   0 45336 7916 6600 S    0  0.4   0:00.48 /usr/kde/4.0/bin/kn
 3385 thomas    20   0 27864 4312 3100 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3387 thomas    20   0  100m  16m  13m S    0  0.8   0:00.99 /usr/kde/4.0/bin/kr
 3396 thomas    20   0 45268 7912 6588 S    0  0.4   0:00.04 /usr/kde/4.0/bin/ka
 3397 thomas    20   0 54060  12m 9.8m S    0  0.6   0:00.19 kmix -session 1013c
 3407 thomas    20   0 58928  17m  10m S    0  0.8   0:01.97 konsole            
 3408 thomas    20   0  3232 1612 1284 S    0  0.1   0:00.00 /bin/bash          
 3414 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3417 root      20   0  2976 1604 1292 S    0  0.1   0:00.02 bash               
 3441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 3487 root      20   0  2976  996  656 S    0  0.0   0:00.05 bash               
 3728 root      20   0  2044  908  692 R    0  0.0   0:00.00 top -c -b -d 1 -n 5


top - 21:15:04 up 4 min,  2 users,  load average: 0.10, 0.13, 0.06
Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   189300k used,  1871160k free,    10188k buffers
Swap:  1214416k total,        0k used,  1214416k free,    86992k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3728 root      20   0  2052 1000  772 R    1  0.0   0:00.01 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   46 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   47 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   49 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   50 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/0]         
  130 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/1]         
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  136 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  158 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  182 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  226 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  845 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  847 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  852 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  854 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  875 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  881 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  951 root      16  -4  2612 1448  468 S    0  0.1   0:00.35 /sbin/udevd --daemo
 1909 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1911 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2274 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2278 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2300 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2431 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2440 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2491 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2493 root      15  -5     0    0    0 S    0  0.0   0:00.09 [kcryptd_io]       
 2496 root      15  -5     0    0    0 S    0  0.0   0:01.14 [kcryptd]          
 2547 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2653 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2824 root      20   0  1916  584  460 S    0  0.0   0:00.02 metalog [MASTER]   
 2825 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2834 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2844 messageb  20   0  2396  944  672 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 2913 root      20   0  106m  980  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2932 haldaemo  20   0  4776 2948 2280 S    0  0.1   0:00.47 /usr/sbin/hald --us
 2933 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 2979 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2981 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2984 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2985 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 2990 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3003 root      20   0  3144 1008  864 S    0  0.0   0:00.00 hald-addon-storage:
 3044 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3054 root      20   0  166m  32m 3608 S    0  1.6   0:12.39 /usr/bin/X -br -nov
 3101 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3109 root      20   0  7040 2288 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3162 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3216 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3234 root      20   0  2996  540  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3248 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3259 root      20   0  1948  392  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3268 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3269 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3270 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3271 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3272 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3275 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3296 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3297 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3305 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.01 /bin/sh /usr/kde/4.
 3356 thomas    20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3357 thomas    20   0  2188  872  640 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 3362 thomas    20   0 27476 4616 3556 S    0  0.2   0:00.01 kdeinit4: kdeinit4 
 3363 thomas    20   0 28292 8616 7476 S    0  0.4   0:00.08 klauncher          
 3365 thomas    20   0 67804  17m  13m S    0  0.9   0:00.56 kded4              
 3367 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3372 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3374 thomas    20   0 59932  11m 9.9m S    0  0.6   0:00.11 ksmserver          
 3379 thomas    20   0 47552  13m  10m S    0  0.7   0:00.46 kwin -session 1013c
 3382 thomas    20   0 71724  20m  15m S    0  1.0   0:01.21 /usr/kde/4.0/bin/pl
 3383 thomas    20   0 45336 7916 6600 S    0  0.4   0:00.48 /usr/kde/4.0/bin/kn
 3385 thomas    20   0 27864 4312 3100 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3387 thomas    20   0  100m  16m  13m S    0  0.8   0:00.99 /usr/kde/4.0/bin/kr
 3396 thomas    20   0 45268 7912 6588 S    0  0.4   0:00.04 /usr/kde/4.0/bin/ka
 3397 thomas    20   0 54060  12m 9.8m S    0  0.6   0:00.19 kmix -session 1013c
 3407 thomas    20   0 58928  17m  10m S    0  0.8   0:01.97 konsole            
 3408 thomas    20   0  3232 1612 1284 S    0  0.1   0:00.00 /bin/bash          
 3414 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3417 root      20   0  2976 1604 1292 S    0  0.1   0:00.02 bash               
 3441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 3487 root      20   0  2976  996  656 S    0  0.0   0:00.05 bash               


top - 21:15:05 up 4 min,  2 users,  load average: 0.09, 0.13, 0.06
Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   189300k used,  1871160k free,    10188k buffers
Swap:  1214416k total,        0k used,  1214416k free,    87000k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3728 root      20   0  2052 1000  772 R    1  0.0   0:00.02 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   46 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   47 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   49 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   50 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/0]         
  130 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/1]         
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  136 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  158 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  182 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  226 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  845 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  847 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  852 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  854 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  875 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  881 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  951 root      16  -4  2612 1448  468 S    0  0.1   0:00.35 /sbin/udevd --daemo
 1909 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1911 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2274 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2278 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2300 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2431 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2440 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2491 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2493 root      15  -5     0    0    0 S    0  0.0   0:00.09 [kcryptd_io]       
 2496 root      15  -5     0    0    0 S    0  0.0   0:01.14 [kcryptd]          
 2547 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2653 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2824 root      20   0  1916  584  460 S    0  0.0   0:00.02 metalog [MASTER]   
 2825 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2834 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2844 messageb  20   0  2396  944  672 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 2913 root      20   0  106m  980  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2932 haldaemo  20   0  4776 2948 2280 S    0  0.1   0:00.47 /usr/sbin/hald --us
 2933 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 2979 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2981 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2984 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2985 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 2990 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3003 root      20   0  3144 1008  864 S    0  0.0   0:00.00 hald-addon-storage:
 3044 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3054 root      20   0  166m  32m 3608 S    0  1.6   0:12.39 /usr/bin/X -br -nov
 3101 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3109 root      20   0  7040 2288 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3162 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3216 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3234 root      20   0  2996  540  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3248 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3259 root      20   0  1948  392  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3268 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3269 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3270 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3271 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3272 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3275 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3296 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3297 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3305 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.01 /bin/sh /usr/kde/4.
 3356 thomas    20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3357 thomas    20   0  2188  872  640 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 3362 thomas    20   0 27476 4616 3556 S    0  0.2   0:00.01 kdeinit4: kdeinit4 
 3363 thomas    20   0 28292 8616 7476 S    0  0.4   0:00.08 klauncher          
 3365 thomas    20   0 67804  17m  13m S    0  0.9   0:00.56 kded4              
 3367 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3372 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3374 thomas    20   0 59932  11m 9.9m S    0  0.6   0:00.11 ksmserver          
 3379 thomas    20   0 47552  13m  10m S    0  0.7   0:00.46 kwin -session 1013c
 3382 thomas    20   0 71724  20m  15m S    0  1.0   0:01.21 /usr/kde/4.0/bin/pl
 3383 thomas    20   0 45336 7916 6600 S    0  0.4   0:00.48 /usr/kde/4.0/bin/kn
 3385 thomas    20   0 27864 4312 3100 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3387 thomas    20   0  100m  16m  13m S    0  0.8   0:00.99 /usr/kde/4.0/bin/kr
 3396 thomas    20   0 45268 7912 6588 S    0  0.4   0:00.04 /usr/kde/4.0/bin/ka
 3397 thomas    20   0 54060  12m 9.8m S    0  0.6   0:00.19 kmix -session 1013c
 3407 thomas    20   0 58928  17m  10m S    0  0.8   0:01.97 konsole            
 3408 thomas    20   0  3232 1612 1284 S    0  0.1   0:00.00 /bin/bash          
 3414 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3417 root      20   0  2976 1604 1292 S    0  0.1   0:00.02 bash               
 3441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 3487 root      20   0  2976  996  656 S    0  0.0   0:00.05 bash               


top - 21:15:06 up 4 min,  2 users,  load average: 0.09, 0.13, 0.06
Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   189300k used,  1871160k free,    10188k buffers
Swap:  1214416k total,        0k used,  1214416k free,    87008k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3728 root      20   0  2052 1000  772 R    2  0.0   0:00.04 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   46 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   47 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   49 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   50 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/0]         
  130 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/1]         
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  136 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  158 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  182 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  226 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  845 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  847 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  852 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  854 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  875 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  881 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  951 root      16  -4  2612 1448  468 S    0  0.1   0:00.35 /sbin/udevd --daemo
 1909 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1911 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2274 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2278 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2300 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2431 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2440 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2491 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2493 root      15  -5     0    0    0 S    0  0.0   0:00.09 [kcryptd_io]       
 2496 root      15  -5     0    0    0 S    0  0.0   0:01.14 [kcryptd]          
 2547 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2653 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2824 root      20   0  1916  584  460 S    0  0.0   0:00.02 metalog [MASTER]   
 2825 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2834 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2844 messageb  20   0  2396  944  672 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 2913 root      20   0  106m  980  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2932 haldaemo  20   0  4776 2948 2280 S    0  0.1   0:00.47 /usr/sbin/hald --us
 2933 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 2979 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2981 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2984 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2985 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 2990 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3003 root      20   0  3144 1008  864 S    0  0.0   0:00.00 hald-addon-storage:
 3044 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3054 root      20   0  166m  32m 3608 S    0  1.6   0:12.39 /usr/bin/X -br -nov
 3101 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3109 root      20   0  7040 2288 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3162 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3216 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3234 root      20   0  2996  540  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3248 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3259 root      20   0  1948  392  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3268 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3269 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3270 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3271 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3272 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3275 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3296 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3297 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3305 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.01 /bin/sh /usr/kde/4.
 3356 thomas    20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3357 thomas    20   0  2188  872  640 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 3362 thomas    20   0 27476 4616 3556 S    0  0.2   0:00.01 kdeinit4: kdeinit4 
 3363 thomas    20   0 28292 8616 7476 S    0  0.4   0:00.08 klauncher          
 3365 thomas    20   0 67804  17m  13m S    0  0.9   0:00.56 kded4              
 3367 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3372 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3374 thomas    20   0 59932  11m 9.9m S    0  0.6   0:00.11 ksmserver          
 3379 thomas    20   0 47552  13m  10m S    0  0.7   0:00.46 kwin -session 1013c
 3382 thomas    20   0 71724  20m  15m S    0  1.0   0:01.21 /usr/kde/4.0/bin/pl
 3383 thomas    20   0 45336 7916 6600 S    0  0.4   0:00.48 /usr/kde/4.0/bin/kn
 3385 thomas    20   0 27864 4312 3100 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3387 thomas    20   0  100m  16m  13m S    0  0.8   0:00.99 /usr/kde/4.0/bin/kr
 3396 thomas    20   0 45268 7912 6588 S    0  0.4   0:00.04 /usr/kde/4.0/bin/ka
 3397 thomas    20   0 54060  12m 9.8m S    0  0.6   0:00.19 kmix -session 1013c
 3407 thomas    20   0 58928  17m  10m S    0  0.8   0:01.97 konsole            
 3408 thomas    20   0  3232 1612 1284 S    0  0.1   0:00.00 /bin/bash          
 3414 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3417 root      20   0  2976 1604 1292 S    0  0.1   0:00.02 bash               
 3441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 3487 root      20   0  2976  996  656 S    0  0.0   0:00.05 bash               


top - 21:15:07 up 4 min,  2 users,  load average: 0.09, 0.13, 0.06
Tasks:  99 total,   1 running,  98 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   189300k used,  1871160k free,    10188k buffers
Swap:  1214416k total,        0k used,  1214416k free,    87016k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3728 root      20   0  2052 1000  772 R    1  0.0   0:00.05 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   46 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   47 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   49 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   50 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/0]         
  130 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue/1]         
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  136 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  158 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  182 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  226 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  845 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  847 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  852 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  854 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  875 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  881 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  951 root      16  -4  2612 1448  468 S    0  0.1   0:00.35 /sbin/udevd --daemo
 1909 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1911 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2274 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2278 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2300 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2431 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2440 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2491 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2493 root      15  -5     0    0    0 S    0  0.0   0:00.09 [kcryptd_io]       
 2496 root      15  -5     0    0    0 S    0  0.0   0:01.14 [kcryptd]          
 2547 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2653 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2824 root      20   0  1916  584  460 S    0  0.0   0:00.02 metalog [MASTER]   
 2825 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2834 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2844 messageb  20   0  2396  944  672 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 2913 root      20   0  106m  980  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2932 haldaemo  20   0  4776 2948 2280 S    0  0.1   0:00.47 /usr/sbin/hald --us
 2933 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 2979 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2981 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2984 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2985 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 2990 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3003 root      20   0  3144 1008  864 S    0  0.0   0:00.00 hald-addon-storage:
 3044 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3054 root      20   0  166m  32m 3608 S    0  1.6   0:12.39 /usr/bin/X -br -nov
 3101 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3109 root      20   0  7040 2288 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3162 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3216 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3234 root      20   0  2996  540  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3248 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3259 root      20   0  1948  392  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3268 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3269 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3270 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3271 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3272 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3275 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3296 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3297 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3305 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.01 /bin/sh /usr/kde/4.
 3356 thomas    20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3357 thomas    20   0  2188  872  640 S    0  0.0   0:00.10 /usr/bin/dbus-daemo
 3362 thomas    20   0 27476 4616 3556 S    0  0.2   0:00.01 kdeinit4: kdeinit4 
 3363 thomas    20   0 28292 8616 7476 S    0  0.4   0:00.08 klauncher          
 3365 thomas    20   0 67804  17m  13m S    0  0.9   0:00.56 kded4              
 3367 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3372 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3374 thomas    20   0 59932  11m 9.9m S    0  0.6   0:00.11 ksmserver          
 3379 thomas    20   0 47552  13m  10m S    0  0.7   0:00.46 kwin -session 1013c
 3382 thomas    20   0 71724  20m  15m S    0  1.0   0:01.21 /usr/kde/4.0/bin/pl
 3383 thomas    20   0 45336 7916 6600 S    0  0.4   0:00.48 /usr/kde/4.0/bin/kn
 3385 thomas    20   0 27864 4312 3100 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3387 thomas    20   0  100m  16m  13m S    0  0.8   0:00.99 /usr/kde/4.0/bin/kr
 3396 thomas    20   0 45268 7912 6588 S    0  0.4   0:00.04 /usr/kde/4.0/bin/ka
 3397 thomas    20   0 54060  12m 9.8m S    0  0.6   0:00.19 kmix -session 1013c
 3407 thomas    20   0 58928  17m  10m S    0  0.8   0:01.97 konsole            
 3408 thomas    20   0  3232 1612 1284 S    0  0.1   0:00.00 /bin/bash          
 3414 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3417 root      20   0  2976 1604 1292 S    0  0.1   0:00.02 bash               
 3441 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 3487 root      20   0  2976  996  656 S    0  0.0   0:00.05 bash               

-- vmstat: --
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1871160  10192  87012    0    0   176     4   66  343  5  2 86  8
 0  0      0 1871160  10192  87044    0    0     0     0   13   31  0  0 100  0
 0  0      0 1871160  10192  87044    0    0     0     0   23   52  0  0 100  0
 0  0      0 1871160  10192  87044    0    0     0     0   14   36  0  0 100  0
 0  0      0 1871160  10192  87044    0    0     0     0   22   50  0  0 100  0
-- sched_debug #0: --
Mo 24. Mär 21:15:11 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 271671.620568 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 100620
  .nr_load_updates               : 14387
  .nr_uninterruptible            : 4294967176
  .jiffies                       : 4294958798
  .next_balance                  : 4294.958800
  .curr->pid                     : 0
  .clock                         : 268557.099349
  .idle_clock                    : 245492.509851
  .prev_clock_raw                : 167428.403850
  .clock_warps                   : 0
  .clock_overflows               : 96971
  .clock_underflows              : 4070
  .clock_deep_idle_events        : 32381
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 6
  .cpu_load[4]                   : 28

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 40838.698024
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 86159
  .nr_load_updates               : 16049
  .nr_uninterruptible            : 120
  .jiffies                       : 4294958798
  .next_balance                  : 4294.958858
  .curr->pid                     : 3731
  .clock                         : 271181.244051
  .idle_clock                    : 251211.219444
  .prev_clock_raw                : 167428.383199
  .clock_warps                   : 0
  .clock_overflows               : 56701
  .clock_underflows              : 5572
  .clock_deep_idle_events        : 34297
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 77

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39306.996486
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1531.701538
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3731     39306.996487         1   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #1: --
Mo 24. Mär 21:15:12 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 272723.189342 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 100659
  .nr_load_updates               : 14397
  .nr_uninterruptible            : 4294967176
  .jiffies                       : 4294959113
  .next_balance                  : 4294.959173
  .curr->pid                     : 0
  .clock                         : 269606.655478
  .idle_clock                    : 246538.839087
  .prev_clock_raw                : 167738.784653
  .clock_warps                   : 0
  .clock_overflows               : 97036
  .clock_underflows              : 4071
  .clock_deep_idle_events        : 32403
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 77

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 40879.156097
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 86188
  .nr_load_updates               : 16058
  .nr_uninterruptible            : 120
  .jiffies                       : 4294959113
  .next_balance                  : 4294.959173
  .curr->pid                     : 3734
  .clock                         : 272237.244050
  .idle_clock                    : 252256.465881
  .prev_clock_raw                : 167738.890273
  .clock_warps                   : 0
  .clock_overflows               : 56723
  .clock_underflows              : 5575
  .clock_deep_idle_events        : 34318
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 274
  .cpu_load[3]                   : 165
  .cpu_load[4]                   : 105

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 39367.110654
  .min_vruntime                  : 39367.110654
  .max_vruntime                  : 39367.110654
  .spread                        : 0.000000
  .spread0                       : -1512.045443
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3487     39367.110654       276   120               0               0               0.000000               0.000000               0.000000
R            cat  3734     39347.240707         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #2: --
Mo 24. Mär 21:15:13 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 273728.564816 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 100716
  .nr_load_updates               : 14407
  .nr_uninterruptible            : 4294967176
  .jiffies                       : 4294959415
  .next_balance                  : 4294.959475
  .curr->pid                     : 0
  .clock                         : 270610.143166
  .idle_clock                    : 247538.287116
  .prev_clock_raw                : 168115.958729
  .clock_warps                   : 0
  .clock_overflows               : 97121
  .clock_underflows              : 4072
  .clock_deep_idle_events        : 32435
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 270
  .cpu_load[3]                   : 160
  .cpu_load[4]                   : 102

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 40920.582847
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 86240
  .nr_load_updates               : 16073
  .nr_uninterruptible            : 120
  .jiffies                       : 4294959415
  .next_balance                  : 4294.959475
  .curr->pid                     : 3737
  .clock                         : 273251.182270
  .idle_clock                    : 253256.505948
  .prev_clock_raw                : 168115.952243
  .clock_warps                   : 0
  .clock_overflows               : 56762
  .clock_underflows              : 5580
  .clock_deep_idle_events        : 34349
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 259
  .cpu_load[3]                   : 149
  .cpu_load[4]                   : 101

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39447.120776
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1473.462071
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3737     39447.120776         1   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #3: --
Mo 24. Mär 21:15:14 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 274733.900340 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 100754
  .nr_load_updates               : 14415
  .nr_uninterruptible            : 4294967176
  .jiffies                       : 4294959716
  .next_balance                  : 4294.959718
  .curr->pid                     : 0
  .clock                         : 271615.852281
  .idle_clock                    : 248541.390882
  .prev_clock_raw                : 168381.329921
  .clock_warps                   : 0
  .clock_overflows               : 97184
  .clock_underflows              : 4074
  .clock_deep_idle_events        : 32459
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 2
  .cpu_load[2]                   : 26
  .cpu_load[3]                   : 53
  .cpu_load[4]                   : 58

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 41000.582853
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 86285
  .nr_load_updates               : 16086
  .nr_uninterruptible            : 120
  .jiffies                       : 4294959716
  .next_balance                  : 4294.959718
  .curr->pid                     : 3740
  .clock                         : 274262.533924
  .idle_clock                    : 254254.169493
  .prev_clock_raw                : 168380.873994
  .clock_warps                   : 0
  .clock_overflows               : 56784
  .clock_underflows              : 5584
  .clock_deep_idle_events        : 34368
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 4
  .cpu_load[3]                   : 23
  .cpu_load[4]                   : 39

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39467.391872
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1533.190981
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3740     39467.391872         1   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #4: --
Mo 24. Mär 21:15:15 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #5
now at 275739.283217 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.950 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 100808
  .nr_load_updates               : 14424
  .nr_uninterruptible            : 4294967176
  .jiffies                       : 4294960018
  .next_balance                  : 4294.960078
  .curr->pid                     : 0
  .clock                         : 272618.537820
  .idle_clock                    : 249540.220089
  .prev_clock_raw                : 168756.568869
  .clock_warps                   : 0
  .clock_overflows               : 97257
  .clock_underflows              : 4075
  .clock_deep_idle_events        : 32485
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 257
  .cpu_load[3]                   : 142
  .cpu_load[4]                   : 94

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 41041.997441
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.950 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 86326
  .nr_load_updates               : 16097
  .nr_uninterruptible            : 120
  .jiffies                       : 4294960018
  .next_balance                  : 4294.960020
  .curr->pid                     : 3743
  .clock                         : 275273.120113
  .idle_clock                    : 255254.707017
  .prev_clock_raw                : 168756.450873
  .clock_warps                   : 0
  .clock_overflows               : 56813
  .clock_underflows              : 5588
  .clock_deep_idle_events        : 34395
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 13
  .cpu_load[3]                   : 36
  .cpu_load[4]                   : 49

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39547.635133
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1494.362308
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3743     39547.635133         0   120               0               0               0.000000               0.000000               0.000000


--------------030505070705020305090703--

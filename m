Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYCYSdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYCYSdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYCYSdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:33:35 -0400
Received: from www17.your-server.de ([213.133.104.17]:34001 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbYCYSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:33:24 -0400
Message-ID: <47E94557.4030001@m3y3r.de>
Date: Tue, 25 Mar 2008 19:32:55 +0100
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
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu>
In-Reply-To: <20080325165007.GA7775@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050702060803040204020008"
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050702060803040204020008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar schrieb:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> 64-bit ioremaps never worked on 32-bit, so we are in totally 
>> unchartered waters now - but due to the unification we have a 
>> realistic chance to make them work. At minimum we need the fix below 
>> in addition to Linus' patch - does it make any difference?
>>     
>
> could you please try x86.git/latest:
>
>   http://people.redhat.com/mingo/x86.git/README
>
> which has all the fixes and debug patches integrated (no extra patching 
> should be needed). If it still doesnt work then please send the new 
> dmesg and /sys/kernel/debug/kernel_page_tables dump.
>
> head 0fef904c33841be92f or later.
>
> 	Ingo
>
>   
The kernel boots, but hangs at "populating dev tree with devices usings 
uevents". After removing both firewire drivers (ohci1394 and 
firewire_ohci) the system comes up correctly.

See attached file.

Modprobing either ohci1394 or firewire_ohci seems to lock up the system.

mfg
thomas


--------------050702060803040204020008
Content-Type: text/plain;
 name="cfs-debug-info-2008.03.25-19.12.25"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="cfs-debug-info-2008.03.25-19.12.25"

-- /proc/sched_debug: --
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 56065.903300 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 37573
  .nr_load_updates               : 4289
  .nr_uninterruptible            : 4294967186
  .jiffies                       : 4294894116
  .next_balance                  : 4294.894141
  .curr->pid                     : 0
  .clock                         : 51590.120508
  .idle_clock                    : 42883.958376
  .prev_clock_raw                : 73692.062839
  .clock_warps                   : 0
  .clock_overflows               : 35389
  .clock_underflows              : 1343
  .clock_deep_idle_events        : 13523
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 531
  .cpu_load[2]                   : 393
  .cpu_load[3]                   : 380
  .cpu_load[4]                   : 309

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 26316.858781
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 37119
  .nr_load_updates               : 3826
  .nr_uninterruptible            : 110
  .jiffies                       : 4294894116
  .next_balance                  : 4294.894118
  .curr->pid                     : 3424
  .clock                         : 50332.535824
  .idle_clock                    : 46176.952131
  .prev_clock_raw                : 73691.929375
  .clock_warps                   : 0
  .clock_overflows               : 34813
  .clock_underflows              : 972
  .clock_deep_idle_events        : 14961
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 122
  .cpu_load[2]                   : 407
  .cpu_load[3]                   : 443
  .cpu_load[4]                   : 319

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 27376.843608
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 1059.984827
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3424     27376.843608         0   120               0               0               0.000000               0.000000               0.000000

-- /proc/*/task/*/sched: --
udevd (1023, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         30043.181469
se.vruntime                        :         25792.277435
se.sum_exec_runtime                :           355.556308
se.avg_overlap                     :             0.213466
nr_switches                        :                  857
nr_voluntary_switches              :                  222
nr_involuntary_switches            :                  635
se.load.weight                     :                 2501
policy                             :                    0
prio                               :                  116
clock-delta                        :                  216
cqueue (134, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            53.447061
se.vruntime                        :           852.089096
se.sum_exec_runtime                :             0.004984
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  216
ata/0 (138, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         19905.682968
se.vruntime                        :         22495.883308
se.sum_exec_runtime                :             0.646138
se.avg_overlap                     :             0.000210
nr_switches                        :                   50
nr_voluntary_switches              :                   50
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
ata/1 (139, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26219.577596
se.vruntime                        :         25248.875062
se.sum_exec_runtime                :             2.123613
se.avg_overlap                     :             0.000348
nr_switches                        :                   32
nr_voluntary_switches              :                   32
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
ata_aux (140, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            53.667002
se.vruntime                        :           911.151014
se.sum_exec_runtime                :             0.003946
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ksuspend_usbd (141, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          2288.921057
se.vruntime                        :         11055.221320
se.sum_exec_runtime                :             0.016855
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  211
khubd (146, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           929.133092
se.vruntime                        :          6782.518589
se.sum_exec_runtime                :             3.040203
se.avg_overlap                     :             0.005825
nr_switches                        :                  158
nr_voluntary_switches              :                  158
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
kseriod (149, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           375.935280
se.vruntime                        :           963.656262
se.sum_exec_runtime                :             0.007632
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kondemand/0 (168, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         51530.760987
se.vruntime                        :         26276.808574
se.sum_exec_runtime                :             2.468806
se.avg_overlap                     :             0.001333
nr_switches                        :                  531
nr_voluntary_switches              :                  531
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kondemand/1 (169, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50286.128182
se.vruntime                        :         27256.758566
se.sum_exec_runtime                :             2.579224
se.avg_overlap                     :             0.001756
nr_switches                        :                  471
nr_voluntary_switches              :                  471
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
pdflush (191, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           116.590704
se.vruntime                        :          1160.582078
se.sum_exec_runtime                :             0.004870
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
pdflush (192, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25335.511414
se.vruntime                        :         24095.064973
se.sum_exec_runtime                :             0.046257
se.avg_overlap                     :             0.000000
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kswapd0 (193, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           116.749291
se.vruntime                        :          1186.831357
se.sum_exec_runtime                :             0.004582
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
init (1, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         48902.008339
se.vruntime                        :         26973.911183
se.sum_exec_runtime                :           239.900467
se.avg_overlap                     :             0.010425
nr_switches                        :                 1368
nr_voluntary_switches              :                 1362
nr_involuntary_switches            :                    6
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
scsi_eh_4 (2171, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1541.151832
se.vruntime                        :          8803.299413
se.sum_exec_runtime                :             0.003537
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
usb-storage (2173, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49890.487323
se.vruntime                        :         25869.786569
se.sum_exec_runtime                :             1.625315
se.avg_overlap                     :             0.000316
nr_switches                        :                  392
nr_voluntary_switches              :                  392
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
aio/0 (236, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           362.974552
se.vruntime                        :           993.934748
se.sum_exec_runtime                :             0.003903
se.avg_overlap                     :             0.000049
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
aio/1 (237, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           118.770193
se.vruntime                        :          1180.271433
se.sum_exec_runtime                :             0.002252
se.avg_overlap                     :             0.000051
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
applesmc-led (2496, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          2952.444863
se.vruntime                        :         12670.142345
se.sum_exec_runtime                :             0.006829
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  210
kdmflush (2540, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          3233.409631
se.vruntime                        :         13448.951850
se.sum_exec_runtime                :             0.003437
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
kcryptd_io (2549, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         12035.700879
se.vruntime                        :         13525.933091
se.sum_exec_runtime                :             2.756998
se.avg_overlap                     :             0.000000
nr_switches                        :                  302
nr_voluntary_switches              :                  302
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kcryptd (2550, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         12820.451822
se.vruntime                        :         15731.678240
se.sum_exec_runtime                :            15.357342
se.avg_overlap                     :             0.482830
nr_switches                        :                   48
nr_voluntary_switches              :                   48
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kdmflush (2600, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         11783.292592
se.vruntime                        :         16457.410812
se.sum_exec_runtime                :             0.000003
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
kcryptd_io (2602, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50321.576700
se.vruntime                        :         27276.769570
se.sum_exec_runtime                :            37.903599
se.avg_overlap                     :             0.014187
nr_switches                        :                 2114
nr_voluntary_switches              :                 2114
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kcryptd (2603, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         51590.120500
se.vruntime                        :         26180.732238
se.sum_exec_runtime                :           681.988107
se.avg_overlap                     :             0.111616
nr_switches                        :                 1836
nr_voluntary_switches              :                 1836
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kjournald (2656, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         12289.959216
se.vruntime                        :         17069.753311
se.sum_exec_runtime                :             0.000004
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
ifplugd (2762, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49562.332957
se.vruntime                        :         26974.078620
se.sum_exec_runtime                :             1.422083
se.avg_overlap                     :             0.018380
nr_switches                        :                   40
nr_voluntary_switches              :                   40
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
metalog (2934, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         35069.044061
se.vruntime                        :         25903.319018
se.sum_exec_runtime                :            20.324816
se.avg_overlap                     :             0.142801
nr_switches                        :                   73
nr_voluntary_switches              :                   71
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
metalog (2935, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29942.519575
se.vruntime                        :         25610.733483
se.sum_exec_runtime                :             3.419903
se.avg_overlap                     :             0.170436
nr_switches                        :                    9
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
acpid (2944, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         22885.424614
se.vruntime                        :         23973.769799
se.sum_exec_runtime                :             0.361947
se.avg_overlap                     :             0.005217
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-daemon (2954, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49182.063004
se.vruntime                        :         26244.916611
se.sum_exec_runtime                :            14.108551
se.avg_overlap                     :             0.026377
nr_switches                        :                  173
nr_voluntary_switches              :                  172
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
kthreadd (2, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26219.839579
se.vruntime                        :         25282.076002
se.sum_exec_runtime                :             1.223615
se.avg_overlap                     :             0.003419
nr_switches                        :                  205
nr_voluntary_switches              :                  170
nr_involuntary_switches            :                   35
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
nscd (3023, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50268.443608
se.vruntime                        :         27277.067725
se.sum_exec_runtime                :             5.878813
se.avg_overlap                     :             0.003421
nr_switches                        :                  322
nr_voluntary_switches              :                  307
nr_involuntary_switches            :                   15
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
nscd (3024, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50268.987664
se.vruntime                        :         27304.272054
se.sum_exec_runtime                :             1.574367
se.avg_overlap                     :             0.012685
nr_switches                        :                   39
nr_voluntary_switches              :                   33
nr_involuntary_switches            :                    6
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (3025, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         51518.542332
se.vruntime                        :         25875.047842
se.sum_exec_runtime                :             1.138325
se.avg_overlap                     :             0.077149
nr_switches                        :                   33
nr_voluntary_switches              :                   31
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
nscd (3026, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         51516.443814
se.vruntime                        :         26303.988367
se.sum_exec_runtime                :             1.119605
se.avg_overlap                     :             0.018441
nr_switches                        :                   35
nr_voluntary_switches              :                   33
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (3027, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50267.614730
se.vruntime                        :         27277.426632
se.sum_exec_runtime                :             1.872086
se.avg_overlap                     :             0.087370
nr_switches                        :                   30
nr_voluntary_switches              :                   30
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (3028, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50267.255860
se.vruntime                        :         27277.092789
se.sum_exec_runtime                :             2.004523
se.avg_overlap                     :             0.067244
nr_switches                        :                   32
nr_voluntary_switches              :                   30
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
nscd (3029, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50267.980157
se.vruntime                        :         27277.106439
se.sum_exec_runtime                :             1.482106
se.avg_overlap                     :             0.053543
nr_switches                        :                   30
nr_voluntary_switches              :                   30
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
nscd (3030, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         50266.893729
se.vruntime                        :         27277.121582
se.sum_exec_runtime                :             1.172132
se.avg_overlap                     :             0.054858
nr_switches                        :                   29
nr_voluntary_switches              :                   29
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (3031, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         51516.810995
se.vruntime                        :         26303.987545
se.sum_exec_runtime                :             0.931834
se.avg_overlap                     :             0.014504
nr_switches                        :                   33
nr_voluntary_switches              :                   31
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald (3042, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49182.082827
se.vruntime                        :         26264.926658
se.sum_exec_runtime                :           407.738938
se.avg_overlap                     :             0.005229
nr_switches                        :                 1291
nr_voluntary_switches              :                 1125
nr_involuntary_switches            :                  166
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-runner (3043, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26128.638366
se.vruntime                        :         25147.983509
se.sum_exec_runtime                :             8.720935
se.avg_overlap                     :             0.104824
nr_switches                        :                   84
nr_voluntary_switches              :                   80
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-addon-inpu (3089, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50337.639349
se.vruntime                        :         26983.618223
se.sum_exec_runtime                :             3.067074
se.avg_overlap                     :             0.021946
nr_switches                        :                  165
nr_voluntary_switches              :                  163
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-addon-macb (3091, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         18872.181580
se.vruntime                        :         22035.672078
se.sum_exec_runtime                :             3.122306
se.avg_overlap                     :             0.195380
nr_switches                        :                   17
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    8
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
hald-addon-cpuf (3094, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         19151.921380
se.vruntime                        :         22169.601337
se.sum_exec_runtime                :             0.918143
se.avg_overlap                     :             0.059239
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-addon-acpi (3095, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         19152.927949
se.vruntime                        :         22182.288323
se.sum_exec_runtime                :             0.640883
se.avg_overlap                     :             0.021983
nr_switches                        :                   15
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                   10
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dhcpcd (3100, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         19398.334891
se.vruntime                        :         22251.374884
se.sum_exec_runtime                :             0.000001
se.avg_overlap                     :             0.000000
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald-addon-stor (3113, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         48644.448813
se.vruntime                        :         27156.796605
se.sum_exec_runtime                :             5.257183
se.avg_overlap                     :             0.045922
nr_switches                        :                   62
nr_voluntary_switches              :                   47
nr_involuntary_switches            :                   15
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
kdm (3154, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29360.814122
se.vruntime                        :         26420.687484
se.sum_exec_runtime                :             2.004126
se.avg_overlap                     :             0.078129
nr_switches                        :                   31
nr_voluntary_switches              :                   30
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
X (3165, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50164.672555
se.vruntime                        :         27207.521694
se.sum_exec_runtime                :           329.667191
se.avg_overlap                     :             0.432536
nr_switches                        :                 4755
nr_voluntary_switches              :                 4548
nr_involuntary_switches            :                  207
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm (3214, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         36676.627955
se.vruntime                        :         27101.816260
se.sum_exec_runtime                :             1.890876
se.avg_overlap                     :             0.019800
nr_switches                        :                  319
nr_voluntary_switches              :                  314
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
cupsd (3219, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26383.325629
se.vruntime                        :         24592.391447
se.sum_exec_runtime                :           167.754599
se.avg_overlap                     :             2.030543
nr_switches                        :                  116
nr_voluntary_switches              :                   91
nr_involuntary_switches            :                   25
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
ifplugd (3272, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         47682.117668
se.vruntime                        :         26246.008105
se.sum_exec_runtime                :             0.568415
se.avg_overlap                     :             0.004350
nr_switches                        :                    7
nr_voluntary_switches              :                    6
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
pktcdvd0 (3327, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26219.839584
se.vruntime                        :         25248.819642
se.sum_exec_runtime                :             0.000003
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                88761
policy                             :                    0
prio                               :                  100
clock-delta                        :                  198
smartd (3343, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         27849.828880
se.vruntime                        :         25308.946973
se.sum_exec_runtime                :             0.863772
se.avg_overlap                     :             0.005276
nr_switches                        :                    3
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
sshd (3357, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29262.655921
se.vruntime                        :         25464.959294
se.sum_exec_runtime                :             0.349955
se.avg_overlap                     :             0.000369
nr_switches                        :                    4
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
cron (3368, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         29817.949197
se.vruntime                        :         25637.010680
se.sum_exec_runtime                :             0.096210
se.avg_overlap                     :             0.005871
nr_switches                        :                   17
nr_voluntary_switches              :                   13
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
login (3376, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34831.225956
se.vruntime                        :         25896.750783
se.sum_exec_runtime                :             2.911848
se.avg_overlap                     :             0.006818
nr_switches                        :                  108
nr_voluntary_switches              :                   78
nr_involuntary_switches            :                   30
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3377, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         30003.850256
se.vruntime                        :         26414.083453
se.sum_exec_runtime                :             1.200015
se.avg_overlap                     :             0.065054
nr_switches                        :                   18
nr_voluntary_switches              :                   16
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
agetty (3380, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         30004.396628
se.vruntime                        :         26414.181734
se.sum_exec_runtime                :             1.450667
se.avg_overlap                     :             0.088062
nr_switches                        :                   13
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3381, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         31110.035920
se.vruntime                        :         25839.504331
se.sum_exec_runtime                :             1.097559
se.avg_overlap                     :             0.037666
nr_switches                        :                   15
nr_voluntary_switches              :                   15
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
agetty (3382, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         31110.035953
se.vruntime                        :         25832.670614
se.sum_exec_runtime                :             0.722304
se.avg_overlap                     :             0.011966
nr_switches                        :                   17
nr_voluntary_switches              :                   15
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3383, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         31110.035909
se.vruntime                        :         25832.651117
se.sum_exec_runtime                :             1.153380
se.avg_overlap                     :             0.061516
nr_switches                        :                   17
nr_voluntary_switches              :                   17
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kdm_greet (3398, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         50145.211208
se.vruntime                        :         27201.653414
se.sum_exec_runtime                :           233.573551
se.avg_overlap                     :             0.057477
nr_switches                        :                 1350
nr_voluntary_switches              :                  570
nr_involuntary_switches            :                  780
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kdm_greet (3404, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         37857.914621
se.vruntime                        :         26207.058286
se.sum_exec_runtime                :             0.126261
se.avg_overlap                     :             0.002268
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-launch (3402, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34229.967586
se.vruntime                        :         25874.737630
se.sum_exec_runtime                :             0.191999
se.avg_overlap                     :             0.008182
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-daemon (3403, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34235.531642
se.vruntime                        :         25896.263193
se.sum_exec_runtime                :             1.688543
se.avg_overlap                     :             0.067166
nr_switches                        :                   20
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                   10
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3407, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50213.692861
se.vruntime                        :         27223.849267
se.sum_exec_runtime                :            12.868150
se.avg_overlap                     :             0.326879
nr_switches                        :                   69
nr_voluntary_switches              :                   66
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3419, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50335.630419
se.vruntime                        :         27379.938202
se.sum_exec_runtime                :             3.562646
se.avg_overlap                     :             0.013651
nr_switches                        :                   12
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
migration/0 (3, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :             0.004998
se.sum_exec_runtime                :             0.749794
se.avg_overlap                     :             0.000000
nr_switches                        :                  277
nr_voluntary_switches              :                  277
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  198
ksoftirqd/0 (4, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         51590.120507
se.vruntime                        :         26263.664088
se.sum_exec_runtime                :            13.598321
se.avg_overlap                     :             0.001910
nr_switches                        :                 6502
nr_voluntary_switches              :                 6502
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kblockd/0 (51, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37828.629236
se.vruntime                        :         26167.230660
se.sum_exec_runtime                :            10.266948
se.avg_overlap                     :             0.043000
nr_switches                        :                  663
nr_voluntary_switches              :                  662
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kblockd/1 (52, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50302.585799
se.vruntime                        :         26957.506614
se.sum_exec_runtime                :             3.164203
se.avg_overlap                     :             0.000000
nr_switches                        :                   97
nr_voluntary_switches              :                   97
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kacpid (54, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49178.729880
se.vruntime                        :         26236.866455
se.sum_exec_runtime                :             2.278907
se.avg_overlap                     :             0.020976
nr_switches                        :                  451
nr_voluntary_switches              :                  451
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kacpi_notify (55, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             3.333741
se.vruntime                        :           366.423368
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
se.sum_exec_runtime                :             0.704389
se.avg_overlap                     :             0.000000
nr_switches                        :                  248
nr_voluntary_switches              :                  248
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  198
ksoftirqd/1 (6, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         50335.659417
se.vruntime                        :         26322.972974
se.sum_exec_runtime                :             8.987368
se.avg_overlap                     :             0.002663
nr_switches                        :                 5803
nr_voluntary_switches              :                 5802
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
events/0 (7, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         51597.218537
se.vruntime                        :         26316.897815
se.sum_exec_runtime                :             4.711655
se.avg_overlap                     :             0.000063
nr_switches                        :                  600
nr_voluntary_switches              :                  597
nr_involuntary_switches            :                    3
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
scsi_eh_0 (856, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1259.919834
se.vruntime                        :          8012.663980
se.sum_exec_runtime                :             0.824538
se.avg_overlap                     :             0.000974
nr_switches                        :                   16
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    2
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_1 (858, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           298.445013
se.vruntime                        :          2613.207141
se.sum_exec_runtime                :             3.443048
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
scsi_eh_2 (863, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           550.135826
se.vruntime                        :          6408.362643
se.sum_exec_runtime                :            15.403817
se.avg_overlap                     :             0.000326
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_3 (865, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           339.978582
se.vruntime                        :          2677.716600
se.sum_exec_runtime                :             3.334926
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
events/1 (8, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         49562.305202
se.vruntime                        :         26973.879897
se.sum_exec_runtime                :             0.717189
se.avg_overlap                     :             0.000922
nr_switches                        :                   59
nr_voluntary_switches              :                   59
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
kstriped (915, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           376.058416
se.vruntime                        :          2835.220055
se.sum_exec_runtime                :             0.004858
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kjournald (953, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           419.973973
se.vruntime                        :          2966.495526
se.sum_exec_runtime                :             0.000003
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
khelper (9, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         28245.738009
se.vruntime                        :         25759.340488
se.sum_exec_runtime                :             6.753415
se.avg_overlap                     :             0.000828
nr_switches                        :                 1898
nr_voluntary_switches              :                 1885
nr_involuntary_switches            :                   13
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
firmware_class          9600  0 
fuse                   49564  1 
snd_seq                52400  0 
snd_seq_device          8460  1 snd_seq
nls_iso8859_15          4864  1 
nls_cp850               5120  1 
vfat                   13952  1 
fat                    52512  1 vfat
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
thermal                18972  0 
tpm_infineon            9640  0 
tpm                    15936  1 tpm_infineon
snd_hda_intel         339380  0 
snd_pcm                69764  1 snd_hda_intel
snd_timer              23432  2 snd_seq,snd_pcm
tpm_bios                7168  1 tpm
snd                    48628  5 snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
usb_storage            79552  0 
soundcore               8032  1 snd
snd_page_alloc         10632  2 snd_hda_intel,snd_pcm
battery                13188  0 
button                  8336  0 
rng_core                5252  0 
ac                      6148  0 
iTCO_wdt               11812  0 
appletouch             10240  0 
evdev                  12160  7 
i2c_i801               10128  0 
i2c_core               24852  2 eeprom,i2c_i801
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
0xc0000000-0xf8000000         896M     RW         PSE GLB x  pgd
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
0xf8822000-0xf8823000           4K     RW PWT PCD     GLB x  pte
0xf8823000-0xf8824000           4K                           pte
0xf8824000-0xf8825000           4K     RW             GLB x  pte
0xf8825000-0xf8826000           4K                           pte
0xf8826000-0xf8827000           4K     RW PWT PCD     GLB x  pte
0xf8827000-0xf8828000           4K                           pte
0xf8828000-0xf882c000          16K     RW PWT PCD     GLB x  pte
0xf882c000-0xf882d000           4K                           pte
0xf882d000-0xf8837000          40K     RW             GLB x  pte
0xf8837000-0xf8839000           8K                           pte
0xf8839000-0xf8842000          36K     RW             GLB x  pte
0xf8842000-0xf8843000           4K                           pte
0xf8843000-0xf8848000          20K     RW             GLB x  pte
0xf8848000-0xf8849000           4K                           pte
0xf8849000-0xf8852000          36K     RW             GLB x  pte
0xf8852000-0xf8853000           4K                           pte
0xf8853000-0xf885a000          28K     RW             GLB x  pte
0xf885a000-0xf885c000           8K                           pte
0xf885c000-0xf885d000           4K     RW PWT PCD     GLB x  pte
0xf885d000-0xf885e000           4K                           pte
0xf885e000-0xf885f000           4K     RW PWT PCD     GLB x  pte
0xf885f000-0xf8860000           4K                           pte
0xf8860000-0xf8861000           4K     RW PWT PCD     GLB x  pte
0xf8861000-0xf8862000           4K                           pte
0xf8862000-0xf8865000          12K     RW             GLB x  pte
0xf8865000-0xf8867000           8K                           pte
0xf8867000-0xf886a000          12K     RW             GLB x  pte
0xf886a000-0xf886b000           4K                           pte
0xf886b000-0xf8872000          28K     RW             GLB x  pte
0xf8872000-0xf8873000           4K                           pte
0xf8873000-0xf8876000          12K     RW             GLB x  pte
0xf8876000-0xf8877000           4K                           pte
0xf8877000-0xf887a000          12K     RW             GLB x  pte
0xf887a000-0xf887b000           4K                           pte
0xf887b000-0xf887d000           8K     RW             GLB x  pte
0xf887d000-0xf887e000           4K                           pte
0xf887e000-0xf887f000           4K     RW PWT PCD     GLB x  pte
0xf887f000-0xf8880000           4K                           pte
0xf8880000-0xf8883000          12K     RW             GLB x  pte
0xf8883000-0xf8884000           4K                           pte
0xf8884000-0xf8886000           8K     RW             GLB x  pte
0xf8886000-0xf8887000           4K                           pte
0xf8887000-0xf8889000           8K     RW             GLB x  pte
0xf8889000-0xf888a000           4K                           pte
0xf888a000-0xf888d000          12K     RW             GLB x  pte
0xf888d000-0xf888e000           4K                           pte
0xf888e000-0xf8893000          20K     RW             GLB x  pte
0xf8893000-0xf8894000           4K                           pte
0xf8894000-0xf8898000          16K     RW             GLB x  pte
0xf8898000-0xf8899000           4K                           pte
0xf8899000-0xf889b000           8K     RW             GLB x  pte
0xf889b000-0xf889c000           4K                           pte
0xf889c000-0xf889e000           8K     RW             GLB x  pte
0xf889e000-0xf88a0000           8K                           pte
0xf88a0000-0xf88a4000          16K     RW PWT PCD     GLB x  pte
0xf88a4000-0xf88a5000           4K                           pte
0xf88a5000-0xf88a6000           4K     RW             GLB x  pte
0xf88a6000-0xf88a8000           8K                           pte
0xf88a8000-0xf88ae000          24K     RW             GLB x  pte
0xf88ae000-0xf88af000           4K                           pte
0xf88af000-0xf88b3000          16K     RW             GLB x  pte
0xf88b3000-0xf88b4000           4K                           pte
0xf88b4000-0xf88b7000          12K     RW             GLB x  pte
0xf88b7000-0xf88b8000           4K                           pte
0xf88b8000-0xf88cc000          80K     RW             GLB x  pte
0xf88cc000-0xf88cd000           4K                           pte
0xf88cd000-0xf88d9000          48K     RW             GLB x  pte
0xf88d9000-0xf88da000           4K                           pte
0xf88da000-0xf88de000          16K     RW             GLB x  pte
0xf88de000-0xf88df000           4K                           pte
0xf88df000-0xf88e2000          12K     RW             GLB x  pte
0xf88e2000-0xf88e3000           4K                           pte
0xf88e3000-0xf88e5000           8K     RW             GLB x  pte
0xf88e5000-0xf88e6000           4K                           pte
0xf88e6000-0xf88e8000           8K     RW             GLB x  pte
0xf88e8000-0xf88e9000           4K                           pte
0xf88e9000-0xf88eb000           8K     RW             GLB x  pte
0xf88eb000-0xf88ec000           4K                           pte
0xf88ec000-0xf88ee000           8K     RW             GLB x  pte
0xf88ee000-0xf88ef000           4K                           pte
0xf88ef000-0xf8901000          72K     RW             GLB x  pte
0xf8901000-0xf8902000           4K                           pte
0xf8902000-0xf8905000          12K     RW             GLB x  pte
0xf8905000-0xf8906000           4K                           pte
0xf8906000-0xf8908000           8K     RW             GLB x  pte
0xf8908000-0xf8909000           4K                           pte
0xf8909000-0xf890e000          20K     RW             GLB x  pte
0xf890e000-0xf890f000           4K                           pte
0xf890f000-0xf8912000          12K     RW             GLB x  pte
0xf8912000-0xf8913000           4K                           pte
0xf8913000-0xf8915000           8K     RW             GLB x  pte
0xf8915000-0xf8916000           4K                           pte
0xf8916000-0xf8917000           4K     RW             GLB x  pte
0xf8917000-0xf8918000           4K                           pte
0xf8918000-0xf8919000           4K     RW             GLB x  pte
0xf8919000-0xf891b000           8K                           pte
0xf891b000-0xf8924000          36K     RW             GLB x  pte
0xf8924000-0xf8928000          16K                           pte
0xf8928000-0xf892a000           8K     RW             GLB x  pte
0xf892a000-0xf892b000           4K                           pte
0xf892b000-0xf892d000           8K     RW             GLB x  pte
0xf892d000-0xf892e000           4K                           pte
0xf892e000-0xf8934000          24K     RW             GLB x  pte
0xf8934000-0xf8935000           4K                           pte
0xf8935000-0xf8938000          12K     RW             GLB x  pte
0xf8938000-0xf8939000           4K                           pte
0xf8939000-0xf893c000          12K     RW             GLB x  pte
0xf893c000-0xf8945000          36K                           pte
0xf8945000-0xf8952000          52K     RW             GLB x  pte
0xf8952000-0xf8970000         120K                           pte
0xf8970000-0xf89c3000         332K     RW             GLB x  pte
0xf89c3000-0xf89c4000           4K                           pte
0xf89c4000-0xf8a59000         596K     RW             GLB x  pte
0xf8a59000-0xf8a5a000           4K                           pte
0xf8a5a000-0xf8a67000          52K     RW             GLB x  pte
0xf8a67000-0xf8a68000           4K                           pte
0xf8a68000-0xf8a75000          52K     RW             GLB x  pte
0xf8a75000-0xf8c00000        1580K                           pte
0xf8c00000-0xff800000         108M                           pgd
---[ vmalloc() End ]---
0xff800000-0xff801000           4K                           pte
---[ Persisent kmap() Area ]---
0xff801000-0xffadb000        2920K     RW             GLB x  pte
0xffadb000-0xfff9b000        4864K                           pte
---[ Fixmap Area ]---
0xfff9b000-0xfff9c000           4K                           pte
0xfff9c000-0xfff9d000           4K     RW PWT PCD     GLB x  pte
0xfff9d000-0xfff9e000           4K     RW             GLB x  pte
0xfff9e000-0xffffa000         368K                           pte
0xffffa000-0xffffc000           8K     RW PWT PCD     GLB x  pte
0xffffc000-0x00000000          16K                           pte
-- interrupts: --
           CPU0       CPU1       
  0:       6273          0   IO-APIC-edge      timer
  9:       2628          0   IO-APIC-fasteoi   acpi
 14:         88          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         43          0   IO-APIC-fasteoi   uhci_hcd:usb5
 18:         41          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:       3902          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
 22:        302          0   IO-APIC-fasteoi   HDA Intel
 23:        672          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
219:         12          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:       2463       8493   Local timer interrupts
RES:       1809       3814   Rescheduling interrupts
CAL:        164        132   function call interrupts
TLB:         13         46   TLB shootdowns
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
bogomips	: 3666.79
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
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
MemTotal:      2060300 kB
MemFree:       1965448 kB
Buffers:          5480 kB
Cached:          54628 kB
SwapCached:          0 kB
Active:          38456 kB
Inactive:        39588 kB
HighTotal:     1164064 kB
HighFree:      1089212 kB
LowTotal:       896236 kB
LowFree:        876236 kB
SwapTotal:     1214416 kB
SwapFree:      1214416 kB
Dirty:             992 kB
Writeback:           0 kB
AnonPages:       17812 kB
Mapped:          18400 kB
Slab:             9680 kB
SReclaimable:     4132 kB
SUnreclaim:       5548 kB
PageTables:        784 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2244564 kB
Committed_AS:    42048 kB
VmallocTotal:   114680 kB
VmallocUsed:      2336 kB
VmallocChunk:   112160 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB
-- buddyinfo: --
Node 0, zone      DMA      5      5      3      5      4      4      2      1      2      2      1 
Node 0, zone   Normal      1      2      0      2      1      2      3      1      2      2    209 
Node 0, zone  HighMem      1      2      1      1      8     14      9     10      6      2    261 
-- vmstat: --
nr_free_pages 491362
nr_inactive 9897
nr_active 9614
nr_anon_pages 4453
nr_mapped 4600
nr_file_pages 15027
nr_dirty 248
nr_writeback 0
nr_slab_reclaimable 1033
nr_slab_unreclaimable 1387
nr_page_table_pages 196
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
pgpgin 59611
pgpgout 9
pswpin 0
pswpout 0
pgalloc_dma 2
pgalloc_normal 37205
pgalloc_high 112258
pgalloc_movable 0
pgfree 641057
pgactivate 5276
pgdeactivate 0
pgfault 472241
pgmajfault 676
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
  pages free     3075
        min      17
        low      21
        high     25
        scanned  0 (a: 0 i: 0)
        spanned  4096
        present  4064
    nr_free_pages 3075
    nr_inactive  0
    nr_active    0
    nr_anon_pages 0
    nr_mapped    0
    nr_file_pages 0
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 0
    nr_slab_unreclaimable 2
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
  pages free     215984
        min      936
        low      1170
        high     1404
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  223520
    nr_free_pages 215984
    nr_inactive  655
    nr_active    709
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 1364
    nr_dirty     2
    nr_writeback 0
    nr_slab_reclaimable 1033
    nr_slab_unreclaimable 1385
    nr_page_table_pages 196
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 9023, 9023)
  pagesets
    cpu: 0
              count: 78
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 81
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     272303
        min      128
        low      430
        high     733
        scanned  0 (a: 0 i: 0)
        spanned  291016
        present  288743
    nr_free_pages 272303
    nr_inactive  9242
    nr_active    8905
    nr_anon_pages 4484
    nr_mapped    4599
    nr_file_pages 13663
    nr_dirty     246
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
              count: 42
              high:  186
              batch: 31
  vm stats threshold: 20
    cpu: 1
              count: 61
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
Node    0, zone      DMA, type    Unmovable      0      1      1      1      1      1      1      1      1      1      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable      5      4      2      4      3      3      1      0      1      1      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone   Normal, type    Unmovable      0      1      0      1      1      1      1      0      1      0      0 
Node    0, zone   Normal, type  Reclaimable      0      1      0      0      0      0      1      1      1      1      0 
Node    0, zone   Normal, type      Movable      1      0      0      1      0      1      1      0      0      1    208 
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone   Normal, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type    Unmovable      0      1      0      0      0      1      1      1      1      0      0 
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type      Movable      1      1      1      1      8     13      8      9      5      2    260 
Node    0, zone  HighMem, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone  HighMem, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone   Normal            3            2          214            1            0 
Node 0, zone  HighMem            1            0          283            1            0 
-- slabinfo: --
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fuse_request           0      0    368   11    1 : tunables    0    0    0 : slabdata      0      0      0
fuse_inode             0      0    448    9    1 : tunables    0    0    0 : slabdata      0      0      0
fat_inode_cache       10     10    400   10    1 : tunables    0    0    0 : slabdata      1      1      0
fat_cache              0      0     24  170    1 : tunables    0    0    0 : slabdata      0      0      0
kmalloc_dma-512       16     16    512    8    1 : tunables    0    0    0 : slabdata      2      2      0
flow_cache             0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2464    3    2 : tunables    0    0    0 : slabdata      0      0      0
cfq_io_context        84     84     96   42    1 : tunables    0    0    0 : slabdata      2      2      0
bsg_cmd                0      0    288   14    1 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache      7      7    576    7    1 : tunables    0    0    0 : slabdata      1      1      0
hugetlbfs_inode_cache     11     11    344   11    1 : tunables    0    0    0 : slabdata      1      1      0
ext2_inode_cache       0      0    464    8    1 : tunables    0    0    0 : slabdata      0      0      0
journal_handle       340    340     24  170    1 : tunables    0    0    0 : slabdata      2      2      0
journal_head         438    438     56   73    1 : tunables    0    0    0 : slabdata      6      6      0
revoke_record        512    512     16  256    1 : tunables    0    0    0 : slabdata      2      2      0
ext3_inode_cache    1608   1608    472    8    1 : tunables    0    0    0 : slabdata    201    201      0
configfs_dir_cache     73     73     56   73    1 : tunables    0    0    0 : slabdata      1      1      0
shmem_inode_cache   3157   3159    440    9    1 : tunables    0    0    0 : slabdata    351    351      0
xfrm_dst_cache         0      0    320   12    1 : tunables    0    0    0 : slabdata      0      0      0
UDP                   14     14    576    7    1 : tunables    0    0    0 : slabdata      2      2      0
TCP                   12     12   1216    6    2 : tunables    0    0    0 : slabdata      2      2      0
sgpool-128             4      4   2048    4    2 : tunables    0    0    0 : slabdata      1      1      0
scsi_io_context        0      0    104   39    1 : tunables    0    0    0 : slabdata      0      0      0
blkdev_queue          21     21   1080    7    2 : tunables    0    0    0 : slabdata      3      3      0
biovec-256            68     68   3072    2    2 : tunables    0    0    0 : slabdata     34     34      0
biovec-128            75     75   1536    5    2 : tunables    0    0    0 : slabdata     15     15      0
biovec-64             75     75    768    5    1 : tunables    0    0    0 : slabdata     15     15      0
sock_inode_cache      98    100    384   10    1 : tunables    0    0    0 : slabdata     10     10      0
file_lock_cache       72     72    112   36    1 : tunables    0    0    0 : slabdata      2      2      0
Acpi-Operand        1208   1224     40  102    1 : tunables    0    0    0 : slabdata     12     12      0
Acpi-Namespace      1530   1530     24  170    1 : tunables    0    0    0 : slabdata      9      9      0
proc_inode_cache     726    726    360   11    1 : tunables    0    0    0 : slabdata     66     66      0
sigqueue              56     56    144   28    1 : tunables    0    0    0 : slabdata      2      2      0
radix_tree_node     1655   1664    296   13    1 : tunables    0    0    0 : slabdata    128    128      0
bdev_cache            24     24    512    8    1 : tunables    0    0    0 : slabdata      3      3      0
sysfs_dir_cache    11361  11390     48   85    1 : tunables    0    0    0 : slabdata    134    134      0
inode_cache         4015   4015    344   11    1 : tunables    0    0    0 : slabdata    365    365      0
dentry             10527  10528    128   32    1 : tunables    0    0    0 : slabdata    329    329      0
names_cache            4      4   4096    2    2 : tunables    0    0    0 : slabdata      2      2      0
idr_layer_cache      280    280    144   28    1 : tunables    0    0    0 : slabdata     10     10      0
buffer_head         3968   3968     64   64    1 : tunables    0    0    0 : slabdata     62     62      0
vm_area_struct      1612   1748     88   46    1 : tunables    0    0    0 : slabdata     38     38      0
files_cache           46     50    384   10    1 : tunables    0    0    0 : slabdata      5      5      0
signal_cache         194    198    448    9    1 : tunables    0    0    0 : slabdata     22     22      0
sighand_cache         89     90   1344    6    2 : tunables    0    0    0 : slabdata     15     15      0
task_struct           97     99    864    9    2 : tunables    0    0    0 : slabdata     11     11      0
anon_vma            1019   1024     16  256    1 : tunables    0    0    0 : slabdata      4      4      0
kmalloc-4096          50     56   4096    8    8 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-2048         223    224   2048   16    8 : tunables    0    0    0 : slabdata     14     14      0
kmalloc-1024         237    240   1024    4    1 : tunables    0    0    0 : slabdata     60     60      0
kmalloc-512          967    976    512    8    1 : tunables    0    0    0 : slabdata    122    122      0
kmalloc-256           93     96    256   16    1 : tunables    0    0    0 : slabdata      6      6      0
kmalloc-128         1189   1216    128   32    1 : tunables    0    0    0 : slabdata     38     38      0
kmalloc-64          1641   1664     64   64    1 : tunables    0    0    0 : slabdata     26     26      0
kmalloc-32          1011   1024     32  128    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-16          3838   3840     16  256    1 : tunables    0    0    0 : slabdata     15     15      0
kmalloc-8           4607   4608      8  512    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-192          383    399    192   21    1 : tunables    0    0    0 : slabdata     19     19      0
kmalloc-96           425    504     96   42    1 : tunables    0    0    0 : slabdata     12     12      0
-- dmesg: --
[    0.000000] Linux version 2.6.25-rc6-x86-latest.git (thomas@hotzenplotz) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #8 SMP Tue Mar 25 18:33:53 CET 2008
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
[    0.000000] CPU and/or kernel does not support PAT.
[    0.000000] 1136MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
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
[    0.000000] CPU 0 irqstacks, hard=c0458000 soft=c0456000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Detected 1830.980 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 2059276k/2081568k available (2334k kernel code, 21116k reserved, 809k data, 240k init, 1164064k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc0417000 - 0xc0453000   ( 240 kB)
[    0.003333]       .data : 0xc03478b1 - 0xc0411d40   ( 809 kB)
[    0.003333]       .text : 0xc0100000 - 0xc03478b1   (2334 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333]  f8800000
[    0.003333] hpet clockevent registered
[    0.083330] Calibrating delay using timer specific routine.. 3666.79 BogoMIPS (lpj=6108468)
[    0.083435] Mount-cache hash table entries: 512
[    0.083598] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.083670] CPU: L2 cache: 2048K
[    0.083711] CPU: Physical Processor ID: 0
[    0.083751] CPU: Processor Core ID: 0
[    0.083793] Intel machine check architecture supported.
[    0.083838] Intel machine check reporting enabled on CPU#0.
[    0.083878] using mwait in idle threads.
[    0.083922] Compat vDSO mapped to ffffe000.
[    0.083966] Checking 'hlt' instruction... OK.
[    0.100065] ACPI: Core revision 20070126
[    0.100131]  f8808000
[    0.110153]  f8802000
[    0.110457]  f8804000
[    0.110772]  f8806000
[    0.113563] ENABLING IO-APIC IRQs
[    0.113798] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.147476] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.149990] CPU 1 irqstacks, hard=c0459000 soft=c0457000
[    0.149990] Booting processor 1/1 ip 4000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3663.34 BogoMIPS (lpj=6102958)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.240494] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.240941] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.243328] Brought up 2 CPUs
[    0.243373] Total of 2 processors activated (7329.14 BogoMIPS).
[    0.243436] CPU0 attaching sched-domain:
[    0.243439]  domain 0: span 3
[    0.243441]   groups: 1 2
[    0.243444] CPU1 attaching sched-domain:
[    0.243446]  domain 0: span 3
[    0.243447]   groups: 2 1
[    0.243701] net_namespace: 448 bytes
[    0.243907] NET: Registered protocol family 16
[    0.244120] No dock devices found.
[    0.244236] ACPI: bus type pci registered
[    0.244349]  f880e000
[    0.244394] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.244437] PCI: Not using MMCONFIG.
[    0.244478] PCI: Fatal: No config space access function found
[    0.244520] Setting up standard PCI resources
[    0.247249]  f8810000
[    0.247470]  f8812000
[    0.247516] ACPI: EC: EC description table is found, configuring boot EC
[    0.247717]  f8814c1f
[    0.247797] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.250035] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.250110]  f8814c10
[    0.252998] ACPI: Interpreter enabled
[    0.253039] ACPI: (supports S0 S3 S4 S5)
[    0.253204] ACPI: Using IOAPIC for interrupt routing
[    0.253286] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.253501] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.253615] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.253730] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.253895] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.254048] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.254161] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.254276] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.254437] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.254589] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.254702] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.254816] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.254980] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.255132] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.255244] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.255359] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.256672] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.256824] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.256937] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.257050] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.257215] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.257367] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.257479] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.257594] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.257758] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.257910] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.258023] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.258137] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.258298] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.258448] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.258563] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.258677] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.258843] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.259111]  f8816404
[    0.263005] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.263049] PCI: Using MMCONFIG for extended config space
[    0.275182] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.275226] ACPI: EC: driver started in poll mode
[    0.276594] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.277243] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.277297] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.278073] PCI: Transparent bridge - 0000:00:1e.0
[    0.278148] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.278504] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.278644] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.278777] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.278908] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.279050] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.285960] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.286464] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.286914] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.287416] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.287875] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.288407] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.288939] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    0.289441] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.289902]  f8818000
[    0.289987]  f881a000
[    0.290033]  f881c000
[    0.290086]  f881e000
[    0.290140]  f8820000
[    0.290352] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.290421] pnp: PnP ACPI init
[    0.290467] ACPI: bus type pnp registered
[    0.292627] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.297641] pnp: PnP ACPI: found 10 devices
[    0.297705] ACPI: ACPI bus type pnp unregistered
[    0.297935] SCSI subsystem initialized
[    0.298022] libata version 3.00 loaded.
[    0.298237] usbcore: registered new interface driver usbfs
[    0.298340] usbcore: registered new interface driver hub
[    0.298504] usbcore: registered new device driver usb
[    0.298815] PCI: Using ACPI for IRQ routing
[    0.298856] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.298908] PCI: System does not support PCI
[    0.298949] PCI: System does not support PCI
[    0.303328] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.303483] hpet0: 3 64-bit timers, 14318180 Hz
[    0.309992] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.310044] system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.310095] system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.310146] system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.310198] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.310249] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.310298] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.310345] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.310388] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.310431] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.310474] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.310517] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.310560] system 00:08: ioport range 0x1640-0x164f has been reserved
[    0.341127] PCI: Bridge: 0000:00:01.0
[    0.341168]   IO window: 2000-2fff
[    0.341208]   MEM window: 0x94000000-0x940fffff
[    0.341249]   PREFETCH window: 0x0000000088000000-0x0000000093ffffff
[    0.341304] PCI: Bridge: 0000:00:1c.0
[    0.341345]   IO window: 3000-3fff
[    0.341388]   MEM window: 0x94100000-0x941fffff
[    0.341430]   PREFETCH window: 0x0000000094200000-0x00000000942fffff
[    0.341484] PCI: Bridge: 0000:00:1c.1
[    0.341523]   IO window: disabled.
[    0.341567]   MEM window: 0x94300000-0x943fffff
[    0.341609]   PREFETCH window: disabled.
[    0.341653] PCI: Bridge: 0000:00:1c.2
[    0.341692]   IO window: disabled.
[    0.341736]   MEM window: disabled.
[    0.341777]   PREFETCH window: disabled.
[    0.341823] PCI: Bridge: 0000:00:1e.0
[    0.341862]   IO window: disabled.
[    0.341906]   MEM window: 0x00000000-0x000fffff
[    0.341948]   PREFETCH window: disabled.
[    0.341999] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.342081] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.342099] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.342182] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.342200] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.342282] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.342301] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.342384] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.342395] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.342404] NET: Registered protocol family 2
[    0.353350] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.353588] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.354297] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.354670] TCP: Hash tables configured (established 131072 bind 65536)
[    0.354713] TCP reno registered
[    0.116136] Machine check exception polling timer started.
[    0.116638] highmem bounce pool size: 64 pages
[    0.116664] Total HugeTLB memory allocated, 0
[    0.118620] VFS: Disk quotas dquot_6.5.1
[    0.118685] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.119253] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.119306] io scheduler noop registered
[    0.119346] io scheduler anticipatory registered
[    0.119387] io scheduler deadline registered
[    0.119474] io scheduler cfq registered (default)
[    0.119590]  f8822000
[    0.119750] pci 0000:01:00.0: Boot video device
[    0.119819] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.119836] assign_interrupt_mode Found MSI capability
[    0.119892] Allocate Port Service[0000:00:01.0:pcie00]
[    0.119926] Allocate Port Service[0000:00:01.0:pcie03]
[    0.120012] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.120048] assign_interrupt_mode Found MSI capability
[    0.120123] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.120154] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.120186] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.120268] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.120304] assign_interrupt_mode Found MSI capability
[    0.120379] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.120411] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.120441] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.120530] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.120566] assign_interrupt_mode Found MSI capability
[    0.120640] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.120671] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.120703] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.141744]  f8822000
[    0.141786] hpet_resources: 0xfed00000 is busy
[    0.141832] Linux agpgart interface v0.103
[    0.141913] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.142001] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    0.142014]  f8828000
[    0.142065] sky2 0000:02:00.0: v1.21 addr 0x94100000 irq 16 Yukon-EC (0xb6) rev 2
[    0.386850] sky2 eth0: addr 00:16:cb:8c:b2:65
[    0.386945] console [netcon0] enabled
[    0.389976] netconsole: network logging started
[    0.390070] input: Macintosh mouse button emulation as /class/input/input0
[    0.390156] Driver 'sd' needs updating - please use bus_type methods
[    0.390281] ata_piix 0000:00:1f.1: version 2.12
[    0.390288] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.390397] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.390473] scsi0 : ata_piix
[    0.390572] scsi1 : ata_piix
[    0.391135] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 irq 14
[    0.391180] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 irq 15
[    0.266657] Switched to high resolution mode on CPU 1
[    0.503303] Switched to high resolution mode on CPU 0
[    0.280575] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    0.290512] ata1.00: configured for UDMA/66
[    0.506633] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAEA PQ: 0 ANSI: 5
[    0.506633] PCI: Enabling device 0000:00:1f.2 (0005 -> 0007)
[    0.506633] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    0.506633] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.513308] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.513350] scsi2 : ata_piix
[    0.513457] scsi3 : ata_piix
[    0.514451] ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10d0 bmdma 0x10b0 irq 19
[    0.514496] ata4: SATA max UDMA/133 cmd 0x10c8 ctl 0x10d4 bmdma 0x10b8 irq 19
[    0.533298] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    0.533298] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    0.537807] ata3.01: configured for UDMA/133
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
[    0.549995] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.550166] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    0.550252]  f8822000
[    0.550292] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    0.550295] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.550392] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    0.554344] ehci_hcd 0000:00:1d.7: debug port 1
[    0.554389] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    0.554398] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94405000
[    0.566635] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    0.566867] usb usb1: configuration #1 chosen from 1 choice
[    0.566957] hub 1-0:1.0: USB hub found
[    0.567002] hub 1-0:1.0: 8 ports detected
[    0.573402] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.573444] USB Universal Host Controller Interface driver v3.0
[    0.573504] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    0.573589] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    0.573592] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.573680] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.573755] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001000
[    0.573927] usb usb2: configuration #1 chosen from 1 choice
[    0.574013] hub 2-0:1.0: USB hub found
[    0.574058] hub 2-0:1.0: 2 ports detected
[    0.586710] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    0.586794] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    0.586797] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.586877] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    0.586952] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
[    0.587130] usb usb3: configuration #1 chosen from 1 choice
[    0.587218] hub 3-0:1.0: USB hub found
[    0.587262] hub 3-0:1.0: 2 ports detected
[    0.600037] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.600122] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    0.600125] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.600204] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    0.600284] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    0.600469] usb usb4: configuration #1 chosen from 1 choice
[    0.600555] hub 4-0:1.0: USB hub found
[    0.600599] hub 4-0:1.0: 2 ports detected
[    0.616703] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    0.616788] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    0.616791] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    0.616872] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    0.616950] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001060
[    0.617131] usb usb5: configuration #1 chosen from 1 choice
[    0.617212] hub 5-0:1.0: USB hub found
[    0.617255] hub 5-0:1.0: 2 ports detected
[    0.636854] PNP: No PS/2 controller found. Probing ports directly.
[    0.637769] i8042.c: No controller found.
[    0.639999] mice: PS/2 mouse device common for all mice
[    0.640142] device-mapper: uevent: version 1.0.3
[    0.640237] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    0.640299] cpuidle: using governor ladder
[    0.640339] cpuidle: using governor menu
[    0.646633] usb 1-3: new high speed USB device using ehci_hcd and address 3
[    0.665997] usb 1-3: configuration #1 chosen from 1 choice
[    0.699961] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    0.720410] usb 1-4: configuration #1 chosen from 1 choice
[    0.796623] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    0.809947] usb 2-2: configuration #1 chosen from 1 choice
[    0.873282] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    0.889942] usb 4-2: configuration #1 chosen from 1 choice
[    0.909945] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    0.926606] usb 5-1: configuration #1 chosen from 1 choice
[    0.930035] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input1
[    0.931745] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    0.933272] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input2
[    0.936611] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    0.941938] HID device claimed by neither input, hiddev nor hidraw
[    0.946605] input: HID 05ac:1000 as /class/input/input3
[    0.946605] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
[    0.946605] input: HID 05ac:1000 as /class/input/input4
[    0.948319] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[    0.948458] usbcore: registered new interface driver usbhid
[    0.948502] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    0.948938] TCP cubic registered
[    0.948986] NET: Registered protocol family 1
[    0.949037] NET: Registered protocol family 17
[    0.949083] Using IPI No-Shortcut mode
[    0.956604] EXT3-fs: INFO: recovery required on readonly filesystem.
[    0.956604] EXT3-fs: write access will be enabled during recovery.
[    0.419973] kjournald starting.  Commit interval 5 seconds
[    0.956604] EXT3-fs: recovery complete.
[    0.956604] EXT3-fs: mounted filesystem with ordered data mode.
[    0.956604] VFS: Mounted root (ext3 filesystem) readonly.
[    0.956604] Freeing unused kernel memory: 240k freed
[    1.666779] Driver 'sr' needs updating - please use bus_type methods
[    1.668263] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.668268] Uniform CD-ROM driver Revision: 3.20
[    1.668316] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.679081] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.679104] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.929031]  f8826c90
[    1.929100] ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[    1.929334]  f885cc10
[    1.929423] ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[    1.929756] Monitor-Mwait will be used to enter C-1 state
[    1.929759] Monitor-Mwait will be used to enter C-2 state
[    1.929762] Monitor-Mwait will be used to enter C-3 state
[    1.929816] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    1.929842] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.929846] ACPI: Processor [CPU0] (supports 8 throttling states)
[    1.930171]  f885ef10
[    1.930193] ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[    1.930401]  f8860f10
[    1.930423] ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[    1.300061] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    1.300079] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.300084] ACPI: Processor [CPU1] (supports 8 throttling states)
[    1.301476] Marking TSC unstable due to: TSC halts in idle.
[    1.969989] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    2.109629] appletouch: Geyser mode initialized.
[    2.109629] input: appletouch as /class/input/input5
[    2.113586] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    2.113643]  f887e410
[    2.113656] iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
[    2.113687] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.126399] ACPI: AC Adapter [ADP1] (on-line)
[    2.128950] usbcore: registered new interface driver appletouch
[    2.143597]  f8880000
[    2.143597] intel_rng: FWH not detected
[    1.512001] input: Power Button (FF) as /class/input/input6
[    1.514744] ACPI: Power Button (FF) [PWRF]
[    1.514831] input: Lid Switch as /class/input/input7
[    1.519320] ACPI: Lid Switch [LID0]
[    1.519381] input: Power Button (CM) as /class/input/input8
[    1.536316] ACPI: Power Button (CM) [PWRB]
[    1.536413] input: Sleep Button (CM) as /class/input/input9
[    2.173426] Initializing USB Mass Storage driver...
[    2.180976] scsi4 : SCSI emulation for USB Mass Storage devices
[    2.180976] usbcore: registered new interface driver usb-storage
[    2.180976] USB Mass Storage support registered.
[    2.180976] usb-storage: device found at 3
[    2.180976] usb-storage: waiting for device to settle before scanning
[    1.547786] ACPI: Sleep Button (CM) [SLPB]
[    2.304080] ACPI: Battery Slot [BAT0] (battery present)
[    2.322087] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    2.322101]  f88a0000
[    2.322116] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    2.352242] hda_codec: STAC922x, Apple subsys_id=106b0200
[    2.398455] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[    2.398455] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    2.399194] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    2.399460] EXT3 FS on sda3, internal journal
[    2.754023] loop: module loaded
[    3.465743] tun: Universal TUN/TAP device driver, 1.6
[    3.465749] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.543454] applesmc: Apple MacBook Pro detected:
[    3.543459] applesmc:  - Model with accelerometer
[    3.543463] applesmc:  - Model with light sensors and backlight
[    3.543466] applesmc:  - Model with 12 temperature sensors
[    3.599798] applesmc: device successfully initialized (0xe0, 0x00).
[    3.599798] applesmc: device successfully initialized.
[    3.599798] applesmc: 2 fans found.
[    3.599798] input: applesmc as /class/input/input10
[    3.609991] Registered led device: smc::kbd_backlight
[    3.609991] applesmc: driver successfully loaded.
[    4.328736] Clocksource tsc unstable (delta = -344184419 ns)
[    7.201307] usb-storage: device scan complete
[    7.202114] scsi 4:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
[    7.203301] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    7.204667] sd 4:0:0:0: [sdb] Write Protect is off
[    7.204672] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    7.204676] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    7.208412] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[    7.209657] sd 4:0:0:0: [sdb] Write Protect is off
[    7.209657] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[    7.209657] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[    7.209657]  sdb: sdb1 sdb2
[    7.210284] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[    7.210352] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   12.289959] kjournald starting.  Commit interval 90 seconds
[   12.289959] EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
[   12.290132] EXT3 FS on dm-1, internal journal
[   12.290132] EXT3-fs: recovery complete.
[   12.290132] EXT3-fs: mounted filesystem with ordered data mode.
[   12.820451] Adding 1214416k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1214416k
[   14.324886] sky2 eth0: enabling interface
[   16.075118] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   25.943836] fuse init (API version 7.9)
[   25.853954] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   26.980344] appletouch: incomplete data package (first byte: 2, length: 4).
[   26.219839] pktcdvd: writer pktcdvd0 mapped to sr0
[   29.937579] CPU0 attaching NULL sched-domain.
[   29.937590] CPU1 attaching NULL sched-domain.
[   29.942178] CPU0 attaching sched-domain:
[   29.942185]  domain 0: span 3
[   29.942188]   groups: 1 2
[   29.942194]   domain 1: span 3
[   29.942197]    groups: 3
[   29.942201] CPU1 attaching sched-domain:
[   29.942205]  domain 0: span 3
[   29.942208]   groups: 2 1
[   29.942212]   domain 1: span 3
[   29.942215]    groups: 3
-- /proc/timer_list: --
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 56297708180 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206468689940548915 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f723cebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 56299994370 nsecs [in 2286190 nsecs]
 #1: <f723cebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3025
 # expires at 67250966555 nsecs [in 10953258375 nsecs]
 #2: <f723cebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3026
 # expires at 67251003990 nsecs [in 10953295810 nsecs]
 #3: <f723cebc>, hrtimer_wakeup, S:01, do_nanosleep, cron/3368
 # expires at 91514203923 nsecs [in 35216495743 nsecs]
 #4: <f723cebc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3343
 # expires at 1832577647111 nsecs [in 1776279938931 nsecs]
  .expires_next   : 56299994370 nsecs
  .hres_active    : 1
  .nr_events      : 4402
  .nohz_mode      : 2
  .idle_tick      : 56259994374 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294894174
  .idle_calls     : 17509
  .idle_sleeps    : 7233
  .idle_entrytime : 56296672923 nsecs
  .idle_waketime  : 56268065516 nsecs
  .idle_exittime  : 56268125300 nsecs
  .idle_sleeptime : 49306927814 nsecs
  .last_jiffies   : 4294894186
  .next_jiffies   : 4294894200
  .idle_expires   : 56343327699 nsecs
jiffies: 4294894186

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206468689940548915 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f723cebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 56300827703 nsecs [in 3119523 nsecs]
 #1: <f723cebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3024
 # expires at 67250988695 nsecs [in 10953280515 nsecs]
  .expires_next   : 56300827703 nsecs
  .hres_active    : 1
  .nr_events      : 8421
  .nohz_mode      : 2
  .idle_tick      : 56244161042 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294894169
  .idle_calls     : 14820
  .idle_sleeps    : 4768
  .idle_entrytime : 56297508504 nsecs
  .idle_waketime  : 55895193895 nsecs
  .idle_exittime  : 56269546500 nsecs
  .idle_sleeptime : 52799778502 nsecs
  .last_jiffies   : 4294894186
  .next_jiffies   : 4294894208
  .idle_expires   : 56296661037 nsecs
jiffies: 4294894186


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     56300827703 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_oneshot_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000002


Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   806338790
 min_delta_ns:   1441
 mult:           44681954
 shift:          32
 mode:           3
 next_event:     56299994370 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

Tick Device: mode:     1
Clock Event Device: lapic
 max_delta_ns:   806338790
 min_delta_ns:   1441
 mult:           44681954
 shift:          32
 mode:           1
 next_event:     56300827703 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

-- /proc/timer_info: --
-- /proc/config.gz: --
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc6
# Tue Mar 25 18:33:03 2008
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
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
# CONFIG_HID_FF is not set
# CONFIG_USB_HIDDEV is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
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
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
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
 19:12:26 up 0 min,  1 user,  load average: 0.42, 0.12, 0.04
-- uname: --
Linux hotzenplotz 2.6.25-rc6-x86-latest.git #8 SMP Tue Mar 25 18:33:53 CET 2008 i686 Genuine Intel(R) CPU T2400 @ 1.83GHz GenuineIntel GNU/Linux
-- /sys/devices/system: --
/sys/devices/system/cpu/sched_mc_power_savings:
1
/sys/devices/system/cpu/cpuidle/current_driver:
acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:
menu
/sys/devices/system/cpu/cpu0/crash_notes:
37c640c0
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
266
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
1093
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:
101926
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:
12766
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:
43177720
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
37c64180
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
1
/sys/devices/system/cpu/cpu1/cpuidle/state0/time:
225
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
4025
/sys/devices/system/cpu/cpu1/cpuidle/state2/time:
142407
/sys/devices/system/cpu/cpu1/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu1/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu1/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu1/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu1/cpuidle/state3/usage:
11430
/sys/devices/system/cpu/cpu1/cpuidle/state3/time:
46477953
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
top - 19:12:27 up 0 min,  1 user,  load average: 0.42, 0.12, 0.04
Tasks:  79 total,   1 running,  78 sleeping,   0 stopped,   0 zombie
Cpu(s):  4.2%us,  4.1%sy,  0.0%ni, 66.2%id, 25.4%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:   2060300k total,    95712k used,  1964588k free,     5528k buffers
Swap:  1214416k total,        0k used,  1214416k free,    54760k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   51 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   52 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   54 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   55 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  139 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  140 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  141 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
  146 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
  149 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  168 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  169 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  191 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  192 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  193 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  236 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  237 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  856 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  858 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  863 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  865 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  915 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  953 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 1023 root      16  -4  2612 1452  468 S    0  0.1   0:00.34 /sbin/udevd --daemo
 2171 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2173 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2496 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2540 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2549 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2550 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2600 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2602 root      15  -5     0    0    0 S    0  0.0   0:00.02 [kcryptd_io]       
 2603 root      15  -5     0    0    0 S    0  0.0   0:00.67 [kcryptd]          
 2656 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2762 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2934 root      20   0  1920  584  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2935 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2944 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2954 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3023 root      20   0  106m  976  728 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3042 haldaemo  20   0  4772 2932 2272 S    0  0.1   0:00.39 /usr/sbin/hald --us
 3043 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 3089 root      20   0  3144 1108  952 S    0  0.1   0:00.00 hald-addon-input: L
 3091 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3094 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3095 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3100 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3113 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3154 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3165 root      20   0  145m  12m 3512 S    0  0.6   0:00.32 /usr/bin/X -br -nov
 3214 root      20   0  3772 1072  812 S    0  0.1   0:00.00 -:0                
 3219 root      20   0  7040 2292 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3272 root      20   0  1636  444  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3327 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3343 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3357 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3368 root      20   0  1948  388  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3376 root      20   0  2496 1240  916 S    0  0.1   0:00.00 /bin/login --      
 3377 root      20   0  1612  600  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3380 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3381 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3382 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3383 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3398 root      20   0 36612  13m  10m S    0  0.7   0:00.22 /usr/kde/4.0/lib/kd
 3402 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3403 root      20   0  2056  664  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3407 root      20   0  2972 1620 1300 S    0  0.1   0:00.00 -bash              
 3419 root      20   0  2972  992  648 S    0  0.0   0:00.03 -bash              
 3660 root      20   0  2040  892  688 R    0  0.0   0:00.00 top -c -b -d 1 -n 5


top - 19:12:28 up 0 min,  1 user,  load average: 0.42, 0.12, 0.04
Tasks:  79 total,   1 running,  78 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060300k total,    95768k used,  1964532k free,     5528k buffers
Swap:  1214416k total,        0k used,  1214416k free,    54844k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3660 root      20   0  2048  980  768 R    1  0.0   0:00.01 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   51 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   52 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   54 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   55 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  139 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  140 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  141 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
  146 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
  149 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  168 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  169 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  191 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  192 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  193 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  236 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  237 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  856 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  858 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  863 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  865 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  915 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  953 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 1023 root      16  -4  2612 1452  468 S    0  0.1   0:00.34 /sbin/udevd --daemo
 2171 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2173 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2496 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2540 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2549 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2550 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2600 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2602 root      15  -5     0    0    0 S    0  0.0   0:00.02 [kcryptd_io]       
 2603 root      15  -5     0    0    0 S    0  0.0   0:00.67 [kcryptd]          
 2656 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2762 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2934 root      20   0  1920  584  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2935 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2944 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2954 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3023 root      20   0  106m  976  728 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3042 haldaemo  20   0  4772 2932 2272 S    0  0.1   0:00.39 /usr/sbin/hald --us
 3043 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 3089 root      20   0  3144 1108  952 S    0  0.1   0:00.00 hald-addon-input: L
 3091 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3094 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3095 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3100 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3113 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3154 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3165 root      20   0  145m  12m 3512 S    0  0.6   0:00.32 /usr/bin/X -br -nov
 3214 root      20   0  3772 1072  812 S    0  0.1   0:00.00 -:0                
 3219 root      20   0  7040 2292 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3272 root      20   0  1636  444  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3327 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3343 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3357 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3368 root      20   0  1948  388  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3376 root      20   0  2496 1240  916 S    0  0.1   0:00.00 /bin/login --      
 3377 root      20   0  1612  600  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3380 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3381 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3382 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3383 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3398 root      20   0 36612  13m  10m S    0  0.7   0:00.22 /usr/kde/4.0/lib/kd
 3402 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3403 root      20   0  2056  664  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3407 root      20   0  2972 1620 1300 S    0  0.1   0:00.00 -bash              
 3419 root      20   0  2972  992  648 S    0  0.0   0:00.03 -bash              


top - 19:12:29 up 0 min,  1 user,  load average: 0.42, 0.12, 0.04
Tasks:  79 total,   1 running,  78 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.5%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060300k total,    95768k used,  1964532k free,     5528k buffers
Swap:  1214416k total,        0k used,  1214416k free,    54852k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3660 root      20   0  2048  980  768 R    1  0.0   0:00.02 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   51 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   52 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   54 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   55 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  139 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  140 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  141 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
  146 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
  149 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  168 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  169 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  191 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  192 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  193 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  236 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  237 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  856 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  858 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  863 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  865 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  915 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  953 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 1023 root      16  -4  2612 1452  468 S    0  0.1   0:00.34 /sbin/udevd --daemo
 2171 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2173 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2496 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2540 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2549 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2550 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2600 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2602 root      15  -5     0    0    0 S    0  0.0   0:00.02 [kcryptd_io]       
 2603 root      15  -5     0    0    0 S    0  0.0   0:00.67 [kcryptd]          
 2656 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2762 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2934 root      20   0  1920  584  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2935 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2944 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2954 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3023 root      20   0  106m  976  728 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3042 haldaemo  20   0  4772 2932 2272 S    0  0.1   0:00.39 /usr/sbin/hald --us
 3043 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 3089 root      20   0  3144 1108  952 S    0  0.1   0:00.00 hald-addon-input: L
 3091 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3094 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3095 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3100 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3113 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3154 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3165 root      20   0  145m  12m 3512 S    0  0.6   0:00.32 /usr/bin/X -br -nov
 3214 root      20   0  3772 1072  812 S    0  0.1   0:00.00 -:0                
 3219 root      20   0  7040 2292 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3272 root      20   0  1636  444  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3327 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3343 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3357 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3368 root      20   0  1948  388  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3376 root      20   0  2496 1240  916 S    0  0.1   0:00.00 /bin/login --      
 3377 root      20   0  1612  600  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3380 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3381 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3382 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3383 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3398 root      20   0 36612  13m  10m S    0  0.7   0:00.22 /usr/kde/4.0/lib/kd
 3402 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3403 root      20   0  2056  664  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3407 root      20   0  2972 1620 1300 S    0  0.1   0:00.00 -bash              
 3419 root      20   0  2972  992  648 S    0  0.0   0:00.03 -bash              


top - 19:12:30 up 1 min,  1 user,  load average: 0.39, 0.12, 0.04
Tasks:  79 total,   1 running,  78 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060300k total,    95768k used,  1964532k free,     5528k buffers
Swap:  1214416k total,        0k used,  1214416k free,    54860k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3398 root      20   0 36612  13m  10m S    1  0.7   0:00.23 /usr/kde/4.0/lib/kd
 3660 root      20   0  2048  980  768 R    1  0.0   0:00.03 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   51 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   52 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   54 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   55 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  139 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  140 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  141 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
  146 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
  149 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  168 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  169 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  191 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  192 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  193 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  236 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  237 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  856 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  858 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  863 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  865 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  915 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  953 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 1023 root      16  -4  2612 1452  468 S    0  0.1   0:00.34 /sbin/udevd --daemo
 2171 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2173 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2496 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2540 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2549 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2550 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2600 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2602 root      15  -5     0    0    0 S    0  0.0   0:00.02 [kcryptd_io]       
 2603 root      15  -5     0    0    0 S    0  0.0   0:00.67 [kcryptd]          
 2656 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2762 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2934 root      20   0  1920  584  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2935 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2944 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2954 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3023 root      20   0  106m  976  728 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3042 haldaemo  20   0  4772 2932 2272 S    0  0.1   0:00.39 /usr/sbin/hald --us
 3043 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 3089 root      20   0  3144 1108  952 S    0  0.1   0:00.00 hald-addon-input: L
 3091 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3094 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3095 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3100 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3113 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3154 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3165 root      20   0  145m  12m 3512 S    0  0.6   0:00.32 /usr/bin/X -br -nov
 3214 root      20   0  3772 1072  812 S    0  0.1   0:00.00 -:0                
 3219 root      20   0  7040 2292 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3272 root      20   0  1636  444  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3327 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3343 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3357 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3368 root      20   0  1948  388  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3376 root      20   0  2496 1240  916 S    0  0.1   0:00.00 /bin/login --      
 3377 root      20   0  1612  600  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3380 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3381 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3382 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3383 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3402 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3403 root      20   0  2056  664  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3407 root      20   0  2972 1620 1300 S    0  0.1   0:00.00 -bash              
 3419 root      20   0  2972  992  648 S    0  0.0   0:00.03 -bash              


top - 19:12:31 up 1 min,  1 user,  load average: 0.39, 0.12, 0.04
Tasks:  79 total,   1 running,  78 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060300k total,    95768k used,  1964532k free,     5528k buffers
Swap:  1214416k total,        0k used,  1214416k free,    54864k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3660 root      20   0  2048  980  768 R    1  0.0   0:00.04 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.22 init [3]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/0]      
    4 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/0]      
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 [migration/1]      
    6 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksoftirqd/1]      
    7 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/0]         
    8 root      15  -5     0    0    0 S    0  0.0   0:00.00 [events/1]         
    9 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khelper]          
   51 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/0]        
   52 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kblockd/1]        
   54 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpid]           
   55 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kacpi_notify]     
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  138 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  139 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  140 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  141 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
  146 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
  149 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  168 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  169 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  191 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  192 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  193 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  236 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  237 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  856 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  858 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  863 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  865 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  915 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  953 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 1023 root      16  -4  2612 1452  468 S    0  0.1   0:00.34 /sbin/udevd --daemo
 2171 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2173 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2496 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2540 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2549 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2550 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd]          
 2600 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2602 root      15  -5     0    0    0 S    0  0.0   0:00.02 [kcryptd_io]       
 2603 root      15  -5     0    0    0 S    0  0.0   0:00.67 [kcryptd]          
 2656 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2762 root      20   0  1636  472  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2934 root      20   0  1920  584  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2935 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2944 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2954 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3023 root      20   0  106m  976  728 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3042 haldaemo  20   0  4772 2932 2272 S    0  0.1   0:00.39 /usr/sbin/hald --us
 3043 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 3089 root      20   0  3144 1108  952 S    0  0.1   0:00.00 hald-addon-input: L
 3091 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3094 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3095 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3100 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3113 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3154 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3165 root      20   0  145m  12m 3512 S    0  0.6   0:00.32 /usr/bin/X -br -nov
 3214 root      20   0  3772 1072  812 S    0  0.1   0:00.00 -:0                
 3219 root      20   0  7040 2292 1560 S    0  0.1   0:00.15 /usr/sbin/cupsd    
 3272 root      20   0  1636  444  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3327 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3343 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3357 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3368 root      20   0  1948  388  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3376 root      20   0  2496 1240  916 S    0  0.1   0:00.00 /bin/login --      
 3377 root      20   0  1612  600  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3380 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3381 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3382 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3383 root      20   0  1612  604  532 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3398 root      20   0 36612  13m  10m S    0  0.7   0:00.23 /usr/kde/4.0/lib/kd
 3402 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3403 root      20   0  2056  664  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3407 root      20   0  2972 1620 1300 S    0  0.1   0:00.00 -bash              
 3419 root      20   0  2972  992  648 S    0  0.0   0:00.03 -bash              

-- vmstat: --
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1964532   5532  54860    0    0   480     0  115  622  4  4 68 24
 0  0      0 1964532   5532  54892    0    0     0     0   16   44  0  0 100  0
 0  0      0 1964532   5532  54892    0    0     0     0   21   57  0  0 100  0
 0  0      0 1964532   5532  54892    0    0     0     0   16   36  0  0 100  0
 0  0      0 1964532   5532  54892    0    0     0     0   27   56  0  0 100  0
-- sched_debug #0: --
Di 25. Mär 19:12:35 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 65376.115771 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 38979
  .nr_load_updates               : 4517
  .nr_uninterruptible            : 4294967184
  .jiffies                       : 4294896909
  .next_balance                  : 4294.896968
  .curr->pid                     : 0
  .clock                         : 60926.844182
  .idle_clock                    : 51939.958554
  .prev_clock_raw                : 77271.860169
  .clock_warps                   : 0
  .clock_overflows               : 36690
  .clock_underflows              : 1360
  .clock_deep_idle_events        : 14006
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 257
  .cpu_load[3]                   : 139
  .cpu_load[4]                   : 83

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 29855.222436
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 38648
  .nr_load_updates               : 4067
  .nr_uninterruptible            : 112
  .jiffies                       : 4294896909
  .next_balance                  : 4294.896910
  .curr->pid                     : 3663
  .clock                         : 59687.596787
  .idle_clock                    : 55175.803902
  .prev_clock_raw                : 77273.287547
  .clock_warps                   : 0
  .clock_overflows               : 35778
  .clock_underflows              : 1042
  .clock_deep_idle_events        : 15434
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 129
  .cpu_load[4]                   : 90

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 31352.975623
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 1497.753187
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3663     31352.975623         1   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #1: --
Di 25. Mär 19:12:36 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 66425.960515 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 39040
  .nr_load_updates               : 4528
  .nr_uninterruptible            : 4294967184
  .jiffies                       : 4294897224
  .next_balance                  : 4294.897277
  .curr->pid                     : 0
  .clock                         : 61977.325689
  .idle_clock                    : 52983.777627
  .prev_clock_raw                : 77612.965639
  .clock_warps                   : 0
  .clock_overflows               : 36781
  .clock_underflows              : 1362
  .clock_deep_idle_events        : 14043
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 266
  .cpu_load[3]                   : 158
  .cpu_load[4]                   : 102

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 29855.312606
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 38711
  .nr_load_updates               : 4078
  .nr_uninterruptible            : 112
  .jiffies                       : 4294897224
  .next_balance                  : 4294.897226
  .curr->pid                     : 3666
  .clock                         : 60742.398058
  .idle_clock                    : 56217.070962
  .prev_clock_raw                : 77612.850982
  .clock_warps                   : 0
  .clock_overflows               : 35830
  .clock_underflows              : 1047
  .clock_deep_idle_events        : 15470
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 9
  .cpu_load[3]                   : 27
  .cpu_load[4]                   : 41

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 31453.031754
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 1597.719148
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3666     31453.031754         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #2: --
Di 25. Mär 19:12:37 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 67431.198331 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 39075
  .nr_load_updates               : 4537
  .nr_uninterruptible            : 4294967184
  .jiffies                       : 4294897526
  .next_balance                  : 4294.897586
  .curr->pid                     : 0
  .clock                         : 62984.066228
  .idle_clock                    : 53986.890600
  .prev_clock_raw                : 77982.566134
  .clock_warps                   : 0
  .clock_overflows               : 36842
  .clock_underflows              : 1362
  .clock_deep_idle_events        : 14069
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 275
  .cpu_load[3]                   : 174
  .cpu_load[4]                   : 119

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 29935.468616
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 38764
  .nr_load_updates               : 4089
  .nr_uninterruptible            : 112
  .jiffies                       : 4294897526
  .next_balance                  : 4294.897568
  .curr->pid                     : 3669
  .clock                         : 61747.255259
  .idle_clock                    : 57211.584039
  .prev_clock_raw                : 77982.553662
  .clock_warps                   : 0
  .clock_overflows               : 35891
  .clock_underflows              : 1052
  .clock_deep_idle_events        : 15494
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 133
  .cpu_load[4]                   : 81

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 31473.256881
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 1537.788265
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3669     31473.256881         3   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #3: --
Di 25. Mär 19:12:38 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 68436.429652 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 39106
  .nr_load_updates               : 4545
  .nr_uninterruptible            : 4294967184
  .jiffies                       : 4294897827
  .next_balance                  : 4294.897878
  .curr->pid                     : 0
  .clock                         : 63988.383803
  .idle_clock                    : 54987.543351
  .prev_clock_raw                : 78281.514265
  .clock_warps                   : 0
  .clock_overflows               : 36896
  .clock_underflows              : 1363
  .clock_deep_idle_events        : 14097
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 514
  .cpu_load[2]                   : 283
  .cpu_load[3]                   : 187
  .cpu_load[4]                   : 133

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 29975.604801
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 38818
  .nr_load_updates               : 4100
  .nr_uninterruptible            : 112
  .jiffies                       : 4294897827
  .next_balance                  : 4294.897878
  .curr->pid                     : 3672
  .clock                         : 62756.694589
  .idle_clock                    : 58205.887866
  .prev_clock_raw                : 78282.505996
  .clock_warps                   : 0
  .clock_overflows               : 35923
  .clock_underflows              : 1058
  .clock_deep_idle_events        : 15519
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 266
  .cpu_load[3]                   : 156
  .cpu_load[4]                   : 101

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 31513.326569
  .min_vruntime                  : 31513.326569
  .max_vruntime                  : 31513.326569
  .spread                        : 0.000000
  .spread0                       : 1537.721768
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3419     31513.326569       282   120               0               0               0.000000               0.000000               0.000000
R            cat  3672     31493.435473         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #4: --
Di 25. Mär 19:12:39 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #8
now at 69441.723900 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.980 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 39144
  .nr_load_updates               : 4554
  .nr_uninterruptible            : 4294967184
  .jiffies                       : 4294898129
  .next_balance                  : 4294.898189
  .curr->pid                     : 0
  .clock                         : 64993.191151
  .idle_clock                    : 55988.424324
  .prev_clock_raw                : 78646.684376
  .clock_warps                   : 0
  .clock_overflows               : 36961
  .clock_underflows              : 1364
  .clock_deep_idle_events        : 14122
  .clock_max_delta               : 3.333100
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 277
  .cpu_load[3]                   : 183
  .cpu_load[4]                   : 136

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 30016.618718
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.980 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 38860
  .nr_load_updates               : 4109
  .nr_uninterruptible            : 112
  .jiffies                       : 4294898129
  .next_balance                  : 4294.898168
  .curr->pid                     : 3675
  .clock                         : 63765.252136
  .idle_clock                    : 59203.554201
  .prev_clock_raw                : 78646.681656
  .clock_warps                   : 0
  .clock_overflows               : 35961
  .clock_underflows              : 1062
  .clock_deep_idle_events        : 15543
  .clock_max_delta               : 3.333034
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 275
  .cpu_load[3]                   : 174
  .cpu_load[4]                   : 118

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 31593.338769
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 1576.720051
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3675     31593.338769         1   120               0               0               0.000000               0.000000               0.000000


--------------050702060803040204020008--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbYCXTfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbYCXTfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 15:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbYCXTfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 15:35:22 -0400
Received: from www17.your-server.de ([213.133.104.17]:58844 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762565AbYCXTfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 15:35:00 -0400
Message-ID: <47E80247.8090702@m3y3r.de>
Date: Mon, 24 Mar 2008 20:34:31 +0100
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
References: <200803220259.48534.rjw@sisk.pl> <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de> <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de> <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org> <alpine.LFD.1.00.0803221558450.3020@woody.linux-foundation.org> <47E59B39.90306@s5r6.in-berlin.de> <20080323063524.GA13018@elte.hu>
In-Reply-To: <20080323063524.GA13018@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010906040507050200020509"
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010906040507050200020509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar schrieb:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>
>   
>> On my x86-32 test system, none of the devices gets an MMIO region 
>> above the 4G map.  (Reconfigured with CONFIG_RESOURCES_64BIT=y while 
>> having CONFIG_HIGHMEM4G=y, like in Thomas M's .config.)
>>     
>
> 64-bit ioremap on x86 never worked AFAIK, the whole API is using 32-bit 
> physical addresses which is limited to 4GB. But ... this bug does have 
> the feeling of the wrong IO side physical memory being mapped. (0xff 
> data means there's no device there - typical of non-existent RAM/IO)
>
> could you please pull the x86/latest tree to do a kernel pagetable dump 
> for us? You can pull it via the instructions here:
>
>    http://people.redhat.com/mingo/x86.git/README
>
> then enable CONFIG_DEBUG_KERNEL=y and CONFIG_X86_PTDUMP=y boot the 
> kernel so that ohci1394 doesnt work. Then dump the pagetables and other 
> hw info via:
>
>    http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
>
> send us the cfs-debug-info file that gets generated. We'll be able to 
> tell from that whether your ioremap's are OK. (x86/latest will also 
> printk all ioremap()s and results that are done)
>
>   
See attached file.




--------------010906040507050200020509
Content-Type: text/plain;
 name="cfs-debug-info-2008.03.24-20.18.20"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="cfs-debug-info-2008.03.24-20.18.20"

-- /proc/sched_debug: --
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 94399.779093 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 40091
  .nr_load_updates               : 5149
  .nr_uninterruptible            : 4294967205
  .jiffies                       : 4294905616
  .next_balance                  : 4294.905648
  .curr->pid                     : 3371
  .clock                         : 92257.424189
  .idle_clock                    : 83230.797051
  .prev_clock_raw                : 82315.289815
  .clock_warps                   : 0
  .clock_overflows               : 69482
  .clock_underflows              : 1406
  .clock_deep_idle_events        : 15968
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 2
  .cpu_load[2]                   : 24
  .cpu_load[3]                   : 43
  .cpu_load[4]                   : 45

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 27937.237378
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3371     27937.237378         1   120               0               0               0.000000               0.000000               0.000000

cpu#1, 1830.936 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 43563
  .nr_load_updates               : 5316
  .nr_uninterruptible            : 91
  .jiffies                       : 4294905616
  .next_balance                  : 4294.905608
  .curr->pid                     : 0
  .clock                         : 91313.014973
  .idle_clock                    : 85009.960800
  .prev_clock_raw                : 82315.417010
  .clock_warps                   : 0
  .clock_overflows               : 35106
  .clock_underflows              : 1708
  .clock_deep_idle_events        : 17228
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 4
  .cpu_load[2]                   : 50
  .cpu_load[3]                   : 91
  .cpu_load[4]                   : 105

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 26797.350306
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1139.887072
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

-- /proc/*/task/*/sched: --
cqueue/0 (129, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           300.062485
se.vruntime                        :           178.379572
se.sum_exec_runtime                :             0.003939
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  216
cqueue/1 (130, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            55.712362
se.vruntime                        :           852.085127
se.sum_exec_runtime                :             0.004401
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
ata/0 (134, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         17298.625635
se.vruntime                        :         22800.915560
se.sum_exec_runtime                :             0.987497
se.avg_overlap                     :             0.000200
nr_switches                        :                   60
nr_voluntary_switches              :                   60
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
ata/1 (135, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         24049.104875
se.vruntime                        :         24258.516921
se.sum_exec_runtime                :             1.852584
se.avg_overlap                     :             0.000346
nr_switches                        :                   20
nr_voluntary_switches              :                   20
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
ata_aux (136, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            55.935594
se.vruntime                        :           911.146890
se.sum_exec_runtime                :             0.004023
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kseriod (138, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           343.896367
se.vruntime                        :           930.835537
se.sum_exec_runtime                :             0.008546
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
se.exec_start                      :         92203.377477
se.vruntime                        :         27857.042407
se.sum_exec_runtime                :             3.708248
se.avg_overlap                     :             0.005593
nr_switches                        :                  805
nr_voluntary_switches              :                  805
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
kondemand/1 (158, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91253.834128
se.vruntime                        :         26600.102238
se.sum_exec_runtime                :             4.164270
se.avg_overlap                     :             0.002693
nr_switches                        :                  744
nr_voluntary_switches              :                  744
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
pdflush (180, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           113.247815
se.vruntime                        :          1127.756771
se.sum_exec_runtime                :             0.004816
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
pdflush (181, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         22652.851471
se.vruntime                        :         24494.728503
se.sum_exec_runtime                :             0.043563
se.avg_overlap                     :             0.000000
nr_switches                        :                    7
nr_voluntary_switches              :                    7
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
kswapd0 (182, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           113.418171
se.vruntime                        :          1154.005917
se.sum_exec_runtime                :             0.004011
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
khpsbpkt (1892, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1402.319806
se.vruntime                        :          7757.350445
se.sum_exec_runtime                :             0.000002
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
ksuspend_usbd (1988, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          6815.900494
se.vruntime                        :         11151.341366
se.sum_exec_runtime                :             0.018227
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  210
khubd (1989, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5386.175031
se.vruntime                        :         15520.465165
se.sum_exec_runtime                :             3.149699
se.avg_overlap                     :             0.017224
nr_switches                        :                  136
nr_voluntary_switches              :                  135
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
init (1, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         88903.388100
se.vruntime                        :         27680.867365
se.sum_exec_runtime                :           228.456646
se.avg_overlap                     :             0.008611
nr_switches                        :                 1311
nr_voluntary_switches              :                 1306
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
aio/0 (225, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           359.638233
se.vruntime                        :           939.852775
se.sum_exec_runtime                :             0.003993
se.avg_overlap                     :             0.000046
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
aio/1 (226, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           115.439042
se.vruntime                        :          1147.445413
se.sum_exec_runtime                :             0.002126
se.avg_overlap                     :             0.000045
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_4 (2303, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          4558.028026
se.vruntime                        :         11894.279805
se.sum_exec_runtime                :             0.009446
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
usb-storage (2305, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91435.219321
se.vruntime                        :         27817.040001
se.sum_exec_runtime                :             1.630495
se.avg_overlap                     :             0.000050
nr_switches                        :                  458
nr_voluntary_switches              :                  458
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
applesmc-led (2319, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          4364.098358
se.vruntime                        :         15470.649982
se.sum_exec_runtime                :             0.009055
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
kdmflush (2442, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5775.929653
se.vruntime                        :         16084.651344
se.sum_exec_runtime                :             0.007154
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
kcryptd_io (2451, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         10350.218835
se.vruntime                        :         17501.051716
se.sum_exec_runtime                :             1.122081
se.avg_overlap                     :             0.000000
nr_switches                        :                   43
nr_voluntary_switches              :                   43
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd (2452, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         10374.107861
se.vruntime                        :         16161.698138
se.sum_exec_runtime                :            20.322847
se.avg_overlap                     :             1.031395
nr_switches                        :                   45
nr_voluntary_switches              :                   45
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kdmflush (2484, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          9594.946132
se.vruntime                        :         13424.663291
se.sum_exec_runtime                :             0.009610
se.avg_overlap                     :             0.001201
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd_io (2486, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91301.931741
se.vruntime                        :         26573.152584
se.sum_exec_runtime                :            52.078256
se.avg_overlap                     :             0.024380
nr_switches                        :                 2203
nr_voluntary_switches              :                 2203
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
kcryptd (2488, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         92257.306442
se.vruntime                        :         26959.563891
se.sum_exec_runtime                :           744.306801
se.avg_overlap                     :             0.007436
nr_switches                        :                 1937
nr_voluntary_switches              :                 1937
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kjournald (2559, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         10095.923209
se.vruntime                        :         14277.375136
se.sum_exec_runtime                :             0.015985
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  199
ifplugd (2665, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         90647.383386
se.vruntime                        :         26587.001239
se.sum_exec_runtime                :             2.336422
se.avg_overlap                     :             0.034574
nr_switches                        :                   84
nr_voluntary_switches              :                   83
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
metalog (2837, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         89241.213795
se.vruntime                        :         26573.102642
se.sum_exec_runtime                :           399.753392
se.avg_overlap                     :             0.095092
nr_switches                        :                 2184
nr_voluntary_switches              :                 1933
nr_involuntary_switches            :                  251
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
metalog (2838, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         55516.774813
se.vruntime                        :         25955.214107
se.sum_exec_runtime                :            66.983792
se.avg_overlap                     :             0.001582
nr_switches                        :                 2113
nr_voluntary_switches              :                 2101
nr_involuntary_switches            :                   12
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
acpid (2847, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         19817.016748
se.vruntime                        :         22685.044796
se.sum_exec_runtime                :             0.210433
se.avg_overlap                     :             0.006197
nr_switches                        :                   10
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
dbus-daemon (2857, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         76616.033715
se.vruntime                        :         27515.374442
se.sum_exec_runtime                :            12.292620
se.avg_overlap                     :             0.032102
nr_switches                        :                  175
nr_voluntary_switches              :                  175
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
nscd (2926, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91219.953150
se.vruntime                        :         26697.249599
se.sum_exec_runtime                :             8.011867
se.avg_overlap                     :             0.003495
nr_switches                        :                  423
nr_voluntary_switches              :                  401
nr_involuntary_switches            :                   22
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
nscd (2927, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91218.230440
se.vruntime                        :         26697.298991
se.sum_exec_runtime                :             1.582155
se.avg_overlap                     :             0.043482
nr_switches                        :                   47
nr_voluntary_switches              :                   47
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
nscd (2928, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91219.982244
se.vruntime                        :         26697.328151
se.sum_exec_runtime                :             2.618633
se.avg_overlap                     :             0.061193
nr_switches                        :                   45
nr_voluntary_switches              :                   45
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2929, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91219.895401
se.vruntime                        :         26697.312094
se.sum_exec_runtime                :             1.647652
se.avg_overlap                     :             0.046315
nr_switches                        :                   47
nr_voluntary_switches              :                   47
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  210
nscd (2930, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91219.136961
se.vruntime                        :         26697.547164
se.sum_exec_runtime                :             1.858334
se.avg_overlap                     :             0.070436
nr_switches                        :                   40
nr_voluntary_switches              :                   37
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
nscd (2931, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91219.513227
se.vruntime                        :         26697.305778
se.sum_exec_runtime                :             2.244967
se.avg_overlap                     :             0.057223
nr_switches                        :                   40
nr_voluntary_switches              :                   38
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
nscd (2932, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91218.771696
se.vruntime                        :         26697.031827
se.sum_exec_runtime                :             1.692975
se.avg_overlap                     :             0.021838
nr_switches                        :                   37
nr_voluntary_switches              :                   37
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
nscd (2933, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91218.693902
se.vruntime                        :         26697.047030
se.sum_exec_runtime                :             1.666897
se.avg_overlap                     :             0.011112
nr_switches                        :                   41
nr_voluntary_switches              :                   41
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
nscd (2934, #threads: 9)
---------------------------------------------------------
se.exec_start                      :         91218.610663
se.vruntime                        :         26697.339337
se.sum_exec_runtime                :             1.564207
se.avg_overlap                     :             0.044063
nr_switches                        :                   40
nr_voluntary_switches              :                   40
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
hald (2945, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         76616.073498
se.vruntime                        :         27535.398133
se.sum_exec_runtime                :           398.187676
se.avg_overlap                     :             0.026509
nr_switches                        :                 1631
nr_voluntary_switches              :                 1404
nr_involuntary_switches            :                  227
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
hald-runner (2946, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         24487.947375
se.vruntime                        :         25620.637585
se.sum_exec_runtime                :             8.687608
se.avg_overlap                     :             0.071028
nr_switches                        :                   95
nr_voluntary_switches              :                   86
nr_involuntary_switches            :                    9
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
hald-addon-inpu (2992, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91214.140446
se.vruntime                        :         26597.075342
se.sum_exec_runtime                :             3.251403
se.avg_overlap                     :             0.003331
nr_switches                        :                  470
nr_voluntary_switches              :                  468
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-addon-macb (2994, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         16282.873360
se.vruntime                        :         20913.410001
se.sum_exec_runtime                :             3.169941
se.avg_overlap                     :             0.188240
nr_switches                        :                   16
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    8
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
hald-addon-cpuf (2997, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         16560.869329
se.vruntime                        :         21054.904762
se.sum_exec_runtime                :             0.677660
se.avg_overlap                     :             0.017022
nr_switches                        :                   19
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                   11
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
hald-addon-acpi (2998, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         16559.577409
se.vruntime                        :         21054.649911
se.sum_exec_runtime                :             1.008621
se.avg_overlap                     :             0.041561
nr_switches                        :                   19
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                   14
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
kthreadd (2, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         55622.035881
se.vruntime                        :         26001.683039
se.sum_exec_runtime                :             1.298085
se.avg_overlap                     :             0.002191
nr_switches                        :                  235
nr_voluntary_switches              :                  190
nr_involuntary_switches            :                   45
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
hald-addon-stor (3005, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91435.219324
se.vruntime                        :         27843.881185
se.sum_exec_runtime                :             3.795506
se.avg_overlap                     :             0.000521
nr_switches                        :                  128
nr_voluntary_switches              :                   88
nr_involuntary_switches            :                   40
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
dhcpcd (3009, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         16939.658695
se.vruntime                        :         21325.102321
se.sum_exec_runtime                :             0.000001
se.avg_overlap                     :             0.000000
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm (3057, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26829.365148
se.vruntime                        :         25223.225880
se.sum_exec_runtime                :             1.440048
se.avg_overlap                     :             0.042988
nr_switches                        :                  165
nr_voluntary_switches              :                  164
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
X (3064, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91296.847799
se.vruntime                        :         26717.918338
se.sum_exec_runtime                :           369.752831
se.avg_overlap                     :             0.489679
nr_switches                        :                 4726
nr_voluntary_switches              :                 4388
nr_involuntary_switches            :                  338
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm (3101, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34119.599173
se.vruntime                        :         25728.715539
se.sum_exec_runtime                :             2.988994
se.avg_overlap                     :             0.007866
nr_switches                        :                  137
nr_voluntary_switches              :                  123
nr_involuntary_switches            :                   14
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
cupsd (3122, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         23659.180943
se.vruntime                        :         24028.434228
se.sum_exec_runtime                :           154.674208
se.avg_overlap                     :             1.350211
nr_switches                        :                  119
nr_voluntary_switches              :                   84
nr_involuntary_switches            :                   35
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
ifplugd (3175, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         86960.527904
se.vruntime                        :         27680.827036
se.sum_exec_runtime                :             0.501382
se.avg_overlap                     :             0.009980
nr_switches                        :                   16
nr_voluntary_switches              :                   13
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
pktcdvd0 (3231, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         24573.245196
se.vruntime                        :         25821.148517
se.sum_exec_runtime                :             0.013072
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                88761
policy                             :                    0
prio                               :                  100
clock-delta                        :                  187
smartd (3247, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         24664.587503
se.vruntime                        :         24409.143015
se.sum_exec_runtime                :             0.961574
se.avg_overlap                     :             0.030904
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
sshd (3261, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25018.196575
se.vruntime                        :         24612.836701
se.sum_exec_runtime                :             0.272191
se.avg_overlap                     :             0.001107
nr_switches                        :                    4
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
cron (3272, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         72045.449119
se.vruntime                        :         24803.395700
se.sum_exec_runtime                :             0.763954
se.avg_overlap                     :             0.002182
nr_switches                        :                   18
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3283, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26531.245661
se.vruntime                        :         25070.977132
se.sum_exec_runtime                :             0.000017
se.avg_overlap                     :             0.000000
nr_switches                        :                   13
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  186
agetty (3284, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26531.245673
se.vruntime                        :         25094.303656
se.sum_exec_runtime                :             0.590454
se.avg_overlap                     :             0.000406
nr_switches                        :                   12
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
agetty (3285, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26531.245668
se.vruntime                        :         25084.306106
se.sum_exec_runtime                :             0.795418
se.avg_overlap                     :             0.085450
nr_switches                        :                   12
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  199
agetty (3286, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         27106.070478
se.vruntime                        :         26775.766087
se.sum_exec_runtime                :             0.907636
se.avg_overlap                     :             0.081546
nr_switches                        :                   12
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  211
agetty (3287, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         26531.245676
se.vruntime                        :         25094.303659
se.sum_exec_runtime                :             0.756721
se.avg_overlap                     :             0.000000
nr_switches                        :                   11
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm_greet (3306, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         91277.574551
se.vruntime                        :         26717.393708
se.sum_exec_runtime                :           305.244748
se.avg_overlap                     :             0.059619
nr_switches                        :                 1444
nr_voluntary_switches              :                  881
nr_involuntary_switches            :                  563
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kdm_greet (3312, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         35395.257468
se.vruntime                        :         27205.702253
se.sum_exec_runtime                :             0.132067
se.avg_overlap                     :             0.000000
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
dbus-launch (3310, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         31018.885805
se.vruntime                        :         26982.348619
se.sum_exec_runtime                :             0.520316
se.avg_overlap                     :             0.004775
nr_switches                        :                   19
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                   17
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-daemon (3311, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         30025.169976
se.vruntime                        :         25274.696899
se.sum_exec_runtime                :             2.023242
se.avg_overlap                     :             0.059586
nr_switches                        :                   15
nr_voluntary_switches              :                   15
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
login (3344, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         77747.505572
se.vruntime                        :         26412.109129
se.sum_exec_runtime                :             8.418106
se.avg_overlap                     :             0.006438
nr_switches                        :                   45
nr_voluntary_switches              :                   42
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3352, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         88878.503305
se.vruntime                        :         27714.200895
se.sum_exec_runtime                :            11.235751
se.avg_overlap                     :             0.299776
nr_switches                        :                   36
nr_voluntary_switches              :                   31
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
su (3361, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         89273.870049
se.vruntime                        :         26613.202281
se.sum_exec_runtime                :             3.997820
se.avg_overlap                     :             0.017609
nr_switches                        :                   43
nr_voluntary_switches              :                   16
nr_involuntary_switches            :                   27
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
bash (3362, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91214.140448
se.vruntime                        :         26656.974863
se.sum_exec_runtime                :             6.131206
se.avg_overlap                     :             0.175985
nr_switches                        :                   15
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                    6
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  204
bash (3366, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         92262.098541
se.vruntime                        :         27928.791947
se.sum_exec_runtime                :             5.666298
se.avg_overlap                     :             0.122212
nr_switches                        :                   13
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
migration/0 (3, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :             0.005155
se.sum_exec_runtime                :             0.604839
se.avg_overlap                     :             0.000000
nr_switches                        :                  289
nr_voluntary_switches              :                  289
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  186
kblockd/0 (46, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         88884.498577
se.vruntime                        :         27455.012819
se.sum_exec_runtime                :            12.016598
se.avg_overlap                     :             0.019523
nr_switches                        :                  629
nr_voluntary_switches              :                  629
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kblockd/1 (47, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91282.653038
se.vruntime                        :         26391.400508
se.sum_exec_runtime                :             3.667978
se.avg_overlap                     :             0.000000
nr_switches                        :                  102
nr_voluntary_switches              :                  102
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kacpid (49, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         76610.044343
se.vruntime                        :         27507.278000
se.sum_exec_runtime                :             3.819380
se.avg_overlap                     :             0.017815
nr_switches                        :                  557
nr_voluntary_switches              :                  556
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
ksoftirqd/0 (4, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         92262.134072
se.vruntime                        :         27843.887051
se.sum_exec_runtime                :            14.610559
se.avg_overlap                     :             0.000159
nr_switches                        :                 6264
nr_voluntary_switches              :                 6263
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
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
se.sum_exec_runtime                :             0.663105
se.avg_overlap                     :             0.000000
nr_switches                        :                  268
nr_voluntary_switches              :                  268
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  199
ksoftirqd/1 (6, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         91315.083399
se.vruntime                        :         26586.981718
se.sum_exec_runtime                :            12.153289
se.avg_overlap                     :             0.001821
nr_switches                        :                 6046
nr_voluntary_switches              :                 6046
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  211
events/0 (7, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         92203.377476
se.vruntime                        :         27843.922624
se.sum_exec_runtime                :             9.016214
se.avg_overlap                     :             0.001128
nr_switches                        :                  903
nr_voluntary_switches              :                  902
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
scsi_eh_0 (845, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          2257.442778
se.vruntime                        :         12334.945321
se.sum_exec_runtime                :             0.770356
se.avg_overlap                     :             0.001336
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_1 (847, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           298.347544
se.vruntime                        :          2803.413061
se.sum_exec_runtime                :             3.441481
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
scsi_eh_2 (852, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           549.964426
se.vruntime                        :          5907.936493
se.sum_exec_runtime                :            15.321132
se.avg_overlap                     :             0.000355
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
scsi_eh_3 (854, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           336.645408
se.vruntime                        :          2861.354545
se.sum_exec_runtime                :             3.335060
se.avg_overlap                     :             0.000000
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kstriped (875, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           344.024445
se.vruntime                        :          2920.417706
se.sum_exec_runtime                :             0.004324
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
kjournald (881, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           353.311078
se.vruntime                        :          2933.541256
se.sum_exec_runtime                :             0.000003
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
events/1 (8, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         90647.353704
se.vruntime                        :         26586.967628
se.sum_exec_runtime                :             2.696162
se.avg_overlap                     :             0.007269
nr_switches                        :                  109
nr_voluntary_switches              :                  109
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  186
udevd (951, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         68816.718141
se.vruntime                        :         27547.215557
se.sum_exec_runtime                :           374.175537
se.avg_overlap                     :             0.317171
nr_switches                        :                  994
nr_voluntary_switches              :                  269
nr_involuntary_switches            :                  725
se.load.weight                     :                 2501
policy                             :                    0
prio                               :                  116
clock-delta                        :                  198
khelper (9, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         25012.713939
se.vruntime                        :         24618.315812
se.sum_exec_runtime                :             6.567657
se.avg_overlap                     :             0.001275
nr_switches                        :                 1756
nr_voluntary_switches              :                 1740
nr_involuntary_switches            :                   16
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
appletouch             10240  0 
usbhid                 23716  0 
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
uhci_hcd               25232  0 
firewire_ohci          19200  0 
ehci_hcd               35980  0 
usbcore               144496  6 appletouch,usbhid,usb_storage,uhci_hcd,ehci_hcd
i2c_i801               10128  0 
snd_hda_intel         339380  0 
rng_core                5252  0 
iTCO_wdt               11812  0 
firewire_core          43584  1 firewire_ohci
evdev                  12160  7 
snd_pcm                69764  1 snd_hda_intel
snd_timer              23432  2 snd_seq,snd_pcm
ieee1394               90164  0 
snd                    48628  5 snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
soundcore               8032  1 snd
snd_page_alloc         10632  2 snd_hda_intel,snd_pcm
battery                13188  0 
thermal                18972  0 
ac                      6148  0 
button                  8336  0 
intel_agp              27076  0 
sg                     32820  0 
tpm_infineon            9640  0 
tpm                    15936  1 tpm_infineon
tpm_bios                7168  1 tpm
i2c_core               24852  2 eeprom,i2c_i801
processor              39112  4 acpi_cpufreq,thermal
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
0xf8842000-0xf8844000           8K                           pte
0xf8844000-0xf8845000           4K     RW PWT PCD     GLB x  pte
0xf8845000-0xf8846000           4K                           pte
0xf8846000-0xf8847000           4K     RW PWT PCD     GLB x  pte
0xf8847000-0xf8848000           4K                           pte
0xf8848000-0xf8849000           4K     RW PWT PCD     GLB x  pte
0xf8849000-0xf884a000           4K                           pte
0xf884a000-0xf884b000           4K     RW PWT PCD     GLB x  pte
0xf884b000-0xf884c000           4K                           pte
0xf884c000-0xf884f000          12K     RW             GLB x  pte
0xf884f000-0xf8850000           4K                           pte
0xf8850000-0xf8852000           8K     RW             GLB x  pte
0xf8852000-0xf8853000           4K                           pte
0xf8853000-0xf8854000           4K     RW             GLB x  pte
0xf8854000-0xf8855000           4K                           pte
0xf8855000-0xf885c000          28K     RW             GLB x  pte
0xf885c000-0xf885d000           4K                           pte
0xf885d000-0xf8862000          20K     RW             GLB x  pte
0xf8862000-0xf8863000           4K                           pte
0xf8863000-0xf8867000          16K     RW             GLB x  pte
0xf8867000-0xf8868000           4K                           pte
0xf8868000-0xf886b000          12K     RW             GLB x  pte
0xf886b000-0xf886c000           4K                           pte
0xf886c000-0xf886e000           8K     RW             GLB x  pte
0xf886e000-0xf886f000           4K                           pte
0xf886f000-0xf8872000          12K     RW             GLB x  pte
0xf8872000-0xf8873000           4K                           pte
0xf8873000-0xf887c000          36K     RW             GLB x  pte
0xf887c000-0xf887d000           4K                           pte
0xf887d000-0xf8884000          28K     RW             GLB x  pte
0xf8884000-0xf8886000           8K                           pte
0xf8886000-0xf8887000           4K     RW PWT PCD     GLB x  pte
0xf8887000-0xf888b000          16K                           pte
0xf888b000-0xf888f000          16K     RW             GLB x  pte
0xf888f000-0xf8890000           4K                           pte
0xf8890000-0xf8892000           8K     RW             GLB x  pte
0xf8892000-0xf8893000           4K                           pte
0xf8893000-0xf8896000          12K     RW             GLB x  pte
0xf8896000-0xf8897000           4K                           pte
0xf8897000-0xf889a000          12K     RW             GLB x  pte
0xf889a000-0xf889c000           8K                           pte
0xf889c000-0xf88a2000          24K     RW             GLB x  pte
0xf88a2000-0xf88a3000           4K                           pte
0xf88a3000-0xf88af000          48K     RW             GLB x  pte
0xf88af000-0xf88b0000           4K                           pte
0xf88b0000-0xf88b1000           4K     RW PWT PCD     GLB x  pte
0xf88b1000-0xf88b3000           8K                           pte
0xf88b3000-0xf88b5000           8K     RW             GLB x  pte
0xf88b5000-0xf88b6000           4K                           pte
0xf88b6000-0xf88b7000           4K     RW             GLB x  pte
0xf88b7000-0xf88b8000           4K                           pte
0xf88b8000-0xf88b9000           4K     RW             GLB x  pte
0xf88b9000-0xf88c5000          48K                           pte
0xf88c5000-0xf88c8000          12K     RW             GLB x  pte
0xf88c8000-0xf88c9000           4K                           pte
0xf88c9000-0xf88cb000           8K     RW             GLB x  pte
0xf88cb000-0xf88cc000           4K                           pte
0xf88cc000-0xf88e3000          92K     RW             GLB x  pte
0xf88e3000-0xf88e4000           4K                           pte
0xf88e4000-0xf88f6000          72K     RW             GLB x  pte
0xf88f6000-0xf88f8000           8K                           pte
0xf88f8000-0xf88fc000          16K     RW PWT PCD     GLB x  pte
0xf88fc000-0xf88fd000           4K                           pte
0xf88fd000-0xf8904000          28K     RW             GLB x  pte
0xf8904000-0xf8905000           4K                           pte
0xf8905000-0xf8910000          44K     RW             GLB x  pte
0xf8910000-0xf8911000           4K                           pte
0xf8911000-0xf8916000          20K     RW             GLB x  pte
0xf8916000-0xf8917000           4K                           pte
0xf8917000-0xf891a000          12K     RW             GLB x  pte
0xf891a000-0xf891b000           4K                           pte
0xf891b000-0xf891c000           4K     RW             GLB x  pte
0xf891c000-0xf891d000           4K                           pte
0xf891d000-0xf8926000          36K     RW             GLB x  pte
0xf8926000-0xf8927000           4K                           pte
0xf8927000-0xf893b000          80K     RW             GLB x  pte
0xf893b000-0xf893d000           8K                           pte
0xf893d000-0xf8961000         144K     RW             GLB x  pte
0xf8961000-0xf8962000           4K                           pte
0xf8962000-0xf8965000          12K     RW             GLB x  pte
0xf8965000-0xf8966000           4K                           pte
0xf8966000-0xf8968000           8K     RW             GLB x  pte
0xf8968000-0xf8969000           4K                           pte
0xf8969000-0xf896b000           8K     RW             GLB x  pte
0xf896b000-0xf896c000           4K                           pte
0xf896c000-0xf896e000           8K     RW             GLB x  pte
0xf896e000-0xf896f000           4K                           pte
0xf896f000-0xf8971000           8K     RW             GLB x  pte
0xf8971000-0xf8975000          16K                           pte
0xf8975000-0xf8977000           8K     RW             GLB x  pte
0xf8977000-0xf8979000           8K                           pte
0xf8979000-0xf897e000          20K     RW             GLB x  pte
0xf897e000-0xf897f000           4K                           pte
0xf897f000-0xf89d2000         332K     RW             GLB x  pte
0xf89d2000-0xf89d3000           4K                           pte
0xf89d3000-0xf89d6000          12K     RW             GLB x  pte
0xf89d6000-0xf89d7000           4K                           pte
0xf89d7000-0xf89d9000           8K     RW             GLB x  pte
0xf89d9000-0xf89da000           4K                           pte
0xf89da000-0xf89de000          16K     RW             GLB x  pte
0xf89de000-0xf89df000           4K                           pte
0xf89df000-0xf89e8000          36K     RW             GLB x  pte
0xf89e8000-0xf89e9000           4K                           pte
0xf89e9000-0xf89ec000          12K     RW             GLB x  pte
0xf89ec000-0xf89ed000           4K                           pte
0xf89ed000-0xf89ef000           8K     RW             GLB x  pte
0xf89ef000-0xf89f2000          12K                           pte
0xf89f2000-0xf89f8000          24K     RW             GLB x  pte
0xf89f8000-0xf89f9000           4K                           pte
0xf89f9000-0xf89ff000          24K     RW             GLB x  pte
0xf89ff000-0xf8a00000           4K                           pte
0xf8a00000-0xf8a02000           8K     RW             GLB x  pte
0xf8a02000-0xf8a03000           4K                           pte
0xf8a03000-0xf8a06000          12K     RW             GLB x  pte
0xf8a06000-0xf8a07000           4K                           pte
0xf8a07000-0xf8a0a000          12K     RW             GLB x  pte
0xf8a0a000-0xf8a10000          24K                           pte
0xf8a10000-0xf8a1d000          52K     RW             GLB x  pte
0xf8a1d000-0xf8a1e000           4K                           pte
0xf8a1e000-0xf8ab3000         596K     RW             GLB x  pte
0xf8ab3000-0xf8ac5000          72K                           pte
0xf8ac5000-0xf8ad2000          52K     RW             GLB x  pte
0xf8ad2000-0xf8ad3000           4K                           pte
0xf8ad3000-0xf8ae0000          52K     RW             GLB x  pte
0xf8ae0000-0xf8c00000        1152K                           pte
0xf8c00000-0xff800000         108M                           pgd
---[ vmalloc() End ]---
0xff800000-0xff801000           4K                           pte
---[ Persisent kmap() Area ]---
0xff801000-0xffae9000        2976K     RW             GLB x  pte
0xffae9000-0xfff9b000        4808K                           pte
---[ Fixmap Area ]---
0xfff9b000-0xfff9c000           4K                           pte
0xfff9c000-0xfff9d000           4K     RW PWT PCD     GLB x  pte
0xfff9d000-0xfff9e000           4K     RW             GLB x  pte
0xfff9e000-0xffffa000         368K                           pte
0xffffa000-0xffffc000           8K     RW PWT PCD     GLB x  pte
0xffffc000-0x00000000          16K                           pte
-- interrupts: --
           CPU0       CPU1       
  0:       8163          0   IO-APIC-edge      timer
  9:       2923          0   IO-APIC-fasteoi   acpi
 14:         85          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         41          0   IO-APIC-fasteoi   uhci_hcd:usb5
 18:         39          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:       4042          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb3
 22:        297          0   IO-APIC-fasteoi   HDA Intel
 23:       1030          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
219:         12          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:       2303      10284   Local timer interrupts
RES:       1741       5017   Rescheduling interrupts
CAL:        184        144   function call interrupts
TLB:        207        278   TLB shootdowns
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx constant_tsc arch_perfmon bts pni monitor vmx est tm2 xtpr
bogomips	: 3663.35
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
MemFree:       1960696 kB
Buffers:          5612 kB
Cached:          58044 kB
SwapCached:          0 kB
Active:          39964 kB
Inactive:        42260 kB
HighTotal:     1164064 kB
HighFree:      1084704 kB
LowTotal:       896396 kB
LowFree:        875992 kB
SwapTotal:     1214416 kB
SwapFree:      1214416 kB
Dirty:            3504 kB
Writeback:           0 kB
AnonPages:       18408 kB
Mapped:          18460 kB
Slab:             9932 kB
SReclaimable:     4268 kB
SUnreclaim:       5664 kB
PageTables:        840 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2244644 kB
Committed_AS:    43472 kB
VmallocTotal:   114680 kB
VmallocUsed:      2752 kB
VmallocChunk:   111732 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB
-- buddyinfo: --
Node 0, zone      DMA      6      5      3      4      5      3      3      1      2      2      1 
Node 0, zone   Normal      2      1      1      3      2      0      2      1      2      2    209 
Node 0, zone  HighMem      1      2      4      0      2      6      9      6      5      2    261 
-- vmstat: --
nr_free_pages 490174
nr_inactive 10565
nr_active 9960
nr_anon_pages 4633
nr_mapped 4615
nr_file_pages 15914
nr_dirty 876
nr_writeback 0
nr_slab_reclaimable 1067
nr_slab_unreclaimable 1416
nr_page_table_pages 210
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
pgpgin 60711
pgpgout 8
pswpin 0
pswpout 0
pgalloc_dma 1
pgalloc_normal 37715
pgalloc_high 117302
pgalloc_movable 0
pgfree 645411
pgactivate 5508
pgdeactivate 0
pgfault 485746
pgmajfault 680
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
  pages free     215882
        min      936
        low      1170
        high     1404
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  223520
    nr_free_pages 215882
    nr_inactive  647
    nr_active    750
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 1398
    nr_dirty     2
    nr_writeback 0
    nr_slab_reclaimable 1067
    nr_slab_unreclaimable 1415
    nr_page_table_pages 210
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 9023, 9023)
  pagesets
    cpu: 0
              count: 38
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 114
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     271176
        min      128
        low      430
        high     733
        scanned  0 (a: 0 i: 0)
        spanned  291016
        present  288743
    nr_free_pages 271176
    nr_inactive  9918
    nr_active    9210
    nr_anon_pages 4633
    nr_mapped    4614
    nr_file_pages 14516
    nr_dirty     874
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
              count: 43
              high:  186
              batch: 31
  vm stats threshold: 20
    cpu: 1
              count: 48
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
Node    0, zone   Normal, type    Unmovable      0      0      0      1      0      0      1      0      1      0      0 
Node    0, zone   Normal, type  Reclaimable      1      1      0      1      1      0      0      1      1      1      0 
Node    0, zone   Normal, type      Movable      1      0      1      1      1      0      1      0      0      1    208 
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone   Normal, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type    Unmovable      0      1      3      0      1      1      1      0      1      0      0 
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type      Movable      1      1      1      0      1      5      8      6      4      2    260 
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
kmalloc_dma-512        8      8    512    8    1 : tunables    0    0    0 : slabdata      1      1      0
flow_cache             0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
dm_uevent              0      0   2464    3    2 : tunables    0    0    0 : slabdata      0      0      0
cfq_io_context        84     84     96   42    1 : tunables    0    0    0 : slabdata      2      2      0
bsg_cmd                0      0    288   14    1 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache      7      7    576    7    1 : tunables    0    0    0 : slabdata      1      1      0
hugetlbfs_inode_cache     11     11    344   11    1 : tunables    0    0    0 : slabdata      1      1      0
ext2_inode_cache       0      0    464    8    1 : tunables    0    0    0 : slabdata      0      0      0
journal_handle       340    340     24  170    1 : tunables    0    0    0 : slabdata      2      2      0
journal_head        1088   1168     56   73    1 : tunables    0    0    0 : slabdata     16     16      0
revoke_record        512    512     16  256    1 : tunables    0    0    0 : slabdata      2      2      0
ext3_inode_cache    1648   1648    472    8    1 : tunables    0    0    0 : slabdata    206    206      0
configfs_dir_cache     73     73     56   73    1 : tunables    0    0    0 : slabdata      1      1      0
shmem_inode_cache   3156   3159    440    9    1 : tunables    0    0    0 : slabdata    351    351      0
xfrm_dst_cache         0      0    320   12    1 : tunables    0    0    0 : slabdata      0      0      0
UDP                   14     14    576    7    1 : tunables    0    0    0 : slabdata      2      2      0
TCP                   12     12   1216    6    2 : tunables    0    0    0 : slabdata      2      2      0
sgpool-128             8      8   2048    4    2 : tunables    0    0    0 : slabdata      2      2      0
scsi_io_context        0      0    104   39    1 : tunables    0    0    0 : slabdata      0      0      0
blkdev_queue          21     21   1080    7    2 : tunables    0    0    0 : slabdata      3      3      0
biovec-256            66     66   3072    2    2 : tunables    0    0    0 : slabdata     33     33      0
biovec-128            70     70   1536    5    2 : tunables    0    0    0 : slabdata     14     14      0
biovec-64             76     80    768    5    1 : tunables    0    0    0 : slabdata     16     16      0
sock_inode_cache      99    100    384   10    1 : tunables    0    0    0 : slabdata     10     10      0
file_lock_cache       72     72    112   36    1 : tunables    0    0    0 : slabdata      2      2      0
Acpi-Operand        1220   1224     40  102    1 : tunables    0    0    0 : slabdata     12     12      0
Acpi-Namespace      1530   1530     24  170    1 : tunables    0    0    0 : slabdata      9      9      0
proc_inode_cache     759    759    360   11    1 : tunables    0    0    0 : slabdata     69     69      0
sigqueue              56     56    144   28    1 : tunables    0    0    0 : slabdata      2      2      0
radix_tree_node     1703   1703    296   13    1 : tunables    0    0    0 : slabdata    131    131      0
bdev_cache            24     24    512    8    1 : tunables    0    0    0 : slabdata      3      3      0
sysfs_dir_cache    11607  11730     48   85    1 : tunables    0    0    0 : slabdata    138    138      0
inode_cache         4007   4015    344   11    1 : tunables    0    0    0 : slabdata    365    365      0
dentry             10590  10592    128   32    1 : tunables    0    0    0 : slabdata    331    331      0
names_cache            4      4   4096    2    2 : tunables    0    0    0 : slabdata      2      2      0
idr_layer_cache      251    252    144   28    1 : tunables    0    0    0 : slabdata      9      9      0
buffer_head         4676   4800     64   64    1 : tunables    0    0    0 : slabdata     75     75      0
vm_area_struct      1725   1748     88   46    1 : tunables    0    0    0 : slabdata     38     38      0
files_cache           46     50    384   10    1 : tunables    0    0    0 : slabdata      5      5      0
signal_cache         201    207    448    9    1 : tunables    0    0    0 : slabdata     23     23      0
sighand_cache         86     90   1344    6    2 : tunables    0    0    0 : slabdata     15     15      0
task_struct          102    108    864    9    2 : tunables    0    0    0 : slabdata     12     12      0
anon_vma             885   1024     16  256    1 : tunables    0    0    0 : slabdata      4      4      0
kmalloc-4096          55     64   4096    8    8 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-2048         237    240   2048   16    8 : tunables    0    0    0 : slabdata     15     15      0
kmalloc-1024         245    248   1024    4    1 : tunables    0    0    0 : slabdata     62     62      0
kmalloc-512          965    976    512    8    1 : tunables    0    0    0 : slabdata    122    122      0
kmalloc-256           94     96    256   16    1 : tunables    0    0    0 : slabdata      6      6      0
kmalloc-128         1191   1248    128   32    1 : tunables    0    0    0 : slabdata     39     39      0
kmalloc-64          1663   1792     64   64    1 : tunables    0    0    0 : slabdata     28     28      0
kmalloc-32          1129   1152     32  128    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-16          3800   3840     16  256    1 : tunables    0    0    0 : slabdata     15     15      0
kmalloc-8           4575   4608      8  512    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-192          386    420    192   21    1 : tunables    0    0    0 : slabdata     20     20      0
kmalloc-96           420    462     96   42    1 : tunables    0    0    0 : slabdata     11     11      0
-- dmesg: --
cv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.205564] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.205564] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.205564] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.205564] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.205564] ohci1394: fw-host0: physical posted write error
[   34.205564] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.205564] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.205564] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.220656] ohci1394: fw-host0: Unrecoverable error!
[   34.220656] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.220656] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.220656] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.220656] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.220656] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.220656] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.220656] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.220656] ohci1394: fw-host0: physical posted write error
[   34.220656] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.220656] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.220656] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.235680] ohci1394: fw-host0: Unrecoverable error!
[   34.235680] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.235680] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.235680] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.235680] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.235680] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.235680] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.235680] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.235680] ohci1394: fw-host0: physical posted write error
[   34.235680] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.235680] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.235680] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.242301] ohci1394: fw-host0: Unrecoverable error!
[   34.242301] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.242301] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.242301] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.242301] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.242301] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.242301] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.242301] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.242301] ohci1394: fw-host0: physical posted write error
[   34.242301] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.242301] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.242301] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.265077] ohci1394: fw-host0: Unrecoverable error!
[   34.265077] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.265077] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.265077] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.265077] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.265077] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.265077] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.265077] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.265077] ohci1394: fw-host0: physical posted write error
[   34.265077] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.265077] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.265077] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.267033] ohci1394: fw-host0: Unrecoverable error!
[   34.267041] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.267052] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.267061] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.267068] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.267075] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.267083] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.267090] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.267096] ohci1394: fw-host0: physical posted write error
[   34.267101] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.267106] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.267111] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.268410] ohci1394: fw-host0: Unrecoverable error!
[   34.268410] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.268410] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.268410] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.268410] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.268410] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.268410] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.268410] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.268410] ohci1394: fw-host0: physical posted write error
[   34.268410] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.268410] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.268410] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.293789] ohci1394: fw-host0: Unrecoverable error!
[   34.293789] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.293789] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.293789] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.293789] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.293789] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.293789] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.293789] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.293789] ohci1394: fw-host0: physical posted write error
[   34.293789] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.293789] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.293789] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.315571] ohci1394: fw-host0: Unrecoverable error!
[   34.315571] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.315571] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.315571] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.315571] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.315571] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.315571] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.315571] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.315571] ohci1394: fw-host0: physical posted write error
[   34.315571] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.315571] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.315571] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.333821] ohci1394: fw-host0: Unrecoverable error!
[   34.333821] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.333821] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.333821] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.333821] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.333822] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.333822] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.333822] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.333822] ohci1394: fw-host0: physical posted write error
[   34.333822] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.333822] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.333822] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.339454] ohci1394: fw-host0: Unrecoverable error!
[   34.339454] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.339454] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.339454] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.339454] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.339454] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.339454] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.339454] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.339454] ohci1394: fw-host0: physical posted write error
[   34.339454] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.339454] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.339454] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.345269] ohci1394: fw-host0: Unrecoverable error!
[   34.345269] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.345269] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.345269] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.345269] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.345269] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.345269] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.345269] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.345269] ohci1394: fw-host0: physical posted write error
[   34.345269] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.345269] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.345269] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.372495] ohci1394: fw-host0: Unrecoverable error!
[   34.372495] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.372495] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.372495] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.372495] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.372495] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.372495] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.372495] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.372495] ohci1394: fw-host0: physical posted write error
[   34.372495] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.372495] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.372495] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.391725] ohci1394: fw-host0: Unrecoverable error!
[   34.391725] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.391725] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.391725] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.391725] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.391725] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.391725] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.391725] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.391725] ohci1394: fw-host0: physical posted write error
[   34.391725] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.391725] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.391725] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.401812] ohci1394: fw-host0: Unrecoverable error!
[   34.401812] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.401812] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.401812] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.401812] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.401812] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.401812] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.401812] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.401812] ohci1394: fw-host0: physical posted write error
[   34.401812] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.401812] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.401812] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.411013] ohci1394: fw-host0: Unrecoverable error!
[   34.411013] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.411013] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.411013] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.411013] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.411013] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.411013] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.411013] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.411013] ohci1394: fw-host0: physical posted write error
[   34.411013] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.411013] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.411013] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.413614] ohci1394: fw-host0: Unrecoverable error!
[   34.413614] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.413614] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.413614] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.413614] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.413614] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.413614] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.413614] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.413614] ohci1394: fw-host0: physical posted write error
[   34.413614] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.413614] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.413614] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.430622] ohci1394: fw-host0: Unrecoverable error!
[   34.430622] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.430622] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.430622] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.430622] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.430622] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.430622] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.430622] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.430622] ohci1394: fw-host0: physical posted write error
[   34.430622] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.430622] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.430622] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.438401] ohci1394: fw-host0: Unrecoverable error!
[   34.438401] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.438401] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.438401] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.438401] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.438401] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.438401] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.438401] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.438401] ohci1394: fw-host0: physical posted write error
[   34.438401] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.438401] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.438401] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.471176] ohci1394: fw-host0: Unrecoverable error!
[   34.471176] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.471176] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.471176] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.471176] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.471176] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.471176] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.471176] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.471176] ohci1394: fw-host0: physical posted write error
[   34.471176] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.471176] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.471176] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.487463] ohci1394: fw-host0: Unrecoverable error!
[   34.487463] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.487463] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.487463] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.487463] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.487463] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.487463] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.487463] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.487463] ohci1394: fw-host0: physical posted write error
[   34.487463] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.487463] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.487463] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.505154] ohci1394: fw-host0: Unrecoverable error!
[   34.505154] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.505154] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.505154] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.505154] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.505154] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.505154] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.505154] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.505154] ohci1394: fw-host0: physical posted write error
[   34.505154] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.505154] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.505154] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.511000] ohci1394: fw-host0: Unrecoverable error!
[   34.511000] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.511000] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.511000] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.511000] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.511000] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.511000] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.511000] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.511000] ohci1394: fw-host0: physical posted write error
[   34.511000] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.511000] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.511000] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.515851] ohci1394: fw-host0: Unrecoverable error!
[   34.515851] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.515851] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.515851] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.515851] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.515851] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.515851] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.515851] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.515851] ohci1394: fw-host0: physical posted write error
[   34.515851] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.515851] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.515851] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.555901] ohci1394: fw-host0: Unrecoverable error!
[   34.555901] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.555901] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.555901] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.555901] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.555901] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.555901] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.555901] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.555901] ohci1394: fw-host0: physical posted write error
[   34.555901] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.555901] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.555901] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.562137] ohci1394: fw-host0: Unrecoverable error!
[   34.562151] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.562163] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.562172] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.562179] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.562186] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.562194] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.562201] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.562207] ohci1394: fw-host0: physical posted write error
[   34.562213] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.562219] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.562224] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.564833] ohci1394: fw-host0: Unrecoverable error!
[   34.564833] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.564833] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.564833] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.564833] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.564833] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.564833] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.564833] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.564833] ohci1394: fw-host0: physical posted write error
[   34.564833] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.564833] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.564833] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.586369] ohci1394: fw-host0: Unrecoverable error!
[   34.586369] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.586369] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.586369] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.586369] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.586369] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.586369] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.586369] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.586369] ohci1394: fw-host0: physical posted write error
[   34.586369] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.586369] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.586369] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.602186] ohci1394: fw-host0: Unrecoverable error!
[   34.602186] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.602186] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.602186] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.602186] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.602186] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.602186] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.602186] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.602186] ohci1394: fw-host0: physical posted write error
[   34.602186] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.602186] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.602186] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.607947] ohci1394: fw-host0: Unrecoverable error!
[   34.607947] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.607947] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.607947] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.607947] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.607947] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.607947] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.607947] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.607947] ohci1394: fw-host0: physical posted write error
[   34.607947] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.607947] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.607947] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.620524] ohci1394: fw-host0: Unrecoverable error!
[   34.620524] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.620524] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.620524] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.620524] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.620524] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.620524] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.620524] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.620524] ohci1394: fw-host0: physical posted write error
[   34.620524] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.620524] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.620524] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.632065] ohci1394: fw-host0: Unrecoverable error!
[   34.632065] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.632065] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.632065] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.632065] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.632065] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.632065] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.632065] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.632065] ohci1394: fw-host0: physical posted write error
[   34.632065] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.632065] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.632065] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.640273] ohci1394: fw-host0: Unrecoverable error!
[   34.640273] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.640273] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.640273] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.640273] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.640273] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.640273] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.640273] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.640273] ohci1394: fw-host0: physical posted write error
[   34.640273] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.640273] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.640273] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.640273] ohci1394: fw-host0: Unrecoverable error!
[   34.640273] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.640273] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.640273] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.640273] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.640273] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.640273] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.640273] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.640273] ohci1394: fw-host0: physical posted write error
[   34.640273] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.640273] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.640273] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.644427] ohci1394: fw-host0: Unrecoverable error!
[   34.644427] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.644427] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.644427] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.644427] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.644427] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.644427] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.644427] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.644427] ohci1394: fw-host0: physical posted write error
[   34.644427] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.644427] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.644427] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.660203] ohci1394: fw-host0: Unrecoverable error!
[   34.660203] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.660203] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.660203] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.660203] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.660203] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.660203] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.660203] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.660203] ohci1394: fw-host0: physical posted write error
[   34.660203] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.660203] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.660203] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.666951] ohci1394: fw-host0: Unrecoverable error!
[   34.666951] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.666951] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.666951] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.666951] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.666951] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.666951] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.666951] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.666951] ohci1394: fw-host0: physical posted write error
[   34.666951] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.666951] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.666951] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.684784] ohci1394: fw-host0: Unrecoverable error!
[   34.684784] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.684784] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.684784] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.684784] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.684784] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.684784] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.684784] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.684784] ohci1394: fw-host0: physical posted write error
[   34.684784] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.684784] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.684784] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.703957] ohci1394: fw-host0: Unrecoverable error!
[   34.703970] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.703982] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.703991] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.703998] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.704003] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.704003] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.704003] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.704003] ohci1394: fw-host0: physical posted write error
[   34.704003] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.704003] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.704003] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.708298] ohci1394: fw-host0: Unrecoverable error!
[   34.708298] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.708298] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.708298] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.708298] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.708298] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.708298] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.708298] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.708298] ohci1394: fw-host0: physical posted write error
[   34.708298] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.708298] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.708298] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.720567] ohci1394: fw-host0: Unrecoverable error!
[   34.720567] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.720567] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.720567] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.720567] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.720567] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.720567] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.720567] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.720567] ohci1394: fw-host0: physical posted write error
[   34.720567] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.720567] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.720567] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.733925] ohci1394: fw-host0: Unrecoverable error!
[   34.733925] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.733925] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.733925] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.733925] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.733925] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.733925] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.733925] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.733925] ohci1394: fw-host0: physical posted write error
[   34.733925] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.733925] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.733925] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.743268] ohci1394: fw-host0: Unrecoverable error!
[   34.743268] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.743268] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.743268] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.743268] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.743268] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.743268] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.743268] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.743268] ohci1394: fw-host0: physical posted write error
[   34.743268] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.743268] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.743268] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.759437] ohci1394: fw-host0: Unrecoverable error!
[   34.759437] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.759437] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.759437] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.759437] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.759437] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.759437] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.759437] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.759437] ohci1394: fw-host0: physical posted write error
[   34.759437] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.759437] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.759437] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.766085] ohci1394: fw-host0: Unrecoverable error!
[   34.766085] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.766085] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.766085] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.766085] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.766085] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.766085] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.766085] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.766085] ohci1394: fw-host0: physical posted write error
[   34.766085] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.766085] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.766085] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.775066] ohci1394: fw-host0: Unrecoverable error!
[   34.775066] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.775066] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.775066] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.775066] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.775066] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.775066] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.775066] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.775066] ohci1394: fw-host0: physical posted write error
[   34.775066] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.775066] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.775066] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.785504] ohci1394: fw-host0: Unrecoverable error!
[   34.785504] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.785504] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.785504] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.785504] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.785504] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.785504] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.785504] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.785504] ohci1394: fw-host0: physical posted write error
[   34.785504] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.785504] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.785504] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.793151] ohci1394: fw-host0: Unrecoverable error!
[   34.793163] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.793175] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.793184] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.793192] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.793199] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.793207] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.793213] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.793219] ohci1394: fw-host0: physical posted write error
[   34.793226] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.793231] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.793236] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.795180] ohci1394: fw-host0: Unrecoverable error!
[   34.795191] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.795203] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.795212] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.795219] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.795226] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.795234] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.795241] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.795247] ohci1394: fw-host0: physical posted write error
[   34.795253] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.795259] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.795263] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.810906] ohci1394: fw-host0: Unrecoverable error!
[   34.810913] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.810924] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.810933] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.810939] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.810945] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.810953] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.810959] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.810965] ohci1394: fw-host0: physical posted write error
[   34.810970] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.810975] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.810979] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.811241] ohci1394: fw-host0: Unrecoverable error!
[   34.811249] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.811261] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.811270] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.811277] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.811284] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.811292] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.811299] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.811305] ohci1394: fw-host0: physical posted write error
[   34.811310] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.811315] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.811320] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.812028] ohci1394: fw-host0: Unrecoverable error!
[   34.812036] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.812048] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.812057] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.812064] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.812071] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.812079] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.812086] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.812092] ohci1394: fw-host0: physical posted write error
[   34.812097] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.812102] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.812107] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.814445] ohci1394: fw-host0: Unrecoverable error!
[   34.814454] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.814466] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.814475] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.814482] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.814489] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.814497] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.814504] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.814510] ohci1394: fw-host0: physical posted write error
[   34.814515] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.814520] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.814525] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.815009] ohci1394: fw-host0: Unrecoverable error!
[   34.815017] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.815029] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.815038] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.815045] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.815052] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.815060] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.815067] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.815073] ohci1394: fw-host0: physical posted write error
[   34.815078] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.815083] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.815088] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.815624] ohci1394: fw-host0: Unrecoverable error!
[   34.815629] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.815641] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.815651] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.815657] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.815664] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.815672] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.815679] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.815684] ohci1394: fw-host0: physical posted write error
[   34.815689] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.815694] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.815699] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.816157] ohci1394: fw-host0: Unrecoverable error!
[   34.816162] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.816174] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.816183] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.816190] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.816196] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.816204] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.816211] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.816217] ohci1394: fw-host0: physical posted write error
[   34.816222] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.816227] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.816231] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.825501] ohci1394: fw-host0: Unrecoverable error!
[   34.825501] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.825501] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.825501] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.825501] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.825501] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.825501] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.825501] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.825501] ohci1394: fw-host0: physical posted write error
[   34.825501] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.825501] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.825501] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.845274] ohci1394: fw-host0: Unrecoverable error!
[   34.845274] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.845274] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.845274] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.845274] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.845274] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.845274] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.845274] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.845274] ohci1394: fw-host0: physical posted write error
[   34.845274] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.845274] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.845274] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.866328] ohci1394: fw-host0: Unrecoverable error!
[   34.866328] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.866328] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.866328] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.866328] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.866328] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.866328] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.866328] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.866328] ohci1394: fw-host0: physical posted write error
[   34.866328] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.866328] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.866328] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.883453] ohci1394: fw-host0: Unrecoverable error!
[   34.883453] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.883453] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.883453] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.883453] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.883453] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.883453] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.883453] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.883453] ohci1394: fw-host0: physical posted write error
[   34.883453] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.883453] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.883453] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.901496] ohci1394: fw-host0: Unrecoverable error!
[   34.901500] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.901507] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.901513] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.901516] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.901520] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.901524] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.901528] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.901531] ohci1394: fw-host0: physical posted write error
[   34.901534] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.901537] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.901539] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.924082] ohci1394: fw-host0: Unrecoverable error!
[   34.924086] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.924094] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.924099] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.924103] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.924106] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.924111] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.924114] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.924117] ohci1394: fw-host0: physical posted write error
[   34.924120] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.924124] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.924126] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.924367] ohci1394: fw-host0: Unrecoverable error!
[   34.924372] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.924380] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.924386] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.924390] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.924394] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.924398] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.924402] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.924406] ohci1394: fw-host0: physical posted write error
[   34.924409] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.924412] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.924414] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.925216] ohci1394: fw-host0: Unrecoverable error!
[   34.925219] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.925227] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.925232] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.925236] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.925239] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.925244] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.925247] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.925250] ohci1394: fw-host0: physical posted write error
[   34.925253] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.925256] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.925258] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.925916] ohci1394: fw-host0: Unrecoverable error!
[   34.925919] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.925926] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.925932] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.925935] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.925939] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.925943] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.925947] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.925950] ohci1394: fw-host0: physical posted write error
[   34.925953] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.925956] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.925958] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.927888] ohci1394: fw-host0: Unrecoverable error!
[   34.927891] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.927898] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.927903] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.927907] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.927911] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.927915] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.927919] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.927922] ohci1394: fw-host0: physical posted write error
[   34.927924] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.927927] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.927929] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.963681] ohci1394: fw-host0: Unrecoverable error!
[   34.963685] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.963693] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.963699] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.963702] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.963706] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.963710] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.963714] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.963717] ohci1394: fw-host0: physical posted write error
[   34.963720] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.963724] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.963726] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.976920] ohci1394: fw-host0: Unrecoverable error!
[   34.976923] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.976931] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.976936] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.976940] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.976944] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.976948] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.976952] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.976955] ohci1394: fw-host0: physical posted write error
[   34.976957] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.976960] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.976962] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.977483] ohci1394: fw-host0: Unrecoverable error!
[   34.977486] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.977494] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.977499] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.977503] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.977506] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.977511] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.977514] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.977517] ohci1394: fw-host0: physical posted write error
[   34.977520] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.977523] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.977525] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.987574] ohci1394: fw-host0: Unrecoverable error!
[   34.987577] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.987585] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.987590] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.987594] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.987598] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.987602] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.987606] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.987609] ohci1394: fw-host0: physical posted write error
[   34.987611] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.987614] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.987616] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.987944] ohci1394: fw-host0: Unrecoverable error!
[   34.987950] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.987958] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.987963] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.987967] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.987971] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.987976] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.987980] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.987983] ohci1394: fw-host0: physical posted write error
[   34.987986] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.987989] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.987992] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   34.996846] ohci1394: fw-host0: Unrecoverable error!
[   34.996846] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   34.996846] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   34.996846] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   34.996846] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   34.996846] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   34.996846] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   34.996846] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   34.996846] ohci1394: fw-host0: physical posted write error
[   34.996846] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   34.996846] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   34.996846] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.001318] ohci1394: fw-host0: Unrecoverable error!
[   35.001318] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.001318] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.001318] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.001318] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.001318] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.001318] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.001318] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.001318] ohci1394: fw-host0: physical posted write error
[   35.001318] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.001318] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.001318] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.014787] ohci1394: fw-host0: Unrecoverable error!
[   35.014787] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.014787] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.014787] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.014787] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.014787] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.014787] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.014787] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.014787] ohci1394: fw-host0: physical posted write error
[   35.014787] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.014787] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.014787] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.031452] ohci1394: fw-host0: Unrecoverable error!
[   35.031452] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.031452] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.031452] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.031452] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.031452] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.031452] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.031452] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.031452] ohci1394: fw-host0: physical posted write error
[   35.031452] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.031452] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.031452] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.035804] ohci1394: fw-host0: Unrecoverable error!
[   35.035804] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.035804] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.035804] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.035804] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.035804] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.035804] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.035804] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.035804] ohci1394: fw-host0: physical posted write error
[   35.035804] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.035804] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.035804] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.036015] ohci1394: fw-host0: Unrecoverable error!
[   35.036015] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.036015] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.036015] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.036015] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.036015] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.036015] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.036015] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.036015] ohci1394: fw-host0: physical posted write error
[   35.036015] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.036015] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.036015] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.049347] ohci1394: fw-host0: Unrecoverable error!
[   35.049347] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.049347] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.049347] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.049347] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.049347] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.049347] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.049347] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.049347] ohci1394: fw-host0: physical posted write error
[   35.049347] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.049347] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.049347] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.056549] ohci1394: fw-host0: Unrecoverable error!
[   35.056549] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.056549] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.056549] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.056549] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.056549] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.056549] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.056549] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.056549] ohci1394: fw-host0: physical posted write error
[   35.056549] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.056549] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.056549] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.063599] ohci1394: fw-host0: Unrecoverable error!
[   35.063599] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.063599] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.063599] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.063599] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.063599] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.063599] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.063599] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.063599] ohci1394: fw-host0: physical posted write error
[   35.063599] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.063599] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.063599] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.085710] ohci1394: fw-host0: Unrecoverable error!
[   35.085710] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.085710] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.085710] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.085710] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.085710] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.085710] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.085710] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.085710] ohci1394: fw-host0: physical posted write error
[   35.085710] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.085710] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.085710] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.110611] ohci1394: fw-host0: Unrecoverable error!
[   35.110618] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.110627] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.110632] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.110636] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.110640] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.110645] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.110649] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.110652] ohci1394: fw-host0: physical posted write error
[   35.110656] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.110660] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.110663] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.122227] ohci1394: fw-host0: Unrecoverable error!
[   35.122227] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.122227] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.122227] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.122227] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.122227] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.122227] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.122227] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.122227] ohci1394: fw-host0: physical posted write error
[   35.122227] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.122227] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.122227] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.132041] ohci1394: fw-host0: Unrecoverable error!
[   35.132041] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.132041] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.132041] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.132041] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.132041] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.132041] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.132041] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.132041] ohci1394: fw-host0: physical posted write error
[   35.132041] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.132041] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.132041] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.136422] ohci1394: fw-host0: Unrecoverable error!
[   35.136426] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.136435] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.136440] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.136444] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.136448] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.136453] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.136457] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.136461] ohci1394: fw-host0: physical posted write error
[   35.136464] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.136467] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.136469] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.138598] ohci1394: fw-host0: Unrecoverable error!
[   35.138598] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.138598] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.138598] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.138598] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.138598] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.138598] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.138598] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.138598] ohci1394: fw-host0: physical posted write error
[   35.138598] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.138598] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.138598] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.159219] ohci1394: fw-host0: Unrecoverable error!
[   35.159219] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.159219] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.159219] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.159219] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.159219] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.159219] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.159219] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.159219] ohci1394: fw-host0: physical posted write error
[   35.159219] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.159219] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.159219] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.166953] ohci1394: fw-host0: Unrecoverable error!
[   35.166953] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.166953] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.166953] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.166953] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.166953] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.166953] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.166953] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.166953] ohci1394: fw-host0: physical posted write error
[   35.166953] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.166953] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.166953] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.171168] ohci1394: fw-host0: Unrecoverable error!
[   35.171173] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.171181] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.171186] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.171190] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.171194] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.171199] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.171203] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.171206] ohci1394: fw-host0: physical posted write error
[   35.171209] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.171212] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.171215] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.173303] ohci1394: fw-host0: Unrecoverable error!
[   35.173303] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.173303] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.173303] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.173303] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.173303] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.173303] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.173303] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.173303] ohci1394: fw-host0: physical posted write error
[   35.173303] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.173303] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.173303] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.190321] ohci1394: fw-host0: Unrecoverable error!
[   35.190321] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.190321] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.190321] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.190321] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.190321] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.190321] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.190321] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.190321] ohci1394: fw-host0: physical posted write error
[   35.190321] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.190321] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.190321] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.200438] ohci1394: fw-host0: Unrecoverable error!
[   35.200438] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.200438] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.200438] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.200438] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.200438] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.200438] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.200438] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.200438] ohci1394: fw-host0: physical posted write error
[   35.200438] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.200438] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.200438] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.203389] ohci1394: fw-host0: Unrecoverable error!
[   35.203393] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.203401] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.203407] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.203411] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.203415] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.203420] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.203424] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.203427] ohci1394: fw-host0: physical posted write error
[   35.203430] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.203433] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.203436] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.208919] ohci1394: fw-host0: Unrecoverable error!
[   35.208919] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.208919] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.208919] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.208919] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.208919] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.208919] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.208919] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.208919] ohci1394: fw-host0: physical posted write error
[   35.208919] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.208919] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.208919] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.211264] ohci1394: fw-host0: Unrecoverable error!
[   35.211264] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.211264] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.211264] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.211264] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.211264] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.211264] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.211264] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.211264] ohci1394: fw-host0: physical posted write error
[   35.211264] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.211264] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.211264] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.224875] ohci1394: fw-host0: Unrecoverable error!
[   35.224875] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.224875] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.224875] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.224875] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.224875] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.224875] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.224876] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.224876] ohci1394: fw-host0: physical posted write error
[   35.224876] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.224876] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.224876] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.244325] ohci1394: fw-host0: Unrecoverable error!
[   35.244325] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.244325] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.244325] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.244325] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.244325] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.244325] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.244325] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.244325] ohci1394: fw-host0: physical posted write error
[   35.244325] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.244325] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.244325] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.267490] ohci1394: fw-host0: Unrecoverable error!
[   35.267490] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.267490] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.267490] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.267490] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.267490] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.267490] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.267490] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.267490] ohci1394: fw-host0: physical posted write error
[   35.267490] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.267490] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.267490] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.273206] ohci1394: fw-host0: Unrecoverable error!
[   35.273206] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.273206] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.273206] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.273206] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.273206] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.273206] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.273206] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.273206] ohci1394: fw-host0: physical posted write error
[   35.273206] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.273206] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.273206] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.275732] ohci1394: fw-host0: Unrecoverable error!
[   35.275737] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.275746] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.275752] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.275756] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.275760] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.275764] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.275768] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.275772] ohci1394: fw-host0: physical posted write error
[   35.275775] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.275778] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.275780] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.292176] ohci1394: fw-host0: Unrecoverable error!
[   35.292176] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.292176] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.292176] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.292176] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.292176] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.292176] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.292176] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.292176] ohci1394: fw-host0: physical posted write error
[   35.292176] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.292176] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.292176] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.300468] ohci1394: fw-host0: Unrecoverable error!
[   35.300476] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.300486] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.300491] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.300496] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.300500] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.300505] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.300509] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.300512] ohci1394: fw-host0: physical posted write error
[   35.300517] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.300521] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.300523] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.312180] ohci1394: fw-host0: Unrecoverable error!
[   35.312180] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.312180] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.312180] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.312180] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.312180] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.312180] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.312180] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.312180] ohci1394: fw-host0: physical posted write error
[   35.312180] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.312180] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.312180] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.325451] ohci1394: fw-host0: Unrecoverable error!
[   35.325451] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.325451] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.325451] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.325451] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.325451] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.325451] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.325451] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.325451] ohci1394: fw-host0: physical posted write error
[   35.325451] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.325451] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.325451] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.338859] ohci1394: fw-host0: Unrecoverable error!
[   35.338859] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.338859] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.338859] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.338859] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.338859] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.338859] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.338859] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.338859] ohci1394: fw-host0: physical posted write error
[   35.338859] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.338859] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.338859] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.348148] ohci1394: fw-host0: Unrecoverable error!
[   35.348148] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.348148] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.348148] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.348148] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.348148] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.348148] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.348148] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.348148] ohci1394: fw-host0: physical posted write error
[   35.348148] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.348148] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.348148] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.356248] ohci1394: fw-host0: Unrecoverable error!
[   35.356248] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.356248] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.356248] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.356248] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.356248] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.356248] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.356248] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.356248] ohci1394: fw-host0: physical posted write error
[   35.356248] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.356248] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.356248] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.359703] ohci1394: fw-host0: Unrecoverable error!
[   35.359703] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.359703] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.359703] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.359703] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.359703] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.359703] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.359703] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.359703] ohci1394: fw-host0: physical posted write error
[   35.359703] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.359703] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.359703] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.367741] ohci1394: fw-host0: Unrecoverable error!
[   35.367741] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.367741] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.367741] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.367741] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.367741] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.367741] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.367741] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.367741] ohci1394: fw-host0: physical posted write error
[   35.367741] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.367741] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.367741] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.374691] ohci1394: fw-host0: Unrecoverable error!
[   35.374691] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.374691] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.374691] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.374691] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.374691] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.374691] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.374691] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.374691] ohci1394: fw-host0: physical posted write error
[   35.374691] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.374691] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.374691] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.381741] ohci1394: fw-host0: Unrecoverable error!
[   35.381741] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.381741] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.381741] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.381741] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.381741] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.381741] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.381741] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.381741] ohci1394: fw-host0: physical posted write error
[   35.381741] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.381741] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.381741] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.381741] ohci1394: fw-host0: Unrecoverable error!
[   35.381741] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.381741] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.381741] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.381741] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.381741] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.381741] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.381741] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.381741] ohci1394: fw-host0: physical posted write error
[   35.381741] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.381741] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.381741] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.450621] ohci1394: fw-host0: Unrecoverable error!
[   35.450621] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.450621] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.450621] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.450621] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.450621] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.450621] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.450621] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.450621] ohci1394: fw-host0: physical posted write error
[   35.450621] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.450621] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.450621] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.453783] ohci1394: fw-host0: Unrecoverable error!
[   35.453783] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.453783] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.453783] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.453783] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.453783] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.453783] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.453783] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.453783] ohci1394: fw-host0: physical posted write error
[   35.453783] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.453783] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.453783] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.457116] ohci1394: fw-host0: Unrecoverable error!
[   35.457116] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.457116] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.457116] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.457116] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.457116] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.457116] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.457116] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.457116] ohci1394: fw-host0: physical posted write error
[   35.457116] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.457116] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.457116] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   35.472989] ohci1394: fw-host0: Unrecoverable error!
[   35.472989] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   35.472989] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   35.472989] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   35.472989] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   35.472989] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   35.472989] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   35.472989] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   35.472989] ohci1394: fw-host0: physical posted write error
[   35.472989] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   35.472989] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   35.472989] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   52.648353] ohci1394: fw-host0: Unrecoverable error!
[   52.648353] ohci1394: fw-host0: Async Rsp Tx Context died: ctrl[f0002a00] cmdptr[f0002a00]
[   52.648353] ohci1394: fw-host0: Iso Recv 3 Context died: ctrl[d4000d0e] cmdptr[00134640] match[00000000]
[   52.648353] ohci1394: fw-host0: Iso Recv 17 Context died: ctrl[7c006e38] cmdptr[f58b18cd] match[4910c683]
[   52.648353] ohci1394: fw-host0: Iso Recv 18 Context died: ctrl[003cacf0] cmdptr[88f2eb10] match[46e8104e]
[   52.648353] ohci1394: fw-host0: Iso Recv 19 Context died: ctrl[0c047e80] cmdptr[83060246] match[83060846]
[   52.648353] ohci1394: fw-host0: Iso Recv 26 Context died: ctrl[00656c62] cmdptr[6e696461] match[706f2067]
[   52.648353] ohci1394: fw-host0: Iso Recv 27 Context died: ctrl[4d006d65] cmdptr[61726570] match[676e6974]
[   52.648353] ohci1394: fw-host0: physical posted write error
[   52.648353] printk: 181 messages suppressed.
[   52.648353] ohci1394: fw-host0: isochronous cycle too long
[   52.648353] ohci1394: fw-host0: respTxComplete: dma prg stopped
[   52.648353] ohci1394: fw-host0: SelfID received outside of bus reset sequence
[   52.648353] ohci1394: fw-host0: Unhandled interrupt(s) 0xfc7cfe0c
[   56.372269] ohci1394: fw-host0: Get PHY Reg timeout [0x00008400/0x00000000/100]
[   56.375602] ohci1394: fw-host0: Set PHY Reg timeout [0x00004400/0x00004000/100]
[   56.378935] ohci1394: fw-host0: Get PHY Reg timeout [0x00008100/0x00000000/100]
[   56.382268] ohci1394: fw-host0: Set PHY Reg timeout [0x00004140/0x00004000/100]
-- /proc/timer_list: --
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 94662486575 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206386206537018530 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7275ebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 94663323867 nsecs [in 837292 nsecs]
  .expires_next   : 94663323867 nsecs
  .hres_active    : 1
  .nr_events      : 5201
  .nohz_mode      : 2
  .idle_tick      : 94626657204 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294905684
  .idle_calls     : 19569
  .idle_sleeps    : 8298
  .idle_entrytime : 94660004416 nsecs
  .idle_waketime  : 94636936330 nsecs
  .idle_exittime  : 94637006381 nsecs
  .idle_sleeptime : 86490102714 nsecs
  .last_jiffies   : 4294905695
  .next_jiffies   : 4294905737
  .idle_expires   : 94799990520 nsecs
jiffies: 4294905695

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1206386206537018530 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f7275ebc>, tick_sched_timer, S:01, tick_nohz_restart_sched_tick, swapper/0
 # expires at 94664157200 nsecs [in 1670625 nsecs]
 #1: <f7275ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2929
 # expires at 107485169205 nsecs [in 12822682630 nsecs]
 #2: <f7275ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2928
 # expires at 107485237510 nsecs [in 12822750935 nsecs]
 #3: <f7275ebc>, hrtimer_wakeup, S:01, futex_wait, nscd/2927
 # expires at 107485255809 nsecs [in 12822769234 nsecs]
 #4: <f7275ebc>, hrtimer_wakeup, S:01, do_nanosleep, cron/3272
 # expires at 135204217785 nsecs [in 40541731210 nsecs]
 #5: <f7275ebc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3247
 # expires at 1827533910248 nsecs [in 1732871423673 nsecs]
  .expires_next   : 94664157200 nsecs
  .hres_active    : 1
  .nr_events      : 10217
  .nohz_mode      : 2
  .idle_tick      : 94627490537 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294905684
  .idle_calls     : 16402
  .idle_sleeps    : 6101
  .idle_entrytime : 94661390486 nsecs
  .idle_waketime  : 94381920469 nsecs
  .idle_exittime  : 94637809765 nsecs
  .idle_sleeptime : 88496434914 nsecs
  .last_jiffies   : 4294905695
  .next_jiffies   : 4294905718
  .idle_expires   : 94736657193 nsecs
jiffies: 4294905695


Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           3
 next_event:     94663323867 nsecs
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
 next_event:     94663323867 nsecs
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
 next_event:     94664157200 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt

-- /proc/timer_info: --
-- /proc/config.gz: --
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc6
# Mon Mar 24 20:08:06 2008
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
 20:18:21 up 1 min,  1 user,  load average: 0.22, 0.11, 0.04
-- uname: --
Linux hotzenplotz 2.6.25-rc6-x86-latest.git #2 SMP Mon Mar 24 20:14:58 CET 2008 i686 Genuine Intel(R) CPU T2400 @ 1.83GHz GenuineIntel GNU/Linux
-- /sys/devices/system: --
/sys/devices/system/cpu/sched_mc_power_savings:
1
/sys/devices/system/cpu/cpuidle/current_driver:
acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:
menu
/sys/devices/system/cpu/cpu0/crash_notes:
37c5d0c0
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
2941
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
1059
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:
125902
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:
15294
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:
83498662
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
37c5d180
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
3
/sys/devices/system/cpu/cpu1/cpuidle/state0/time:
2487
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
3329
/sys/devices/system/cpu/cpu1/cpuidle/state2/time:
67617
/sys/devices/system/cpu/cpu1/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu1/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu1/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu1/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu1/cpuidle/state3/usage:
14599
/sys/devices/system/cpu/cpu1/cpuidle/state3/time:
85350387
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
top - 20:18:22 up 1 min,  1 user,  load average: 0.21, 0.11, 0.04
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  3.0%us,  3.2%sy,  0.0%ni, 80.1%id, 13.5%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:   2060460k total,   100652k used,  1959808k free,     5632k buffers
Swap:  1214416k total,        0k used,  1214416k free,    58416k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
    1 root      20   0  1612  556  484 S    0  0.0   0:00.21 init [3]           
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
  951 root      16  -4  2612 1452  468 S    0  0.1   0:00.36 /sbin/udevd --daemo
 1892 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 1988 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1989 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2303 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2305 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2319 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2442 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2451 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2452 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2484 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2486 root      15  -5     0    0    0 S    0  0.0   0:00.04 [kcryptd_io]       
 2488 root      15  -5     0    0    0 S    0  0.0   0:00.73 [kcryptd]          
 2559 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2665 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2837 root      20   0  1924  624  480 S    0  0.0   0:00.38 metalog [MASTER]   
 2838 root      20   0  1900  216  120 S    0  0.0   0:00.05 metalog [KERNEL]   
 2847 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2857 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 2926 root      20   0  106m  996  736 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2945 haldaemo  20   0  4768 2928 2272 S    0  0.1   0:00.38 /usr/sbin/hald --us
 2946 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 2992 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2994 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2997 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2998 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3005 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3009 root      20   0  1776  264  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3057 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3064 root      20   0  145m  12m 3512 S    0  0.6   0:00.36 /usr/bin/X -br -nov
 3101 root      20   0  3772 1076  812 S    0  0.1   0:00.00 -:0                
 3122 root      20   0  7040 2292 1560 S    0  0.1   0:00.14 /usr/sbin/cupsd    
 3175 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3231 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3247 root      20   0  2996  536  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3261 root      20   0  4920  948  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3272 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3283 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3284 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3285 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3286 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3287 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3306 root      20   0 36612  13m  10m S    0  0.7   0:00.29 /usr/kde/4.0/lib/kd
 3310 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3311 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3344 root      20   0  2500 1248  916 S    0  0.1   0:00.00 /bin/login --      
 3352 thomas    20   0  3232 1616 1304 S    0  0.1   0:00.00 -bash              
 3361 root      20   0  2708 1292  996 S    0  0.1   0:00.00 su                 
 3362 root      20   0  2972 1600 1288 S    0  0.1   0:00.00 bash               
 3366 root      20   0  2972 1004  664 S    0  0.0   0:00.04 bash               
 3607 root      20   0  2040  896  688 R    0  0.0   0:00.00 top -c -b -d 1 -n 5


top - 20:18:23 up 1 min,  1 user,  load average: 0.21, 0.11, 0.04
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   100748k used,  1959712k free,     5632k buffers
Swap:  1214416k total,        0k used,  1214416k free,    58428k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3607 root      20   0  2048  984  768 R    1  0.0   0:00.01 top -c -b -d 1 -n 5
    1 root      20   0  1612  556  484 S    0  0.0   0:00.21 init [3]           
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
  951 root      16  -4  2612 1452  468 S    0  0.1   0:00.36 /sbin/udevd --daemo
 1892 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 1988 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1989 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2303 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2305 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2319 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2442 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2451 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2452 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2484 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2486 root      15  -5     0    0    0 S    0  0.0   0:00.04 [kcryptd_io]       
 2488 root      15  -5     0    0    0 S    0  0.0   0:00.73 [kcryptd]          
 2559 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2665 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2837 root      20   0  1924  624  480 S    0  0.0   0:00.38 metalog [MASTER]   
 2838 root      20   0  1900  216  120 S    0  0.0   0:00.05 metalog [KERNEL]   
 2847 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2857 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 2926 root      20   0  106m  996  736 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2945 haldaemo  20   0  4768 2928 2272 S    0  0.1   0:00.38 /usr/sbin/hald --us
 2946 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 2992 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2994 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2997 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2998 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3005 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3009 root      20   0  1776  264  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3057 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3064 root      20   0  145m  12m 3512 S    0  0.6   0:00.36 /usr/bin/X -br -nov
 3101 root      20   0  3772 1076  812 S    0  0.1   0:00.00 -:0                
 3122 root      20   0  7040 2292 1560 S    0  0.1   0:00.14 /usr/sbin/cupsd    
 3175 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3231 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3247 root      20   0  2996  536  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3261 root      20   0  4920  948  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3272 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3283 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3284 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3285 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3286 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3287 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3306 root      20   0 36612  13m  10m S    0  0.7   0:00.29 /usr/kde/4.0/lib/kd
 3310 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3311 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3344 root      20   0  2500 1248  916 S    0  0.1   0:00.00 /bin/login --      
 3352 thomas    20   0  3232 1616 1304 S    0  0.1   0:00.00 -bash              
 3361 root      20   0  2708 1292  996 S    0  0.1   0:00.00 su                 
 3362 root      20   0  2972 1600 1288 S    0  0.1   0:00.00 bash               
 3366 root      20   0  2972 1004  664 S    0  0.0   0:00.04 bash               


top - 20:18:24 up 1 min,  1 user,  load average: 0.21, 0.11, 0.04
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   100748k used,  1959712k free,     5632k buffers
Swap:  1214416k total,        0k used,  1214416k free,    58432k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3306 root      20   0 36612  13m  10m S    1  0.7   0:00.30 /usr/kde/4.0/lib/kd
 3607 root      20   0  2048  984  768 R    1  0.0   0:00.02 top -c -b -d 1 -n 5
    1 root      20   0  1612  556  484 S    0  0.0   0:00.21 init [3]           
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
  951 root      16  -4  2612 1452  468 S    0  0.1   0:00.36 /sbin/udevd --daemo
 1892 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 1988 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1989 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2303 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2305 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2319 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2442 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2451 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2452 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2484 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2486 root      15  -5     0    0    0 S    0  0.0   0:00.04 [kcryptd_io]       
 2488 root      15  -5     0    0    0 S    0  0.0   0:00.73 [kcryptd]          
 2559 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2665 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2837 root      20   0  1924  624  480 S    0  0.0   0:00.38 metalog [MASTER]   
 2838 root      20   0  1900  216  120 S    0  0.0   0:00.05 metalog [KERNEL]   
 2847 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2857 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 2926 root      20   0  106m  996  736 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2945 haldaemo  20   0  4768 2928 2272 S    0  0.1   0:00.38 /usr/sbin/hald --us
 2946 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 2992 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2994 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2997 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2998 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3005 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3009 root      20   0  1776  264  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3057 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3064 root      20   0  145m  12m 3512 S    0  0.6   0:00.36 /usr/bin/X -br -nov
 3101 root      20   0  3772 1076  812 S    0  0.1   0:00.00 -:0                
 3122 root      20   0  7040 2292 1560 S    0  0.1   0:00.14 /usr/sbin/cupsd    
 3175 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3231 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3247 root      20   0  2996  536  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3261 root      20   0  4920  948  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3272 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3283 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3284 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3285 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3286 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3287 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3310 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3311 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3344 root      20   0  2500 1248  916 S    0  0.1   0:00.00 /bin/login --      
 3352 thomas    20   0  3232 1616 1304 S    0  0.1   0:00.00 -bash              
 3361 root      20   0  2708 1292  996 S    0  0.1   0:00.00 su                 
 3362 root      20   0  2972 1600 1288 S    0  0.1   0:00.00 bash               
 3366 root      20   0  2972 1004  664 S    0  0.0   0:00.04 bash               


top - 20:18:25 up 1 min,  1 user,  load average: 0.21, 0.11, 0.04
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.0%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   100748k used,  1959712k free,     5632k buffers
Swap:  1214416k total,        0k used,  1214416k free,    58440k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3607 root      20   0  2048  984  768 R    1  0.0   0:00.03 top -c -b -d 1 -n 5
    1 root      20   0  1612  556  484 S    0  0.0   0:00.21 init [3]           
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
  951 root      16  -4  2612 1452  468 S    0  0.1   0:00.36 /sbin/udevd --daemo
 1892 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 1988 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1989 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2303 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2305 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2319 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2442 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2451 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2452 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2484 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2486 root      15  -5     0    0    0 S    0  0.0   0:00.04 [kcryptd_io]       
 2488 root      15  -5     0    0    0 S    0  0.0   0:00.73 [kcryptd]          
 2559 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2665 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2837 root      20   0  1924  624  480 S    0  0.0   0:00.38 metalog [MASTER]   
 2838 root      20   0  1900  216  120 S    0  0.0   0:00.05 metalog [KERNEL]   
 2847 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2857 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 2926 root      20   0  106m  996  736 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2945 haldaemo  20   0  4768 2928 2272 S    0  0.1   0:00.38 /usr/sbin/hald --us
 2946 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 2992 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2994 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2997 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2998 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3005 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3009 root      20   0  1776  264  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3057 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3064 root      20   0  145m  12m 3512 S    0  0.6   0:00.36 /usr/bin/X -br -nov
 3101 root      20   0  3772 1076  812 S    0  0.1   0:00.00 -:0                
 3122 root      20   0  7040 2292 1560 S    0  0.1   0:00.14 /usr/sbin/cupsd    
 3175 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3231 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3247 root      20   0  2996  536  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3261 root      20   0  4920  948  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3272 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3283 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3284 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3285 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3286 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3287 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3306 root      20   0 36612  13m  10m S    0  0.7   0:00.30 /usr/kde/4.0/lib/kd
 3310 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3311 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3344 root      20   0  2500 1248  916 S    0  0.1   0:00.00 /bin/login --      
 3352 thomas    20   0  3232 1616 1304 S    0  0.1   0:00.00 -bash              
 3361 root      20   0  2708 1292  996 S    0  0.1   0:00.00 su                 
 3362 root      20   0  2972 1600 1288 S    0  0.1   0:00.00 bash               
 3366 root      20   0  2972 1004  664 S    0  0.0   0:00.04 bash               


top - 20:18:26 up 1 min,  1 user,  load average: 0.21, 0.11, 0.04
Tasks:  83 total,   1 running,  82 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.5%sy,  0.0%ni, 99.5%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060460k total,   100748k used,  1959712k free,     5632k buffers
Swap:  1214416k total,        0k used,  1214416k free,    58448k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3607 root      20   0  2048  984  768 R    1  0.0   0:00.04 top -c -b -d 1 -n 5
    1 root      20   0  1612  556  484 S    0  0.0   0:00.21 init [3]           
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
  951 root      16  -4  2612 1452  468 S    0  0.1   0:00.36 /sbin/udevd --daemo
 1892 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 1988 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 1989 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2303 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2305 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2319 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2442 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2451 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2452 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2484 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2486 root      15  -5     0    0    0 S    0  0.0   0:00.04 [kcryptd_io]       
 2488 root      15  -5     0    0    0 S    0  0.0   0:00.73 [kcryptd]          
 2559 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2665 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2837 root      20   0  1924  624  480 S    0  0.0   0:00.38 metalog [MASTER]   
 2838 root      20   0  1900  216  120 S    0  0.0   0:00.05 metalog [KERNEL]   
 2847 root      20   0  1604  556  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 2857 messageb  20   0  2264  824  668 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 2926 root      20   0  106m  996  736 S    0  0.0   0:00.00 /usr/sbin/nscd     
 2945 haldaemo  20   0  4768 2928 2272 S    0  0.1   0:00.38 /usr/sbin/hald --us
 2946 root      20   0  3048 1024  864 S    0  0.0   0:00.00 hald-runner        
 2992 root      20   0  3144 1104  952 S    0  0.1   0:00.00 hald-addon-input: L
 2994 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 2997 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 2998 haldaemo  20   0  1904  764  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3005 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3009 root      20   0  1776  264  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3057 root      20   0  3676  684  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3064 root      20   0  145m  12m 3512 S    0  0.6   0:00.36 /usr/bin/X -br -nov
 3101 root      20   0  3772 1076  812 S    0  0.1   0:00.00 -:0                
 3122 root      20   0  7040 2292 1560 S    0  0.1   0:00.14 /usr/sbin/cupsd    
 3175 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3231 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3247 root      20   0  2996  536  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3261 root      20   0  4920  948  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3272 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3283 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3284 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3285 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3286 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3287 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3306 root      20   0 36612  13m  10m S    0  0.7   0:00.30 /usr/kde/4.0/lib/kd
 3310 root      20   0  2812  628  436 S    0  0.0   0:00.00 dbus-launch --autol
 3311 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3344 root      20   0  2500 1248  916 S    0  0.1   0:00.00 /bin/login --      
 3352 thomas    20   0  3232 1616 1304 S    0  0.1   0:00.00 -bash              
 3361 root      20   0  2708 1292  996 S    0  0.1   0:00.00 su                 
 3362 root      20   0  2972 1600 1288 S    0  0.1   0:00.00 bash               
 3366 root      20   0  2972 1004  664 S    0  0.0   0:00.04 bash               

-- vmstat: --
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1959712   5636  58444    0    0   305     0   85  433  3  3 81 13
 0  0      0 1959712   5636  58476    0    0     0     0   22   47  0  0 100  0
 0  0      0 1959712   5636  58476    0    0     0     0   20   55  0  0 100  0
 0  0      0 1959712   5636  58476    0    0     0     0   19   35  0  0 100  0
 0  0      0 1959712   5636  58476    0    0     0     0   23   56  0  0 100  0
-- sched_debug #0: --
Mo 24. Mär 20:18:30 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 103681.177218 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 3
  .load                          : 9363
  .nr_switches                   : 41430
  .nr_load_updates               : 5360
  .nr_uninterruptible            : 4294967203
  .jiffies                       : 4294908401
  .next_balance                  : 4294.908435
  .curr->pid                     : 2488
  .clock                         : 101536.107799
  .idle_clock                    : 92212.631496
  .prev_clock_raw                : 85857.180343
  .clock_warps                   : 0
  .clock_overflows               : 70546
  .clock_underflows              : 1471
  .clock_deep_idle_events        : 16500
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 9363
  .cpu_load[1]                   : 9875
  .cpu_load[2]                   : 10092
  .cpu_load[3]                   : 9482
  .cpu_load[4]                   : 7370

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 31911.373604
  .min_vruntime                  : 31926.889418
  .max_vruntime                  : 31917.010029
  .spread                        : 5.636425
  .spread0                       : 0.000000
  .nr_running                    : 3
  .load                          : 9363
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
       kblockd/0    46     31911.373604       630   115               0               0               0.000000               0.000000               0.000000
     kondemand/0   157     31917.010029       840   115               0               0               0.000000               0.000000               0.000000
R        kcryptd  2488     31907.706758      1957   115               0               0               0.000000               0.000000               0.000000

cpu#1, 1830.936 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 45084
  .nr_load_updates               : 5609
  .nr_uninterruptible            : 94
  .jiffies                       : 4294908401
  .next_balance                  : 4294.908435
  .curr->pid                     : 3610
  .clock                         : 100653.246839
  .idle_clock                    : 93943.536894
  .prev_clock_raw                : 85858.011833
  .clock_warps                   : 0
  .clock_overflows               : 35836
  .clock_underflows              : 1822
  .clock_deep_idle_events        : 17743
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 515
  .cpu_load[3]                   : 284
  .cpu_load[4]                   : 181

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 30473.143898
  .min_vruntime                  : 30473.143898
  .max_vruntime                  : 30473.143898
  .spread                        : 0.000000
  .spread0                       : -1453.745520
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3366     30473.143898       266   120               0               0               0.000000               0.000000               0.000000
R            cat  3610     30453.143899         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #1: --
Mo 24. Mär 20:18:31 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 104714.771850 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 41480
  .nr_load_updates               : 5385
  .nr_uninterruptible            : 4294967202
  .jiffies                       : 4294908711
  .next_balance                  : 4294.908713
  .curr->pid                     : 0
  .clock                         : 102561.639896
  .idle_clock                    : 93174.553188
  .prev_clock_raw                : 86230.149529
  .clock_warps                   : 0
  .clock_overflows               : 70659
  .clock_underflows              : 1487
  .clock_deep_idle_events        : 16594
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 152
  .cpu_load[2]                   : 696
  .cpu_load[3]                   : 1880
  .cpu_load[4]                   : 3483

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 32007.985795
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.936 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 45149
  .nr_load_updates               : 5641
  .nr_uninterruptible            : 94
  .jiffies                       : 4294908711
  .next_balance                  : 4294.908771
  .curr->pid                     : 3613
  .clock                         : 101694.166048
  .idle_clock                    : 94965.496596
  .prev_clock_raw                : 86230.152274
  .clock_warps                   : 0
  .clock_overflows               : 35946
  .clock_underflows              : 1824
  .clock_deep_idle_events        : 17824
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 135
  .cpu_load[4]                   : 95

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 30493.233637
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1514.752158
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3613     30493.233637         2   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #2: --
Mo 24. Mär 20:18:32 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 105719.953933 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 41520
  .nr_load_updates               : 5390
  .nr_uninterruptible            : 4294967202
  .jiffies                       : 4294909012
  .next_balance                  : 4294.909072
  .curr->pid                     : 0
  .clock                         : 103562.450392
  .idle_clock                    : 94174.710993
  .prev_clock_raw                : 86596.350246
  .clock_warps                   : 0
  .clock_overflows               : 70733
  .clock_underflows              : 1487
  .clock_deep_idle_events        : 16623
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 517
  .cpu_load[2]                   : 421
  .cpu_load[3]                   : 1091
  .cpu_load[4]                   : 2584

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 32048.386605
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.936 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 45202
  .nr_load_updates               : 5656
  .nr_uninterruptible            : 94
  .jiffies                       : 4294909012
  .next_balance                  : 4294.909072
  .curr->pid                     : 3616
  .clock                         : 102703.280558
  .idle_clock                    : 95960.891034
  .prev_clock_raw                : 86596.456040
  .clock_warps                   : 0
  .clock_overflows               : 35987
  .clock_underflows              : 1827
  .clock_deep_idle_events        : 17851
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 259
  .cpu_load[3]                   : 144
  .cpu_load[4]                   : 96

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 30553.489116
  .min_vruntime                  : 30553.489116
  .max_vruntime                  : 30553.489116
  .spread                        : 0.000000
  .spread0                       : -1494.897489
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3366     30553.489116       273   120               0               0               0.000000               0.000000               0.000000
R            cat  3616     30533.619241         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #3: --
Mo 24. Mär 20:18:33 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 106725.252512 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 41554
  .nr_load_updates               : 5396
  .nr_uninterruptible            : 4294967202
  .jiffies                       : 4294909314
  .next_balance                  : 4294.909374
  .curr->pid                     : 0
  .clock                         : 104566.152691
  .idle_clock                    : 95174.483499
  .prev_clock_raw                : 86894.383989
  .clock_warps                   : 0
  .clock_overflows               : 70776
  .clock_underflows              : 1488
  .clock_deep_idle_events        : 16647
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 520
  .cpu_load[2]                   : 331
  .cpu_load[3]                   : 616
  .cpu_load[4]                   : 1817

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 32089.767813
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.936 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 45249
  .nr_load_updates               : 5670
  .nr_uninterruptible            : 94
  .jiffies                       : 4294909314
  .next_balance                  : 4294.909374
  .curr->pid                     : 3619
  .clock                         : 103714.069752
  .idle_clock                    : 96958.265535
  .prev_clock_raw                : 86894.377732
  .clock_warps                   : 0
  .clock_overflows               : 36026
  .clock_underflows              : 1830
  .clock_deep_idle_events        : 17875
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 259
  .cpu_load[3]                   : 149
  .cpu_load[4]                   : 100

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 30633.500865
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1456.266948
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3619     30633.500865         1   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #4: --
Mo 24. Mär 20:18:34 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc6-x86-latest.git #2
now at 107730.395903 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.936 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 41593
  .nr_load_updates               : 5402
  .nr_uninterruptible            : 4294967202
  .jiffies                       : 4294909615
  .next_balance                  : 4294.909675
  .curr->pid                     : 3622
  .clock                         : 105570.900399
  .idle_clock                    : 96176.612160
  .prev_clock_raw                : 87267.402632
  .clock_warps                   : 0
  .clock_overflows               : 70848
  .clock_underflows              : 1490
  .clock_deep_idle_events        : 16678
  .clock_max_delta               : 3.333016
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 520
  .cpu_load[2]                   : 315
  .cpu_load[3]                   : 404
  .cpu_load[4]                   : 1295

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 32169.767816
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3622     32169.767817         0   120               0               0               0.000000               0.000000               0.000000

cpu#1, 1830.936 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 45314
  .nr_load_updates               : 5687
  .nr_uninterruptible            : 94
  .jiffies                       : 4294909615
  .next_balance                  : 4294.909617
  .curr->pid                     : 0
  .clock                         : 104724.425571
  .idle_clock                    : 97952.149746
  .prev_clock_raw                : 87266.691972
  .clock_warps                   : 0
  .clock_overflows               : 36074
  .clock_underflows              : 1836
  .clock_deep_idle_events        : 17902
  .clock_max_delta               : 3.333094
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 257
  .cpu_load[3]                   : 141
  .cpu_load[4]                   : 93

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 30653.761087
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1516.006729
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------


--------------010906040507050200020509--

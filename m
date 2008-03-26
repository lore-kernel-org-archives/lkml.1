Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbYCZRrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbYCZRrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758311AbYCZRrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:47:03 -0400
Received: from www17.your-server.de ([213.133.104.17]:38661 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbYCZRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:46:50 -0400
Message-ID: <47EA8BBF.2050403@m3y3r.de>
Date: Wed, 26 Mar 2008 18:45:35 +0100
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080310)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Gary Hade <garyhade@us.ibm.com>
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
References: <47E807EE.2030902@m3y3r.de> <47E8217C.9080400@s5r6.in-berlin.de> <20080325073117.GA8469@elte.hu> <20080325165007.GA7775@elte.hu> <47E94557.4030001@m3y3r.de> <20080325201125.GD15330@elte.hu> <20080325202954.GA22007@elte.hu> <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu>
In-Reply-To: <20080326135458.GA27621@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------030407010603090703020802"
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030407010603090703020802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar schrieb:
> * Ivan Kokshaysky <ink@jurassic.park.msu.ru> wrote:
>
>   
>> Thomas, can you put CONFIG_RESOURCES_64BIT=y back and either revert 
>> commit 8fa5913d54f3b1e09948e6a0db34da887e05ff1f, or just comment out 
>> these two lines in drivers/pci/setup-bus.c:
>>
>> 		if (bus->self->transparent)
>> 			break;
>>
>> and check if it helps?
>>     
>
> alternatively, try x86.git/latest which has the revert below included
Good news everyone.

Everything works again.

lspci -vv:
0c:03.0 FireWire (IEEE 1394): Agere Systems FW323 (rev 61) (prog-if 10 
[OHCI])
        Subsystem: Agere Systems FW323
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR- FastB2B+ DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 248 (3000ns min, 6000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at 94400000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+
        Kernel driver in use: ohci1394
        Kernel modules: firewire-ohci, ohci1394

See also attached cfs-debug-info for config and dmesg.

I tried ingos's x86/latest:

$ git describe
v2.6.25-rc7-684-g74d77fe

thanks to everybody for the help.
thomas

--------------030407010603090703020802
Content-Type: text/plain;
 name="cfs-debug-info-2008.03.26-18.36.37"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="cfs-debug-info-2008.03.26-18.36.37"

-- /proc/sched_debug: --
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 151261.367921 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 118943
  .nr_load_updates               : 45373
  .nr_uninterruptible            : 4294967154
  .jiffies                       : 4294922669
  .next_balance                  : 4294.922705
  .curr->pid                     : 0
  .clock                         : 151234.208162
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1126158.407637
  .clock_warps                   : 0
  .clock_overflows               : 1745
  .clock_underflows              : 43690
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 513
  .cpu_load[2]                   : 296
  .cpu_load[3]                   : 235
  .cpu_load[4]                   : 190

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 36259.444992
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 70823
  .nr_load_updates               : 45296
  .nr_uninterruptible            : 142
  .jiffies                       : 4294922669
  .next_balance                  : 4294.922670
  .curr->pid                     : 3598
  .clock                         : 150977.489635
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1126158.341787
  .clock_warps                   : 0
  .clock_overflows               : 4606
  .clock_underflows              : 40769
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 6
  .cpu_load[3]                   : 60
  .cpu_load[4]                   : 109

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 36361.727318
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 102.282326
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3598     36329.471555         1   120               0               0               0.000000               0.000000               0.000000

-- /proc/*/task/*/sched: --
cqueue (129, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           139.987835
se.vruntime                        :           819.389086
se.sum_exec_runtime                :             0.006942
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  204
ata/0 (133, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34182.341140
se.vruntime                        :         25257.497027
se.sum_exec_runtime                :             3.385600
se.avg_overlap                     :             0.000653
nr_switches                        :                   64
nr_voluntary_switches              :                   64
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
ata/1 (134, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         20968.448598
se.vruntime                        :         22456.042563
se.sum_exec_runtime                :             0.316695
se.avg_overlap                     :             0.000000
nr_switches                        :                   14
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  211
ata_aux (135, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           140.570294
se.vruntime                        :           878.453625
se.sum_exec_runtime                :             0.006629
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kseriod (137, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1340.094796
se.vruntime                        :          2597.656592
se.sum_exec_runtime                :             0.013709
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
kondemand/0 (156, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151203.497513
se.vruntime                        :         36116.306512
se.sum_exec_runtime                :             7.072029
se.avg_overlap                     :             0.005140
nr_switches                        :                 2137
nr_voluntary_switches              :                 2137
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kondemand/1 (157, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150946.833000
se.vruntime                        :         36203.288016
se.sum_exec_runtime                :             5.911471
se.avg_overlap                     :             0.002869
nr_switches                        :                 2138
nr_voluntary_switches              :                 2138
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
pdflush (179, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           208.204169
se.vruntime                        :          1101.966444
se.sum_exec_runtime                :             0.007578
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
pdflush (180, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        126667.252413
se.vruntime                        :         32427.186208
se.sum_exec_runtime                :             2.276072
se.avg_overlap                     :             0.265643
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kswapd0 (181, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           208.455588
se.vruntime                        :          1128.216058
se.sum_exec_runtime                :             0.005831
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
init (1, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        149693.605206
se.vruntime                        :         35016.789031
se.sum_exec_runtime                :           342.065814
se.avg_overlap                     :             0.085120
nr_switches                        :                 1324
nr_voluntary_switches              :                 1315
nr_involuntary_switches            :                    9
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
khpsbpkt (2020, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5359.718881
se.vruntime                        :          8868.096031
se.sum_exec_runtime                :             0.021119
se.avg_overlap                     :             0.000418
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
ksuspend_usbd (2032, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          7547.377391
se.vruntime                        :         12940.710876
se.sum_exec_runtime                :             0.042094
se.avg_overlap                     :             0.000000
nr_switches                        :                    4
nr_voluntary_switches              :                    4
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
khubd (2034, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          7353.448848
se.vruntime                        :         12619.265860
se.sum_exec_runtime                :             4.570803
se.avg_overlap                     :             0.046108
nr_switches                        :                  131
nr_voluntary_switches              :                  131
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
knodemgrd_0 (2046, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          5359.822682
se.vruntime                        :          8868.135237
se.sum_exec_runtime                :             0.199354
se.avg_overlap                     :             0.007896
nr_switches                        :                   16
nr_voluntary_switches              :                   16
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_4 (2216, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          6696.246137
se.vruntime                        :          8984.656672
se.sum_exec_runtime                :             0.004276
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
usb-storage (2217, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        149333.961030
se.vruntime                        :         35247.544327
se.sum_exec_runtime                :             2.779848
se.avg_overlap                     :             0.001231
nr_switches                        :                  548
nr_voluntary_switches              :                  548
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
aio/0 (224, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           455.045751
se.vruntime                        :           265.076805
se.sum_exec_runtime                :             0.005146
se.avg_overlap                     :             0.000089
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
aio/1 (225, #threads: 1)
---------------------------------------------------------
se.exec_start                      :           212.029439
se.vruntime                        :          1272.603943
se.sum_exec_runtime                :             0.006286
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
applesmc-led (2537, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          8929.533408
se.vruntime                        :         12807.924102
se.sum_exec_runtime                :             0.007536
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kdmflush (2581, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          9208.834176
se.vruntime                        :         13583.490465
se.sum_exec_runtime                :             0.013492
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kcryptd_io (2590, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         14450.450366
se.vruntime                        :         13674.288174
se.sum_exec_runtime                :             3.116168
se.avg_overlap                     :             0.037971
nr_switches                        :                  305
nr_voluntary_switches              :                  304
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
kcryptd (2591, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         14730.336685
se.vruntime                        :         16213.203848
se.sum_exec_runtime                :            26.306663
se.avg_overlap                     :             0.190683
nr_switches                        :                   52
nr_voluntary_switches              :                   52
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
kdmflush (2641, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         13466.017543
se.vruntime                        :         14162.831481
se.sum_exec_runtime                :             0.014213
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kcryptd_io (2643, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150938.847083
se.vruntime                        :         36269.283991
se.sum_exec_runtime                :           217.907644
se.avg_overlap                     :             0.031394
nr_switches                        :                 4414
nr_voluntary_switches              :                 4414
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kcryptd (2644, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151196.130171
se.vruntime                        :         35475.736404
se.sum_exec_runtime                :          2783.139110
se.avg_overlap                     :             0.208457
nr_switches                        :                 4010
nr_voluntary_switches              :                 4009
nr_involuntary_switches            :                    1
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  198
kjournald (2698, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        105776.788444
se.vruntime                        :         33190.039313
se.sum_exec_runtime                :             1.624081
se.avg_overlap                     :             0.071880
nr_switches                        :                   14
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
ifplugd (2804, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151160.171749
se.vruntime                        :         36137.124271
se.sum_exec_runtime                :             3.339026
se.avg_overlap                     :             0.038048
nr_switches                        :                  141
nr_voluntary_switches              :                  139
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
metalog (2980, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        148399.510581
se.vruntime                        :         35957.041526
se.sum_exec_runtime                :            22.722001
se.avg_overlap                     :             0.341585
nr_switches                        :                   71
nr_voluntary_switches              :                   63
nr_involuntary_switches            :                    8
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
metalog (2981, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         36677.962798
se.vruntime                        :         25777.308447
se.sum_exec_runtime                :             3.584114
se.avg_overlap                     :             0.126362
nr_switches                        :                   10
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
acpid (2990, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         30140.227428
se.vruntime                        :         24178.142972
se.sum_exec_runtime                :             1.286319
se.avg_overlap                     :             0.019170
nr_switches                        :                   10
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kthreadd (2, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34182.587100
se.vruntime                        :         25257.648867
se.sum_exec_runtime                :             2.024398
se.avg_overlap                     :             0.001015
nr_switches                        :                  226
nr_voluntary_switches              :                  189
nr_involuntary_switches            :                   37
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  180
dbus-daemon (3000, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        145418.036436
se.vruntime                        :         35910.394742
se.sum_exec_runtime                :           177.593813
se.avg_overlap                     :             0.144239
nr_switches                        :                 2930
nr_voluntary_switches              :                 2856
nr_involuntary_switches            :                   74
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3069, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151201.086669
se.vruntime                        :         36197.430762
se.sum_exec_runtime                :            12.545026
se.avg_overlap                     :             0.002585
nr_switches                        :                  620
nr_voluntary_switches              :                  575
nr_involuntary_switches            :                   45
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3070, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        150942.672161
se.vruntime                        :         34174.636661
se.sum_exec_runtime                :             2.706244
se.avg_overlap                     :             0.059103
nr_switches                        :                   66
nr_voluntary_switches              :                   66
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3071, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        150943.151891
se.vruntime                        :         34174.298729
se.sum_exec_runtime                :             3.409187
se.avg_overlap                     :             0.020059
nr_switches                        :                   67
nr_voluntary_switches              :                   67
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
nscd (3072, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151199.719305
se.vruntime                        :         36197.514092
se.sum_exec_runtime                :             2.882717
se.avg_overlap                     :             0.057860
nr_switches                        :                   68
nr_voluntary_switches              :                   68
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3073, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151198.914999
se.vruntime                        :         36205.916213
se.sum_exec_runtime                :             3.066442
se.avg_overlap                     :             0.019790
nr_switches                        :                   62
nr_voluntary_switches              :                   62
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3074, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        150943.973423
se.vruntime                        :         34174.630319
se.sum_exec_runtime                :             3.151435
se.avg_overlap                     :             0.088522
nr_switches                        :                   61
nr_voluntary_switches              :                   61
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3075, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151201.030475
se.vruntime                        :         36197.485917
se.sum_exec_runtime                :             3.257314
se.avg_overlap                     :             0.093435
nr_switches                        :                   61
nr_voluntary_switches              :                   61
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3076, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151201.429710
se.vruntime                        :         36206.229530
se.sum_exec_runtime                :             2.528039
se.avg_overlap                     :             0.014808
nr_switches                        :                   62
nr_voluntary_switches              :                   62
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
nscd (3077, #threads: 9)
---------------------------------------------------------
se.exec_start                      :        151200.213499
se.vruntime                        :         36197.518888
se.sum_exec_runtime                :             2.265092
se.avg_overlap                     :             0.058806
nr_switches                        :                   65
nr_voluntary_switches              :                   65
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald (3088, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        145415.563610
se.vruntime                        :         35890.439659
se.sum_exec_runtime                :           474.699437
se.avg_overlap                     :             0.015512
nr_switches                        :                 2673
nr_voluntary_switches              :                 2492
nr_involuntary_switches            :                  181
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-runner (3089, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         33848.823619
se.vruntime                        :         25665.967747
se.sum_exec_runtime                :            10.507837
se.avg_overlap                     :             0.090320
nr_switches                        :                   92
nr_voluntary_switches              :                   85
nr_involuntary_switches            :                    7
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
hald-addon-inpu (3135, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151144.338236
se.vruntime                        :         36116.947096
se.sum_exec_runtime                :             3.103103
se.avg_overlap                     :             0.097020
nr_switches                        :                  150
nr_voluntary_switches              :                  148
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-addon-macb (3137, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         20480.367169
se.vruntime                        :         22299.656832
se.sum_exec_runtime                :             3.500108
se.avg_overlap                     :             0.126109
nr_switches                        :                   19
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                   10
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-addon-cpuf (3140, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         20487.391695
se.vruntime                        :         22068.159901
se.sum_exec_runtime                :             2.173257
se.avg_overlap                     :             0.037740
nr_switches                        :                   28
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                   20
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
hald-addon-acpi (3141, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         20487.415787
se.vruntime                        :         22068.096044
se.sum_exec_runtime                :             1.364852
se.avg_overlap                     :             0.071972
nr_switches                        :                   18
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    7
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
dhcpcd (3147, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         20793.004741
se.vruntime                        :         22238.871326
se.sum_exec_runtime                :             0.153340
se.avg_overlap                     :             0.000000
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
hald-addon-stor (3159, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        149077.341369
se.vruntime                        :         35186.030201
se.sum_exec_runtime                :             7.697281
se.avg_overlap                     :             0.020435
nr_switches                        :                  167
nr_voluntary_switches              :                  143
nr_involuntary_switches            :                   24
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kdm (3201, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         48820.483232
se.vruntime                        :         26657.074468
se.sum_exec_runtime                :             2.617817
se.avg_overlap                     :             0.064998
nr_switches                        :                  150
nr_voluntary_switches              :                  147
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
X (3212, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150930.229282
se.vruntime                        :         36321.789889
se.sum_exec_runtime                :         10671.765792
se.avg_overlap                     :             0.849540
nr_switches                        :                41038
nr_voluntary_switches              :                13679
nr_involuntary_switches            :                27359
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
kdm (3251, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         48592.616967
se.vruntime                        :         29124.558995
se.sum_exec_runtime                :            10.808593
se.avg_overlap                     :             0.049049
nr_switches                        :                  356
nr_voluntary_switches              :                  354
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
cupsd (3265, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         33444.515142
se.vruntime                        :         24378.476302
se.sum_exec_runtime                :           171.663269
se.avg_overlap                     :             3.089987
nr_switches                        :                  121
nr_voluntary_switches              :                   86
nr_involuntary_switches            :                   35
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
ifplugd (3318, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        145083.887647
se.vruntime                        :         33702.528420
se.sum_exec_runtime                :             0.759215
se.avg_overlap                     :             0.008822
nr_switches                        :                   20
nr_voluntary_switches              :                   20
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
pktcdvd0 (3372, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         33925.942349
se.vruntime                        :         25903.812672
se.sum_exec_runtime                :             0.009656
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                88761
policy                             :                    0
prio                               :                  100
clock-delta                        :                  192
smartd (3389, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         34798.545180
se.vruntime                        :         25487.750481
se.sum_exec_runtime                :             0.902363
se.avg_overlap                     :             0.005020
nr_switches                        :                    3
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
sshd (3403, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         35947.142620
se.vruntime                        :         26463.971776
se.sum_exec_runtime                :             0.701235
se.avg_overlap                     :             0.000531
nr_switches                        :                    4
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
cron (3414, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        114535.912090
se.vruntime                        :         31204.798748
se.sum_exec_runtime                :             1.197374
se.avg_overlap                     :             0.006816
nr_switches                        :                   20
nr_voluntary_switches              :                   15
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
agetty (3422, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37498.676454
se.vruntime                        :         26902.962747
se.sum_exec_runtime                :             1.990191
se.avg_overlap                     :             0.028760
nr_switches                        :                   13
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3425, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37755.871574
se.vruntime                        :         26272.620468
se.sum_exec_runtime                :             1.995879
se.avg_overlap                     :             0.091110
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3426, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37499.362224
se.vruntime                        :         26902.430091
se.sum_exec_runtime                :             1.582660
se.avg_overlap                     :             0.042225
nr_switches                        :                   14
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    2
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3427, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37755.690839
se.vruntime                        :         26272.704536
se.sum_exec_runtime                :             1.758523
se.avg_overlap                     :             0.031409
nr_switches                        :                   12
nr_voluntary_switches              :                   11
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3428, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37756.247407
se.vruntime                        :         26272.616007
se.sum_exec_runtime                :             1.566728
se.avg_overlap                     :             0.030114
nr_switches                        :                   14
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
agetty (3429, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         37499.462523
se.vruntime                        :         26902.919847
se.sum_exec_runtime                :             1.597316
se.avg_overlap                     :             0.076478
nr_switches                        :                   14
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
dbus-launch (3452, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         60942.472916
se.vruntime                        :         31768.445428
se.sum_exec_runtime                :             0.667579
se.avg_overlap                     :             0.004321
nr_switches                        :                   18
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                   13
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
dbus-daemon (3453, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         48841.392424
se.vruntime                        :         26657.612253
se.sum_exec_runtime                :             2.388043
se.avg_overlap                     :             0.009888
nr_switches                        :                   29
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                   19
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
startkde (3461, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         52619.470202
se.vruntime                        :         28349.003884
se.sum_exec_runtime                :            32.983398
se.avg_overlap                     :             0.052767
nr_switches                        :                  101
nr_voluntary_switches              :                   72
nr_involuntary_switches            :                   29
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
dbus-launch (3512, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         60942.451125
se.vruntime                        :         31758.495385
se.sum_exec_runtime                :             0.641521
se.avg_overlap                     :             0.022747
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
dbus-daemon (3513, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150532.235251
se.vruntime                        :         36134.106542
se.sum_exec_runtime                :           155.849399
se.avg_overlap                     :             0.060241
nr_switches                        :                 2295
nr_voluntary_switches              :                 1939
nr_involuntary_switches            :                  356
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kdeinit4 (3518, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        125380.687622
se.vruntime                        :         34343.296020
se.sum_exec_runtime                :            34.479396
se.avg_overlap                     :             0.077749
nr_switches                        :                  231
nr_voluntary_switches              :                  214
nr_involuntary_switches            :                   17
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
klauncher (3519, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        139128.101427
se.vruntime                        :         35002.047458
se.sum_exec_runtime                :           113.772804
se.avg_overlap                     :             0.056922
nr_switches                        :                  317
nr_voluntary_switches              :                  252
nr_involuntary_switches            :                   65
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kded4 (3521, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        149200.332759
se.vruntime                        :         35960.508312
se.sum_exec_runtime                :           602.087886
se.avg_overlap                     :             0.145775
nr_switches                        :                 1381
nr_voluntary_switches              :                  846
nr_involuntary_switches            :                  535
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
gam_server (3523, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        139808.017987
se.vruntime                        :         35113.591714
se.sum_exec_runtime                :             2.931119
se.avg_overlap                     :             0.045250
nr_switches                        :                   17
nr_voluntary_switches              :                   17
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
kwrapper4 (3528, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150756.851261
se.vruntime                        :         35795.910868
se.sum_exec_runtime                :             5.307032
se.avg_overlap                     :             0.002633
nr_switches                        :                  104
nr_voluntary_switches              :                  103
nr_involuntary_switches            :                    1
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
ksmserver (3530, #threads: 2)
---------------------------------------------------------
se.exec_start                      :        150531.343616
se.vruntime                        :         36114.376755
se.sum_exec_runtime                :           148.358812
se.avg_overlap                     :             0.155888
nr_switches                        :                  604
nr_voluntary_switches              :                  516
nr_involuntary_switches            :                   88
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
ksmserver (3533, #threads: 2)
---------------------------------------------------------
se.exec_start                      :         53109.828789
se.vruntime                        :         30586.198745
se.sum_exec_runtime                :             0.097928
se.avg_overlap                     :             0.000000
nr_switches                        :                    3
nr_voluntary_switches              :                    3
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kwin (3535, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151145.529190
se.vruntime                        :         36134.939450
se.sum_exec_runtime                :           641.398736
se.avg_overlap                     :             0.107131
nr_switches                        :                 8789
nr_voluntary_switches              :                 8241
nr_involuntary_switches            :                  548
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
plasma (3538, #threads: 3)
---------------------------------------------------------
se.exec_start                      :        151145.464722
se.vruntime                        :         36117.153813
se.sum_exec_runtime                :          2523.574034
se.avg_overlap                     :             0.827301
nr_switches                        :                10255
nr_voluntary_switches              :                 6230
nr_involuntary_switches            :                 4025
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
plasma (3540, #threads: 3)
---------------------------------------------------------
se.exec_start                      :         54803.495368
se.vruntime                        :         31134.161223
se.sum_exec_runtime                :           140.198126
se.avg_overlap                     :             1.219974
nr_switches                        :                   33
nr_voluntary_switches              :                    9
nr_involuntary_switches            :                   24
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
plasma (3556, #threads: 3)
---------------------------------------------------------
se.exec_start                      :        145414.483848
se.vruntime                        :         35909.529999
se.sum_exec_runtime                :             0.135129
se.avg_overlap                     :             0.001439
nr_switches                        :                    8
nr_voluntary_switches              :                    8
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
knotify4 (3539, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150532.032809
se.vruntime                        :         36121.062811
se.sum_exec_runtime                :           622.665257
se.avg_overlap                     :             0.248037
nr_switches                        :                  435
nr_voluntary_switches              :                  237
nr_involuntary_switches            :                  198
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kio_file (3541, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         58407.183193
se.vruntime                        :         31435.342772
se.sum_exec_runtime                :            16.972966
se.avg_overlap                     :             0.136747
nr_switches                        :                   17
nr_voluntary_switches              :                   14
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
krunner (3543, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        149670.296867
se.vruntime                        :         35992.653205
se.sum_exec_runtime                :          1013.071884
se.avg_overlap                     :             0.054566
nr_switches                        :                17506
nr_voluntary_switches              :                16547
nr_involuntary_switches            :                  959
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
krunner (3568, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        138747.408964
se.vruntime                        :         34853.012443
se.sum_exec_runtime                :            60.223538
se.avg_overlap                     :             0.089255
nr_switches                        :                  339
nr_voluntary_switches              :                  241
nr_involuntary_switches            :                   98
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
krunner (3569, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        138741.025349
se.vruntime                        :         34835.687763
se.sum_exec_runtime                :            12.253386
se.avg_overlap                     :             0.243295
nr_switches                        :                  254
nr_voluntary_switches              :                  254
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
krunner (3570, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        138488.668383
se.vruntime                        :         34788.453999
se.sum_exec_runtime                :            14.342224
se.avg_overlap                     :             0.450778
nr_switches                        :                  227
nr_voluntary_switches              :                  224
nr_involuntary_switches            :                    3
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
krunner (3571, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        138740.999822
se.vruntime                        :         34836.097111
se.sum_exec_runtime                :            15.198897
se.avg_overlap                     :             0.043386
nr_switches                        :                  294
nr_voluntary_switches              :                  159
nr_involuntary_switches            :                  135
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
krunner (3582, #threads: 6)
---------------------------------------------------------
se.exec_start                      :        138613.568377
se.vruntime                        :         34860.888959
se.sum_exec_runtime                :             0.038365
se.avg_overlap                     :             0.000000
nr_switches                        :                    1
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                    0
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kaccess (3552, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        149712.632885
se.vruntime                        :         36113.537276
se.sum_exec_runtime                :            82.423056
se.avg_overlap                     :             0.073574
nr_switches                        :                  487
nr_voluntary_switches              :                  342
nr_involuntary_switches            :                  145
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  198
kmix (3553, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        145652.406155
se.vruntime                        :         35960.538103
se.sum_exec_runtime                :           183.829335
se.avg_overlap                     :             0.089194
nr_switches                        :                  740
nr_voluntary_switches              :                  319
nr_involuntary_switches            :                  421
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
konqueror (3562, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        145651.391378
se.vruntime                        :         35960.159622
se.sum_exec_runtime                :           849.046931
se.avg_overlap                     :             0.485215
nr_switches                        :                 1760
nr_voluntary_switches              :                  632
nr_involuntary_switches            :                 1128
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kio_file (3564, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        116324.568330
se.vruntime                        :         33476.024999
se.sum_exec_runtime                :            14.294816
se.avg_overlap                     :             0.272828
nr_switches                        :                   73
nr_voluntary_switches              :                   48
nr_involuntary_switches            :                   25
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kio_file (3565, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        116323.955874
se.vruntime                        :         33475.672773
se.sum_exec_runtime                :            14.724062
se.avg_overlap                     :             0.124607
nr_switches                        :                   73
nr_voluntary_switches              :                   61
nr_involuntary_switches            :                   12
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kio_file (3566, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        116323.918236
se.vruntime                        :         33466.371457
se.sum_exec_runtime                :            14.957771
se.avg_overlap                     :             0.246057
nr_switches                        :                   62
nr_voluntary_switches              :                   57
nr_involuntary_switches            :                    5
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kio_file (3567, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        116324.608221
se.vruntime                        :         33476.086819
se.sum_exec_runtime                :            13.852074
se.avg_overlap                     :             0.137289
nr_switches                        :                   74
nr_voluntary_switches              :                   51
nr_involuntary_switches            :                   23
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
konsole (3573, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150986.839393
se.vruntime                        :         36302.568522
se.sum_exec_runtime                :           550.019101
se.avg_overlap                     :             0.330670
nr_switches                        :                 2162
nr_voluntary_switches              :                 2076
nr_involuntary_switches            :                   86
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  193
bash (3574, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        147087.028974
se.vruntime                        :         34273.714563
se.sum_exec_runtime                :            11.806853
se.avg_overlap                     :             0.116955
nr_switches                        :                   46
nr_voluntary_switches              :                   42
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
kate (3583, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150989.209514
se.vruntime                        :         36324.745004
se.sum_exec_runtime                :           824.759642
se.avg_overlap                     :             0.522887
nr_switches                        :                 1544
nr_voluntary_switches              :                 1178
nr_involuntary_switches            :                  366
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
su (3585, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        148458.873009
se.vruntime                        :         36032.675636
se.sum_exec_runtime                :             9.975685
se.avg_overlap                     :             0.027865
nr_switches                        :                   59
nr_voluntary_switches              :                   34
nr_involuntary_switches            :                   25
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
bash (3588, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151145.053555
se.vruntime                        :         36137.361782
se.sum_exec_runtime                :            11.308538
se.avg_overlap                     :             0.109175
nr_switches                        :                   31
nr_voluntary_switches              :                   17
nr_involuntary_switches            :                   14
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
bash (3593, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150984.510426
se.vruntime                        :         36367.461166
se.sum_exec_runtime                :             8.305055
se.avg_overlap                     :             0.696948
nr_switches                        :                   14
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    4
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  192
migration/0 (3, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :             0.010846
se.sum_exec_runtime                :             1.083644
se.avg_overlap                     :             0.000117
nr_switches                        :                  279
nr_voluntary_switches              :                  279
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  192
kblockd/0 (46, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151218.053225
se.vruntime                        :         36197.950702
se.sum_exec_runtime                :            11.294063
se.avg_overlap                     :             0.017006
nr_switches                        :                  708
nr_voluntary_switches              :                  708
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
kblockd/1 (47, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        141827.428912
se.vruntime                        :         35374.176153
se.sum_exec_runtime                :             5.963892
se.avg_overlap                     :             0.000000
nr_switches                        :                  191
nr_voluntary_switches              :                  191
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kacpid (49, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        140506.824871
se.vruntime                        :         35214.838016
se.sum_exec_runtime                :             9.956107
se.avg_overlap                     :             0.035579
nr_switches                        :                  603
nr_voluntary_switches              :                  603
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
ksoftirqd/0 (4, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        151234.208162
se.vruntime                        :         36138.617040
se.sum_exec_runtime                :            19.106159
se.avg_overlap                     :             0.003594
nr_switches                        :                 6339
nr_voluntary_switches              :                 6335
nr_involuntary_switches            :                    4
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  193
kacpi_notify (50, #threads: 1)
---------------------------------------------------------
se.exec_start                      :            71.391840
se.vruntime                        :           333.673947
se.sum_exec_runtime                :             0.005860
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
migration/1 (5, #threads: 1)
---------------------------------------------------------
se.exec_start                      :             0.000000
se.vruntime                        :            -4.327297
se.sum_exec_runtime                :             0.829194
se.avg_overlap                     :             0.000081
nr_switches                        :                  239
nr_voluntary_switches              :                  239
nr_involuntary_switches            :                    0
se.load.weight                     :               177522
policy                             :                    1
prio                               :                    0
clock-delta                        :                  192
ksoftirqd/1 (6, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150984.529515
se.vruntime                        :         36058.852652
se.sum_exec_runtime                :            13.621712
se.avg_overlap                     :             0.004844
nr_switches                        :                 5827
nr_voluntary_switches              :                 5827
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
events/0 (7, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150440.198919
se.vruntime                        :         35764.062558
se.sum_exec_runtime                :             9.309471
se.avg_overlap                     :             0.009927
nr_switches                        :                  508
nr_voluntary_switches              :                  508
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_0 (844, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          4639.415453
se.vruntime                        :         12165.201289
se.sum_exec_runtime                :             0.849999
se.avg_overlap                     :             0.002522
nr_switches                        :                   12
nr_voluntary_switches              :                   12
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_1 (846, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1153.374788
se.vruntime                        :          6212.425995
se.sum_exec_runtime                :             3.452896
se.avg_overlap                     :             0.000093
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_2 (851, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1333.946420
se.vruntime                        :          2690.682792
se.sum_exec_runtime                :            18.293982
se.avg_overlap                     :             0.000455
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
scsi_eh_3 (853, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1590.612331
se.vruntime                        :          6242.524147
se.sum_exec_runtime                :             3.427602
se.avg_overlap                     :             0.000084
nr_switches                        :                    5
nr_voluntary_switches              :                    5
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kstriped (874, #threads: 1)
---------------------------------------------------------
se.exec_start                      :          1340.276396
se.vruntime                        :          2768.843634
se.sum_exec_runtime                :             0.006702
se.avg_overlap                     :             0.000000
nr_switches                        :                    2
nr_voluntary_switches              :                    2
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
kjournald (880, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        126733.245266
se.vruntime                        :         32425.286217
se.sum_exec_runtime                :             0.550650
se.avg_overlap                     :             0.000000
nr_switches                        :                   10
nr_voluntary_switches              :                   10
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
events/1 (8, #threads: 1)
---------------------------------------------------------
se.exec_start                      :        150190.213170
se.vruntime                        :         34965.277318
se.sum_exec_runtime                :             1.004177
se.avg_overlap                     :             0.001562
nr_switches                        :                  170
nr_voluntary_switches              :                  170
nr_involuntary_switches            :                    0
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
udevd (950, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         36483.480849
se.vruntime                        :         26853.427444
se.sum_exec_runtime                :           506.987427
se.avg_overlap                     :             0.505956
nr_switches                        :                  942
nr_voluntary_switches              :                  257
nr_involuntary_switches            :                  685
se.load.weight                     :                 2501
policy                             :                    0
prio                               :                  116
clock-delta                        :                  192
khelper (9, #threads: 1)
---------------------------------------------------------
se.exec_start                      :         53063.962382
se.vruntime                        :         30581.875495
se.sum_exec_runtime                :            12.135054
se.avg_overlap                     :             0.002314
nr_switches                        :                 1757
nr_voluntary_switches              :                 1739
nr_involuntary_switches            :                   18
se.load.weight                     :                 3121
policy                             :                    0
prio                               :                  115
clock-delta                        :                  192
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
firmware_class          9216  0 
fuse                   43932  1 
snd_seq                45760  0 
snd_seq_device          7692  1 snd_seq
nls_iso8859_15          4864  1 
nls_cp850               5120  1 
vfat                   12416  1 
fat                    46880  1 vfat
applesmc               19372  0 
input_polldev           5128  1 applesmc
led_class               5380  1 applesmc
dummy                   3584  0 
binfmt_misc            11144  1 
tun                    11008  0 
pktcdvd                32068  1 
loop                   16516  0 
msr                     4612  0 
cpuid                   4484  0 
coretemp                7680  0 
eeprom                  7312  0 
cpufreq_powersave       1920  0 
cpufreq_conservative     7560  0 
acpi_cpufreq            8972  1 
usbhid                 21156  0 
appletouch              9472  0 
usb_storage            70920  0 
snd_hda_intel         302360  1 
firewire_ohci          17792  0 
i2c_i801                9360  0 
i2c_core               22548  2 eeprom,i2c_i801
rng_core                4996  0 
iTCO_wdt               11172  0 
firewire_core          39456  1 firewire_ohci
snd_pcm                61060  1 snd_hda_intel
evdev                  11136  12 
snd_timer              21128  2 snd_seq,snd_pcm
uhci_hcd               22288  0 
ehci_hcd               32012  0 
snd                    43432  7 snd_seq,snd_seq_device,snd_hda_intel,snd_pcm,snd_timer
ohci1394               29232  0 
soundcore               7496  1 snd
usbcore               127048  6 usbhid,appletouch,usb_storage,uhci_hcd,ehci_hcd
ieee1394               80644  1 ohci1394
thermal                18972  0 
battery                13188  0 
ac                      6148  0 
button                  8336  0 
tpm_infineon            8872  0 
tpm                    15012  1 tpm_infineon
tpm_bios                6400  1 tpm
intel_agp              25156  0 
sg                     29748  0 
snd_page_alloc         10120  2 snd_hda_intel,snd_pcm
processor              39112  4 acpi_cpufreq,thermal
sr_mod                 16424  1 
cdrom                  32284  2 pktcdvd,sr_mod
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
0xf8822000-0xf8823000           4K     RW             GLB x  pte
0xf8823000-0xf8824000           4K                           pte
0xf8824000-0xf8825000           4K     RW PWT PCD     GLB x  pte
0xf8825000-0xf8826000           4K                           pte
0xf8826000-0xf8827000           4K     RW PWT PCD     GLB x  pte
0xf8827000-0xf8828000           4K                           pte
0xf8828000-0xf882c000          16K     RW PWT PCD     GLB x  pte
0xf882c000-0xf882d000           4K                           pte
0xf882d000-0xf8832000          20K     RW             GLB x  pte
0xf8832000-0xf8834000           8K                           pte
0xf8834000-0xf8835000           4K     RW PWT PCD     GLB x  pte
0xf8835000-0xf8836000           4K                           pte
0xf8836000-0xf8837000           4K     RW PWT PCD     GLB x  pte
0xf8837000-0xf8838000           4K                           pte
0xf8838000-0xf8840000          32K     RW             GLB x  pte
0xf8840000-0xf8841000           4K                           pte
0xf8841000-0xf8845000          16K     RW             GLB x  pte
0xf8845000-0xf8846000           4K                           pte
0xf8846000-0xf8849000          12K     RW             GLB x  pte
0xf8849000-0xf884a000           4K                           pte
0xf884a000-0xf884c000           8K     RW             GLB x  pte
0xf884c000-0xf884d000           4K                           pte
0xf884d000-0xf884e000           4K     RW             GLB x  pte
0xf884e000-0xf884f000           4K                           pte
0xf884f000-0xf8859000          40K     RW             GLB x  pte
0xf8859000-0xf885a000           4K                           pte
0xf885a000-0xf885e000          16K     RW             GLB x  pte
0xf885e000-0xf885f000           4K                           pte
0xf885f000-0xf8862000          12K     RW             GLB x  pte
0xf8862000-0xf8863000           4K                           pte
0xf8863000-0xf8864000           4K     RW             GLB x  pte
0xf8864000-0xf8865000           4K                           pte
0xf8865000-0xf886d000          32K     RW             GLB x  pte
0xf886d000-0xf886e000           4K                           pte
0xf886e000-0xf8875000          28K     RW             GLB x  pte
0xf8875000-0xf8876000           4K                           pte
0xf8876000-0xf8879000          12K     RW             GLB x  pte
0xf8879000-0xf887a000           4K                           pte
0xf887a000-0xf887c000           8K     RW             GLB x  pte
0xf887c000-0xf887e000           8K                           pte
0xf887e000-0xf887f000           4K     RW PWT PCD     GLB x  pte
0xf887f000-0xf8881000           8K                           pte
0xf8881000-0xf8883000           8K     RW             GLB x  pte
0xf8883000-0xf8884000           4K                           pte
0xf8884000-0xf8889000          20K     RW             GLB x  pte
0xf8889000-0xf888a000           4K                           pte
0xf888a000-0xf8892000          32K     RW             GLB x  pte
0xf8892000-0xf8894000           8K                           pte
0xf8894000-0xf889c000          32K     RW             GLB x  pte
0xf889c000-0xf889e000           8K                           pte
0xf889e000-0xf889f000           4K     RW PWT PCD     GLB x  pte
0xf889f000-0xf88a0000           4K                           pte
0xf88a0000-0xf88a2000           8K     RW             GLB x  pte
0xf88a2000-0xf88a3000           4K                           pte
0xf88a3000-0xf88b7000          80K     RW             GLB x  pte
0xf88b7000-0xf88b8000           4K                           pte
0xf88b8000-0xf88bb000          12K     RW             GLB x  pte
0xf88bb000-0xf88bd000           8K                           pte
0xf88bd000-0xf88c0000          12K     RW             GLB x  pte
0xf88c0000-0xf88c2000           8K                           pte
0xf88c2000-0xf88c3000           4K     RW PWT PCD     GLB x  pte
0xf88c3000-0xf88c4000           4K                           pte
0xf88c4000-0xf88c5000           4K     RW             GLB x  pte
0xf88c5000-0xf88c6000           4K                           pte
0xf88c6000-0xf88d1000          44K     RW             GLB x  pte
0xf88d1000-0xf88d2000           4K                           pte
0xf88d2000-0xf88d8000          24K     RW             GLB x  pte
0xf88d8000-0xf88d9000           4K                           pte
0xf88d9000-0xf88db000           8K     RW             GLB x  pte
0xf88db000-0xf88dc000           4K                           pte
0xf88dc000-0xf88de000           8K     RW             GLB x  pte
0xf88de000-0xf88df000           4K                           pte
0xf88df000-0xf88ff000         128K     RW             GLB x  pte
0xf88ff000-0xf8900000           4K                           pte
0xf8900000-0xf8906000          24K     RW             GLB x  pte
0xf8906000-0xf8908000           8K                           pte
0xf8908000-0xf890c000          16K     RW PWT PCD     GLB x  pte
0xf890c000-0xf890f000          12K                           pte
0xf890f000-0xf8915000          24K     RW             GLB x  pte
0xf8915000-0xf8916000           4K                           pte
0xf8916000-0xf8919000          12K     RW             GLB x  pte
0xf8919000-0xf891a000           4K                           pte
0xf891a000-0xf8929000          60K     RW             GLB x  pte
0xf8929000-0xf892a000           4K                           pte
0xf892a000-0xf8934000          40K     RW             GLB x  pte
0xf8934000-0xf8935000           4K                           pte
0xf8935000-0xf893a000          20K     RW             GLB x  pte
0xf893a000-0xf8940000          24K                           pte
0xf8940000-0xf8943000          12K     RW             GLB x  pte
0xf8943000-0xf8944000           4K                           pte
0xf8944000-0xf8947000          12K     RW             GLB x  pte
0xf8947000-0xf8948000           4K                           pte
0xf8948000-0xf894a000           8K     RW             GLB x  pte
0xf894a000-0xf894c000           8K                           pte
0xf894c000-0xf8952000          24K     RW             GLB x  pte
0xf8952000-0xf8953000           4K                           pte
0xf8953000-0xf8965000          72K     RW             GLB x  pte
0xf8965000-0xf8966000           4K                           pte
0xf8966000-0xf8968000           8K     RW             GLB x  pte
0xf8968000-0xf8969000           4K                           pte
0xf8969000-0xf896b000           8K     RW             GLB x  pte
0xf896b000-0xf896c000           4K                           pte
0xf896c000-0xf896f000          12K     RW             GLB x  pte
0xf896f000-0xf8970000           4K                           pte
0xf8970000-0xf8972000           8K     RW             GLB x  pte
0xf8972000-0xf8973000           4K                           pte
0xf8973000-0xf8978000          20K     RW             GLB x  pte
0xf8978000-0xf8979000           4K                           pte
0xf8979000-0xf897c000          12K     RW             GLB x  pte
0xf897c000-0xf897d000           4K                           pte
0xf897d000-0xf897f000           8K     RW             GLB x  pte
0xf897f000-0xf8980000           4K                           pte
0xf8980000-0xf8982000           8K     RW             GLB x  pte
0xf8982000-0xf8984000           8K                           pte
0xf8984000-0xf898c000          32K     RW             GLB x  pte
0xf898c000-0xf898d000           4K                           pte
0xf898d000-0xf8991000          16K     RW             GLB x  pte
0xf8991000-0xf8992000           4K                           pte
0xf8992000-0xf8994000           8K     RW             GLB x  pte
0xf8994000-0xf8995000           4K                           pte
0xf8995000-0xf899a000          20K     RW             GLB x  pte
0xf899a000-0xf899b000           4K                           pte
0xf899b000-0xf899d000           8K     RW             GLB x  pte
0xf899d000-0xf899e000           4K                           pte
0xf899e000-0xf89e8000         296K     RW             GLB x  pte
0xf89e8000-0xf89e9000           4K                           pte
0xf89e9000-0xf89ec000          12K     RW             GLB x  pte
0xf89ec000-0xf89f8000          48K                           pte
0xf89f8000-0xf8a04000          48K     RW             GLB x  pte
0xf8a04000-0xf8a05000           4K                           pte
0xf8a05000-0xf8a9a000         596K     RW             GLB x  pte
0xf8a9a000-0xf8a9b000           4K                           pte
0xf8a9b000-0xf8aa7000          48K     RW             GLB x  pte
0xf8aa7000-0xf8aa8000           4K                           pte
0xf8aa8000-0xf8ab3000          44K     RW             GLB x  pte
0xf8ab3000-0xf8c00000        1332K                           pte
0xf8c00000-0xff800000         108M                           pgd
---[ vmalloc() End ]---
0xff800000-0xff801000           4K                           pte
---[ Persisent kmap() Area ]---
0xff801000-0xffb5c000        3436K     RW             GLB x  pte
0xffb5c000-0xfff9b000        4348K                           pte
---[ Fixmap Area ]---
0xfff9b000-0xfff9c000           4K                           pte
0xfff9c000-0xfff9d000           4K     RW PWT PCD     GLB x  pte
0xfff9d000-0xfff9e000           4K     RW             GLB x  pte
0xfff9e000-0xffffa000         368K                           pte
0xffffa000-0xffffc000           8K     RW PWT PCD     GLB x  pte
0xffffc000-0x00000000          16K                           pte
-- interrupts: --
           CPU0       CPU1       
  0:      45467          0   IO-APIC-edge      timer
  9:       3547          0   IO-APIC-fasteoi   acpi
 14:         83          0   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:         40          0   IO-APIC-fasteoi   uhci_hcd:usb5
 18:         41          0   IO-APIC-fasteoi   uhci_hcd:usb4
 19:       6442          0   IO-APIC-fasteoi   ata_piix, ohci1394, uhci_hcd:usb3
 22:        305          0   IO-APIC-fasteoi   HDA Intel
 23:       3342          0   IO-APIC-fasteoi   ehci_hcd:usb1, uhci_hcd:usb2
219:         13          0   PCI-MSI-edge      eth0
NMI:      45436      45368   Non-maskable interrupts
LOC:          0      45358   Local timer interrupts
RES:        775        929   Rescheduling interrupts
CAL:        191        146   function call interrupts
TLB:        259        361   TLB shootdowns
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
bogomips	: 3667.37
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
bogomips	: 3663.48
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
MemTotal:      2060888 kB
MemFree:       1829404 kB
Buffers:         11304 kB
Cached:          91384 kB
SwapCached:          0 kB
Active:         146120 kB
Inactive:        62640 kB
HighTotal:     1164064 kB
HighFree:       963852 kB
LowTotal:       896824 kB
LowFree:        865552 kB
SwapTotal:     1214416 kB
SwapFree:      1214416 kB
Dirty:             232 kB
Writeback:           0 kB
AnonPages:      105972 kB
Mapped:          40064 kB
Slab:            13748 kB
SReclaimable:     6984 kB
SUnreclaim:       6764 kB
PageTables:       2000 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2244860 kB
Committed_AS:   203456 kB
VmallocTotal:   114680 kB
VmallocUsed:      2656 kB
VmallocChunk:   111912 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     4096 kB
-- buddyinfo: --
Node 0, zone      DMA      5      4      5      5      5      2      3      2      2      2      1 
Node 0, zone   Normal      1      3      3      3      0      2      1      2      1      1    207 
Node 0, zone  HighMem      1      1      2      1      3      2      1      1      2      1    234 
-- vmstat: --
nr_free_pages 457351
nr_inactive 15660
nr_active 36530
nr_anon_pages 26493
nr_mapped 10016
nr_file_pages 25672
nr_dirty 58
nr_writeback 0
nr_slab_reclaimable 1746
nr_slab_unreclaimable 1691
nr_page_table_pages 500
nr_unstable 0
nr_bounce 0
nr_vmscan_write 0
pgpgin 101987
pgpgout 1828
pswpin 0
pswpout 0
pgalloc_dma 1
pgalloc_normal 68189
pgalloc_high 165462
pgalloc_movable 0
pgfree 691245
pgactivate 10919
pgdeactivate 0
pgfault 621042
pgmajfault 1089
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
  pages free     3225
        min      17
        low      21
        high     25
        scanned  0 (a: 0 i: 0)
        spanned  4096
        present  4064
    nr_free_pages 3225
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
  pages free     213163
        min      936
        low      1170
        high     1404
        scanned  0 (a: 0 i: 0)
        spanned  225280
        present  223520
    nr_free_pages 213163
    nr_inactive  979
    nr_active    1847
    nr_anon_pages 0
    nr_mapped    1
    nr_file_pages 2826
    nr_dirty     15
    nr_writeback 0
    nr_slab_reclaimable 1746
    nr_slab_unreclaimable 1690
    nr_page_table_pages 500
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
        protection: (0, 0, 9023, 9023)
  pagesets
    cpu: 0
              count: 67
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 68
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
Node 0, zone  HighMem
  pages free     240963
        min      128
        low      430
        high     733
        scanned  0 (a: 0 i: 0)
        spanned  291016
        present  288743
    nr_free_pages 240963
    nr_inactive  14681
    nr_active    34683
    nr_anon_pages 26493
    nr_mapped    10015
    nr_file_pages 22846
    nr_dirty     43
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
              count: 50
              high:  186
              batch: 31
  vm stats threshold: 20
    cpu: 1
              count: 57
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
Node    0, zone      DMA, type      Movable      4      3      4      4      4      1      2      1      1      1      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone   Normal, type    Unmovable      0      1      2      1      0      1      1      1      0      1      0 
Node    0, zone   Normal, type  Reclaimable      0      1      1      1      0      0      0      0      1      0      0 
Node    0, zone   Normal, type      Movable      1      1      0      1      0      1      0      1      0      0    206 
Node    0, zone   Normal, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone   Normal, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type    Unmovable      0      0      1      0      2      1      1      0      1      0      0 
Node    0, zone  HighMem, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone  HighMem, type      Movable      1      1      1      1      1      1      0      1      1      1    233 
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
journal_head         502    511     56   73    1 : tunables    0    0    0 : slabdata      7      7      0
revoke_record        512    512     16  256    1 : tunables    0    0    0 : slabdata      2      2      0
ext3_inode_cache    4632   4632    472    8    1 : tunables    0    0    0 : slabdata    579    579      0
configfs_dir_cache     73     73     56   73    1 : tunables    0    0    0 : slabdata      1      1      0
shmem_inode_cache   3158   3159    440    9    1 : tunables    0    0    0 : slabdata    351    351      0
xfrm_dst_cache         0      0    320   12    1 : tunables    0    0    0 : slabdata      0      0      0
UDP                   14     14    576    7    1 : tunables    0    0    0 : slabdata      2      2      0
TCP                   12     12   1216    6    2 : tunables    0    0    0 : slabdata      2      2      0
sgpool-128             8      8   2048    4    2 : tunables    0    0    0 : slabdata      2      2      0
scsi_io_context        0      0    104   39    1 : tunables    0    0    0 : slabdata      0      0      0
blkdev_queue          21     21   1080    7    2 : tunables    0    0    0 : slabdata      3      3      0
biovec-256            66     66   3072    2    2 : tunables    0    0    0 : slabdata     33     33      0
biovec-128            76     80   1536    5    2 : tunables    0    0    0 : slabdata     16     16      0
biovec-64             76     80    768    5    1 : tunables    0    0    0 : slabdata     16     16      0
sock_inode_cache     197    200    384   10    1 : tunables    0    0    0 : slabdata     20     20      0
file_lock_cache       72     72    112   36    1 : tunables    0    0    0 : slabdata      2      2      0
Acpi-Operand        3041   3060     40  102    1 : tunables    0    0    0 : slabdata     30     30      0
Acpi-Namespace      1599   1700     24  170    1 : tunables    0    0    0 : slabdata     10     10      0
proc_inode_cache     880    880    360   11    1 : tunables    0    0    0 : slabdata     80     80      0
sigqueue              56     56    144   28    1 : tunables    0    0    0 : slabdata      2      2      0
radix_tree_node     2498   2509    296   13    1 : tunables    0    0    0 : slabdata    193    193      0
bdev_cache            24     24    512    8    1 : tunables    0    0    0 : slabdata      3      3      0
sysfs_dir_cache    11614  11645     48   85    1 : tunables    0    0    0 : slabdata    137    137      0
inode_cache         4081   4081    344   11    1 : tunables    0    0    0 : slabdata    371    371      0
dentry             17759  17760    128   32    1 : tunables    0    0    0 : slabdata    555    555      0
names_cache            4      4   4096    2    2 : tunables    0    0    0 : slabdata      2      2      0
idr_layer_cache      392    392    144   28    1 : tunables    0    0    0 : slabdata     14     14      0
buffer_head         8256   8256     64   64    1 : tunables    0    0    0 : slabdata    129    129      0
vm_area_struct      5928   5934     88   46    1 : tunables    0    0    0 : slabdata    129    129      0
files_cache           68     70    384   10    1 : tunables    0    0    0 : slabdata      7      7      0
signal_cache         358    360    448    9    1 : tunables    0    0    0 : slabdata     40     40      0
sighand_cache        108    108   1344    6    2 : tunables    0    0    0 : slabdata     18     18      0
task_struct          133    135    864    9    2 : tunables    0    0    0 : slabdata     15     15      0
anon_vma            1949   2048     16  256    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-4096          54     56   4096    8    8 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-2048         223    224   2048   16    8 : tunables    0    0    0 : slabdata     14     14      0
kmalloc-1024         259    260   1024    4    1 : tunables    0    0    0 : slabdata     65     65      0
kmalloc-512         1073   1080    512    8    1 : tunables    0    0    0 : slabdata    135    135      0
kmalloc-256           93     96    256   16    1 : tunables    0    0    0 : slabdata      6      6      0
kmalloc-128         2814   2880    128   32    1 : tunables    0    0    0 : slabdata     90     90      0
kmalloc-64          1888   1984     64   64    1 : tunables    0    0    0 : slabdata     31     31      0
kmalloc-32          1017   1024     32  128    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-16          4070   4352     16  256    1 : tunables    0    0    0 : slabdata     17     17      0
kmalloc-8           4601   4608      8  512    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-192          416    462    192   21    1 : tunables    0    0    0 : slabdata     22     22      0
kmalloc-96           454    546     96   42    1 : tunables    0    0    0 : slabdata     13     13      0
-- dmesg: --
[    0.000000] Linux version 2.6.25-rc7-x86-latest.git (thomas@hotzenplotz) (gcc version 4.2.3 (Gentoo 4.2.3 p1.0)) #12 SMP Wed Mar 26 18:31:25 CET 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
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
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 37888 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516327
[    0.000000] Kernel command line: root=/dev/sda3 lapic_timer_c2_ok nmi_watchdog=1 BOOT_IMAGE=bzImage 
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] CPU 0 irqstacks, hard=c03bd000 soft=c03bb000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Detected 1830.914 MHz processor.
[    0.003333] Console: colour VGA+ 80x25
[    0.003333] console [tty0] enabled
[    0.003333] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.003333] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.003333] Memory: 2059900k/2081568k available (1793k kernel code, 20500k reserved, 757k data, 212k init, 1164064k highmem)
[    0.003333] virtual kernel memory layout:
[    0.003333]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.003333]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.003333]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.003333]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.003333]       .init : 0xc0383000 - 0xc03b8000   ( 212 kB)
[    0.003333]       .data : 0xc02c04e3 - 0xc037db58   ( 757 kB)
[    0.003333]       .text : 0xc0100000 - 0xc02c04e3   (1793 kB)
[    0.003333] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.003333] CPA: page pool initialized 1 of 1 pages preallocated
[    0.003333] SLUB: Genslabs=12, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
[    0.003333]  f8800000
[    0.003333] hpet clockevent registered
[    0.086665] Calibrating delay using timer specific routine.. 3667.37 BogoMIPS (lpj=6109406)
[    0.086791] Mount-cache hash table entries: 512
[    0.087017] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.087099] CPU: L2 cache: 2048K
[    0.087145] CPU: Physical Processor ID: 0
[    0.087193] CPU: Processor Core ID: 0
[    0.087241] Intel machine check architecture supported.
[    0.087296] Intel machine check reporting enabled on CPU#0.
[    0.087345] using mwait in idle threads.
[    0.087395] Compat vDSO mapped to ffffe000.
[    0.087448] Checking 'hlt' instruction... OK.
[    0.100378] ACPI: Core revision 20070126
[    0.100461]  f8808000
[    0.109360]  f8802000
[    0.109796]  f8804000
[    0.110260]  f8806000
[    0.110956] ENABLING IO-APIC IRQs
[    0.111217] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.144323] CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.146657] APIC timer registered as dummy, due to nmi_watchdog=1!
[    0.146763] CPU 1 irqstacks, hard=c03be000 soft=c03bc000
[    0.146814] Booting processor 1/1 ip 4000
[    0.003333] Initializing CPU#1
[    0.003333] Calibrating delay using timer specific routine.. 3663.48 BogoMIPS (lpj=6103175)
[    0.003333] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.003333] CPU: L2 cache: 2048K
[    0.003333] CPU: Physical Processor ID: 0
[    0.003333] CPU: Processor Core ID: 1
[    0.003333] Intel machine check architecture supported.
[    0.003333] Intel machine check reporting enabled on CPU#1.
[    0.240696] CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
[    0.241230] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.243336] Brought up 2 CPUs
[    0.243387] Total of 2 processors activated (7330.86 BogoMIPS).
[    0.243448] Testing NMI watchdog ... OK.
[    0.310953] CPU0 attaching sched-domain:
[    0.310958]  domain 0: span 3
[    0.310961]   groups: 1 2
[    0.310968] CPU1 attaching sched-domain:
[    0.310971]  domain 0: span 3
[    0.310974]   groups: 2 1
[    0.311374] net_namespace: 448 bytes
[    0.311702] NET: Registered protocol family 16
[    0.312047] No dock devices found.
[    0.312223] ACPI: bus type pci registered
[    0.312394]  f880e000
[    0.312449] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.312501] PCI: Not using MMCONFIG.
[    0.312547] PCI: Fatal: No config space access function found
[    0.312602] Setting up standard PCI resources
[    0.315381]  f8810000
[    0.315734]  f8812000
[    0.315789] ACPI: EC: EC description table is found, configuring boot EC
[    0.316118]  f8814c1f
[    0.316215] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.319650] ACPI: BIOS _OSI(Linux) query ignored via DMI
[    0.319761]  f8814c10
[    0.320179] ACPI: Interpreter enabled
[    0.320228] ACPI: (supports S0 S3 S4 S5)
[    0.320416] ACPI: Using IOAPIC for interrupt routing
[    0.320536] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.320921] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.321051] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.321184] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.321391] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKA._STA] (Node f7c13ba0), AE_ERROR
[    0.321571] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.321700] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.321831] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.322036] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKB._STA] (Node f7c13c60), AE_ERROR
[    0.322215] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.322343] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.322475] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.322680] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKC._STA] (Node f7c13d20), AE_ERROR
[    0.322858] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.322987] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.323118] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.323356] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKD._STA] (Node f7c13de0), AE_ERROR
[    0.323535] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.324954] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.325086] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.325291] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKE._STA] (Node f7c13ea0), AE_ERROR
[    0.325468] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.325597] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.325728] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.325934] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKF._STA] (Node f7c13f60), AE_ERROR
[    0.326111] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.326240] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.326371] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.326576] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKG._STA] (Node f7c15030), AE_ERROR
[    0.326752] ACPI Exception (evregion-0420): AE_ERROR, Returned by Handler for [PCI_Config] [20070126]
[    0.326881] ACPI Exception (dswexec-0462): AE_ERROR, While resolving operands for [OpcodeName unavailable] [20070126]
[    0.327012] ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.327218] ACPI Error (uteval-0233): Method execution failed [\_SB_.PCI0.LPCB.LNKH._STA] (Node f7c150f0), AE_ERROR
[    0.327611]  f8816404
[    0.332231] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.332284] PCI: Using MMCONFIG for extended config space
[    0.348716] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.348769] ACPI: EC: driver started in poll mode
[    0.350725] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.351516] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.351581] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.352468] PCI: Transparent bridge - 0000:00:1e.0
[    0.352558] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.353192] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.353470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.353712] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.353952] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.354210] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.367277] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.367958] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.368633] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.369308] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.369991] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.370668] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.371342] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.372015] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.372697]  f8818000
[    0.372775]  f881a000
[    0.372830]  f881c000
[    0.372893]  f881e000
[    0.372960]  f8820000
[    0.373226] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.373331] pnp: PnP ACPI init
[    0.373385] ACPI: bus type pnp registered
[    0.377078] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.383048] pnp: PnP ACPI: found 10 devices
[    0.383097] ACPI: ACPI bus type pnp unregistered
[    0.383619] SCSI subsystem initialized
[    0.383889] libata version 3.00 loaded.
[    0.384130] PCI: Using ACPI for IRQ routing
[    0.384203] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.384266] PCI: System does not support PCI
[    0.384314] PCI: System does not support PCI
[    0.389991] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
[    0.390170] hpet0: 3 64-bit timers, 14318180 Hz
[    0.396663] system 00:01: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.396727] system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
[    0.396791] system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
[    0.396855] system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
[    0.396918] system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
[    0.396981] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.397044] system 00:06: iomem range 0xfed00000-0xfed003ff has been reserved
[    0.397103] system 00:08: ioport range 0x680-0x6ef has been reserved
[    0.397155] system 00:08: ioport range 0x800-0x80f has been reserved
[    0.397212] system 00:08: ioport range 0x810-0x817 has been reserved
[    0.397264] system 00:08: ioport range 0x400-0x47f has been reserved
[    0.397316] system 00:08: ioport range 0x500-0x53f has been reserved
[    0.397368] system 00:08: ioport range 0x1640-0x164f has been reserved
[    0.428300] PCI: Bridge: 0000:00:01.0
[    0.428349]   IO window: 2000-2fff
[    0.428397]   MEM window: 0x94000000-0x940fffff
[    0.428446]   PREFETCH window: 0x0000000088000000-0x0000000093ffffff
[    0.428512] PCI: Bridge: 0000:00:1c.0
[    0.428560]   IO window: 3000-3fff
[    0.428609]   MEM window: 0x94100000-0x941fffff
[    0.428660]   PREFETCH window: 0x0000000094200000-0x00000000942fffff
[    0.428723] PCI: Bridge: 0000:00:1c.1
[    0.428769]   IO window: disabled.
[    0.428819]   MEM window: 0x94300000-0x943fffff
[    0.428869]   PREFETCH window: disabled.
[    0.428920] PCI: Bridge: 0000:00:1c.2
[    0.428966]   IO window: disabled.
[    0.429015]   MEM window: disabled.
[    0.429063]   PREFETCH window: disabled.
[    0.429117] PCI: Bridge: 0000:00:1e.0
[    0.429163]   IO window: disabled.
[    0.429213]   MEM window: 0x94400000-0x944fffff
[    0.429263]   PREFETCH window: disabled.
[    0.429326] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.429421] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.429445] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.429540] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.429563] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.429659] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.429682] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.429778] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.429793] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.429808] NET: Registered protocol family 2
[    0.446707] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.447083] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.448337] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.448983] TCP: Hash tables configured (established 131072 bind 65536)
[    0.449035] TCP reno registered
[    0.207502] Machine check exception polling timer started.
[    0.208279] highmem bounce pool size: 64 pages
[    0.208332] Total HugeTLB memory allocated, 0
[    0.211804] VFS: Disk quotas dquot_6.5.1
[    0.211893] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.212849] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.212912] io scheduler noop registered
[    0.212960] io scheduler anticipatory registered
[    0.213008] io scheduler deadline registered
[    0.213139] io scheduler cfq registered (default)
[    0.213287]  f8822000
[    0.213351] pci 0000:01:00.0: Boot video device
[    0.213485] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.213511] assign_interrupt_mode Found MSI capability
[    0.213581] Allocate Port Service[0000:00:01.0:pcie00]
[    0.213641] Allocate Port Service[0000:00:01.0:pcie03]
[    0.213739] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.213782] assign_interrupt_mode Found MSI capability
[    0.213869] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.213927] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.213985] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.214104] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.214146] assign_interrupt_mode Found MSI capability
[    0.214233] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.214292] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.214350] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.214467] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.214510] assign_interrupt_mode Found MSI capability
[    0.214596] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.214659] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.214718] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.252028]  f8822000
[    0.252077] hpet_resources: 0xfed00000 is busy
[    0.252150] Linux agpgart interface v0.103
[    0.252261] PCI: Enabling device 0000:02:00.0 (0000 -> 0003)
[    0.252316] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.252420] PCI: Setting latency timer of device 0000:02:00.0 to 64
[    0.252436]  f8828000
[    0.252496] sky2 0000:02:00.0: v1.21 addr 0x94100000 irq 16 Yukon-EC (0xb6) rev 2
[    0.253088] sky2 eth0: addr 00:16:cb:8c:b2:65
[    0.253220] console [netcon0] enabled
[    0.503303] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    0.503309] Could not switch to high resolution mode on CPU 0
[    0.253320] Clockevents: could not switch to one-shot mode: lapic is not functional.
[    0.253325] Could not switch to high resolution mode on CPU 1
[    0.256651] netconsole: network logging started
[    0.256838] input: Macintosh mouse button emulation as /class/input/input0
[    0.256970] Driver 'sd' needs updating - please use bus_type methods
[    0.257158] ata_piix 0000:00:1f.1: version 2.12
[    0.257169] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
[    0.257304] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    0.257404] scsi0 : ata_piix
[    0.257556] scsi1 : ata_piix
[    0.258629] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x10a0 irq 14
[    0.258683] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x10a8 irq 15
[    0.827215] ata1.00: ATAPI: MATSHITADVD-R   UJ-857, HAEA, max UDMA/66
[    0.993810] ata1.00: configured for UDMA/66
[    0.894924] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857   HAEA PQ: 0 ANSI: 5
[    0.896722] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
[    0.896818] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.897066] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    0.897125] scsi2 : ata_piix
[    0.897271] scsi3 : ata_piix
[    0.898956] ata3: SATA max UDMA/133 cmd 0x10c0 ctl 0x10d0 bmdma 0x10b0 irq 19
[    0.899011] ata4: SATA max UDMA/133 cmd 0x10c8 ctl 0x10d4 bmdma 0x10b8 irq 19
[    1.372007] ata3.01: ATA-7: WDC WD1600BEVS-00RST0, 04.01G04, max UDMA/133
[    1.372062] ata3.01: 312581808 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    1.383769] ata3.01: configured for UDMA/133
[    1.283356] scsi 2:0:1:0: Direct-Access     ATA      WDC WD1600BEVS-0 04.0 PQ: 0 ANSI: 5
[    1.283597] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.283669] sd 2:0:1:0: [sda] Write Protect is off
[    1.283719] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.283752] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.283889] sd 2:0:1:0: [sda] 312581808 512-byte hardware sectors (160042 MB)
[    1.283958] sd 2:0:1:0: [sda] Write Protect is off
[    1.284007] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.284040] sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.284106]  sda: sda1 sda2 sda3 sda4 sda6
[    1.590418] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.590832] PNP: No PS/2 controller found. Probing ports directly.
[    1.591776] i8042.c: No controller found.
[    1.596630] mice: PS/2 mouse device common for all mice
[    1.596847] device-mapper: uevent: version 1.0.3
[    1.596980] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[    1.597057] cpuidle: using governor ladder
[    1.597104] cpuidle: using governor menu
[    1.597833] TCP cubic registered
[    1.597892] NET: Registered protocol family 1
[    1.597955] NET: Registered protocol family 17
[    1.598009] Using IPI No-Shortcut mode
[    1.375447] kjournald starting.  Commit interval 5 seconds
[    1.632109] EXT3-fs: mounted filesystem with ordered data mode.
[    1.632121] VFS: Mounted root (ext3 filesystem) readonly.
[    1.632302] Freeing unused kernel memory: 212k freed
[    3.673181] Driver 'sr' needs updating - please use bus_type methods
[    3.674886] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    3.674892] Uniform CD-ROM driver Revision: 3.20
[    3.674968] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    3.862129]  f8824c90
[    3.862212] ACPI: SSDT 7FEB3C90, 022A (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
[    3.862611]  f8826c10
[    3.862711] ACPI: SSDT 7FEB2C10, 02C3 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
[    3.863335] Monitor-Mwait will be used to enter C-1 state
[    3.863341] Monitor-Mwait will be used to enter C-2 state
[    3.863346] Monitor-Mwait will be used to enter C-3 state
[    3.863438] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.863480] ACPI: ACPI0007:00 is registered as cooling_device0
[    3.863488] ACPI: Processor [CPU0] (supports 8 throttling states)
[    3.864014]  f8834f10
[    3.864044] ACPI: SSDT 7FEB3F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
[    3.864406]  f8836f10
[    3.864436] ACPI: SSDT 7FEB2F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
[    3.612908] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.612950] ACPI: ACPI0007:01 is registered as cooling_device1
[    3.612958] ACPI: Processor [CPU1] (supports 8 throttling states)
[    3.716441] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    3.716479] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    3.770793] tpm_inf_pnp 00:03: Found TPM with ID IFX0101
[    3.770855] tpm_inf_pnp 00:03: TPM found: config base 0x4e, data base 0x4700, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
[    4.028515] input: Power Button (FF) as /class/input/input1
[    4.032222] ACPI: Power Button (FF) [PWRF]
[    4.032328] input: Lid Switch as /class/input/input2
[    4.032429] ACPI: Lid Switch [LID0]
[    4.032513] input: Power Button (CM) as /class/input/input3
[    4.049834] ACPI: Power Button (CM) [PWRB]
[    4.049942] input: Sleep Button (CM) as /class/input/input4
[    4.059746] ACPI: Sleep Button (CM) [SLPB]
[    3.804429] ACPI: AC Adapter [ADP1] (on-line)
[    4.215454] ACPI: Battery Slot [BAT0] (battery present)
[    4.254982] usbcore: registered new interface driver usbfs
[    4.255016] usbcore: registered new interface driver hub
[    4.255927] usbcore: registered new device driver usb
[    4.289334] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[    4.289416]  f887e000
[    4.340746] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  MMIO=[94400000-944007ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    4.381091] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[    4.381107]  f889e000
[    4.381113] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    4.381119] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.381874] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    4.385810] ehci_hcd 0000:00:1d.7: debug port 1
[    4.385818] PCI: cache line size of 128 is not supported by device 0000:00:1d.7
[    4.385836] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x94505000
[    4.133205] USB Universal Host Controller Interface driver v3.0
[    4.399739] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    4.399943] usb usb1: configuration #1 chosen from 1 choice
[    4.399985] hub 1-0:1.0: USB hub found
[    4.399996] hub 1-0:1.0: 8 ports detected
[    4.246513] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[    4.246529] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    4.246535] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.246579] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    4.246614] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00001000
[    4.246792] usb usb2: configuration #1 chosen from 1 choice
[    4.246843] hub 2-0:1.0: USB hub found
[    4.246853] hub 2-0:1.0: 2 ports detected
[    4.555271] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
[    4.555354]  f88c2410
[    4.555370] iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
[    4.555412] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.349848] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[    4.349863] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    4.349869] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.349910] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    4.349945] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001020
[    4.350127] usb usb3: configuration #1 chosen from 1 choice
[    4.350168] hub 3-0:1.0: USB hub found
[    4.350179] hub 3-0:1.0: 2 ports detected
[    4.405437]  f88dc000
[    4.406714] intel_rng: FWH not detected
[    4.453183] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[    4.453200] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    4.453206] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.453256] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    4.453297] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001040
[    4.453470] usb usb4: configuration #1 chosen from 1 choice
[    4.453511] hub 4-0:1.0: USB hub found
[    4.453521] hub 4-0:1.0: 2 ports detected
[    4.729715] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    4.556503] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level, low) -> IRQ 16
[    4.556519] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    4.556525] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.556568] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    4.556611] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00001060
[    4.556781] usb usb5: configuration #1 chosen from 1 choice
[    4.556822] hub 5-0:1.0: USB hub found
[    4.556832] hub 5-0:1.0: 2 ports detected
[    4.855760] usb 1-1: configuration #1 chosen from 1 choice
[    4.916532] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[    4.916553]  f8908000
[    4.916572] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[    4.944430] hda_codec: STAC922x, Apple subsys_id=106b0200
[    4.983463] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
[    4.990222] Initializing USB Mass Storage driver...
[    5.049682] usb 1-4: new high speed USB device using ehci_hcd and address 4
[    5.430144] usb 1-4: configuration #1 chosen from 1 choice
[    5.359803] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0016cbfffe4c8a54]
[    6.229602] usb 2-2: new full speed USB device using uhci_hcd and address 2
[    6.416390] usb 2-2: configuration #1 chosen from 1 choice
[    6.772901] usb 4-2: new full speed USB device using uhci_hcd and address 2
[    6.947072] usb 4-2: configuration #1 chosen from 1 choice
[    6.952933] scsi4 : SCSI emulation for USB Mass Storage devices
[    6.953183] usb-storage: device found at 2
[    6.953187] usb-storage: waiting for device to settle before scanning
[    7.176208] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    7.349384] usb 5-1: configuration #1 chosen from 1 choice
[    7.357682] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input5
[    7.392912] input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    7.396324] input: Apple Computer Apple Internal Keyboard / Trackpad as /class/input/input6
[    7.416219] input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[    7.419233] appletouch: Geyser mode initialized.
[    7.419315] input: appletouch as /class/input/input7
[    7.421918] HID device claimed by neither input, hiddev nor hidraw
[    7.438644] input: HID 05ac:1000 as /class/input/input8
[    7.472896] input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
[    7.487636] input: HID 05ac:1000 as /class/input/input9
[    7.509548] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[    7.509581] usbcore: registered new interface driver usbhid
[    7.509587] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[    7.509973] usbcore: registered new interface driver appletouch
[    7.511572] usbcore: registered new interface driver usb-storage
[    7.511578] USB Mass Storage support registered.
[    8.568921] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[    8.569156] EXT3 FS on sda3, internal journal
[    9.010355] loop: module loaded
[    9.066099] tun: Universal TUN/TAP device driver, 1.6
[    9.066104] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    9.161502] applesmc: Apple MacBook Pro detected:
[    9.161508] applesmc:  - Model with accelerometer
[    9.161511] applesmc:  - Model with light sensors and backlight
[    9.161515] applesmc:  - Model with 12 temperature sensors
[    9.161955] applesmc: device has already been initialized (0xe0, 0x00).
[    9.161959] applesmc: device successfully initialized.
[    9.162158] applesmc: 2 fans found.
[    9.163085] input: applesmc as /class/input/input10
[    9.186215] Registered led device: smc::kbd_backlight
[    9.186245] applesmc: driver successfully loaded.
[   11.952851] usb-storage: device scan complete
[   11.697328] scsi 4:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
[   11.699434] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[   11.700303] sd 4:0:0:0: [sdb] Write Protect is off
[   11.700308] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   11.700312] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   11.703174] sd 4:0:0:0: [sdb] 7929856 512-byte hardware sectors (4060 MB)
[   11.704049] sd 4:0:0:0: [sdb] Write Protect is off
[   11.704054] sd 4:0:0:0: [sdb] Mode Sense: 43 00 00 00
[   11.704058] sd 4:0:0:0: [sdb] Assuming drive cache: write through
[   11.704063]  sdb: sdb1 sdb2
[   11.705166] sd 4:0:0:0: [sdb] Attached SCSI removable disk
[   11.705234] sd 4:0:0:0: Attached scsi generic sg2 type 0
[   13.984330] kjournald starting.  Commit interval 90 seconds
[   14.240989] EXT3-fs warning: mounting fs with errors, running e2fsck is recommended
[   14.241417] EXT3 FS on dm-1, internal journal
[   14.241425] EXT3-fs: mounted filesystem with ordered data mode.
[   14.730586] Adding 1214416k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1214416k
[   16.153907] sky2 eth0: enabling interface
[   17.894926] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   32.716355] fuse init (API version 7.9)
[   33.559156] IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
[   34.119559] appletouch: incomplete data package (first byte: 2, length: 4).
[   34.182596] pktcdvd: writer pktcdvd0 mapped to sr0
[   36.673765] CPU0 attaching NULL sched-domain.
[   36.673773] CPU1 attaching NULL sched-domain.
[   36.677623] CPU0 attaching sched-domain:
[   36.677630]  domain 0: span 3
[   36.677633]   groups: 1 2
[   36.677639]   domain 1: span 3
[   36.677643]    groups: 3
[   36.677648] CPU1 attaching sched-domain:
[   36.677651]  domain 0: span 3
[   36.677654]   groups: 2 1
[   36.677659]   domain 1: span 3
[   36.677663]    groups: 3
-- /proc/timer_list: --
Timer List Version: v0.3
HRTIMER_MAX_CLOCK_BASES: 2
now at 151493470737 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 3333116 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 3333116 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f73bcebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3072
 # expires at 154206642422 nsecs [in 2713171685 nsecs]
 #1: <f73bcebc>, hrtimer_wakeup, S:01, do_nanosleep, cron/3414
 # expires at 174560598557 nsecs [in 23067127820 nsecs]
 #2: <f73bcebc>, hrtimer_wakeup, S:01, do_nanosleep, smartd/3389
 # expires at 1834819957753 nsecs [in 1683326487016 nsecs]
  .expires_next   : 9223372036854775807 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 151492995534 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 131389701597 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294922739

cpu: 1
 clock 0:
  .index:      0
  .resolution: 3333116 nsecs
  .get_time:   ktime_get_real
  .offset:     0 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 3333116 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f73bcebc>, hrtimer_wakeup, S:01, do_nanosleep, kwrapper4/3528
 # expires at 152039686518 nsecs [in 546215781 nsecs]
 #1: <f73bcebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3070
 # expires at 154206642952 nsecs [in 2713172215 nsecs]
 #2: <f73bcebc>, hrtimer_wakeup, S:01, futex_wait, nscd/3071
 # expires at 154206654757 nsecs [in 2713184020 nsecs]
  .expires_next   : 9223372036854775807 nsecs
  .hres_active    : 0
  .nr_events      : 0
  .nohz_mode      : 0
  .idle_tick      : 0 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 0
  .idle_calls     : 0
  .idle_sleeps    : 0
  .idle_entrytime : 151489676118 nsecs
  .idle_waketime  : 0 nsecs
  .idle_exittime  : 0 nsecs
  .idle_sleeptime : 137446879105 nsecs
  .last_jiffies   : 0
  .next_jiffies   : 0
  .idle_expires   : 0 nsecs
jiffies: 4294922739


Tick Device: mode:     0
Clock Event Device: hpet
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           2
 next_event:     0 nsecs
 set_next_event: hpet_legacy_next_event
 set_mode:       hpet_legacy_set_mode
 event_handler:  tick_handle_periodic_broadcast
tick_broadcast_mask: 00000003
tick_broadcast_oneshot_mask: 00000000


Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   806337238
 min_delta_ns:   1441
 mult:           44682040
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

Tick Device: mode:     0
Clock Event Device: lapic
 max_delta_ns:   806337238
 min_delta_ns:   1441
 mult:           44682040
 shift:          32
 mode:           1
 next_event:     0 nsecs
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  tick_handle_periodic

-- /proc/timer_info: --
-- /proc/config.gz: --
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.25-rc7
# Wed Mar 26 18:24:40 2008
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
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
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
 18:36:38 up 2 min,  2 users,  load average: 0.27, 0.18, 0.07
-- uname: --
Linux hotzenplotz 2.6.25-rc7-x86-latest.git #12 SMP Wed Mar 26 18:31:25 CET 2008 i686 Genuine Intel(R) CPU T2400 @ 1.83GHz GenuineIntel GNU/Linux
-- /sys/devices/system: --
/sys/devices/system/cpu/sched_mc_power_savings:
1
/sys/devices/system/cpu/cpuidle/current_driver:
acpi_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:
menu
/sys/devices/system/cpu/cpu0/crash_notes:
37c5e0c0
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
18634
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:
129033998
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
0
/sys/devices/system/cpu/cpu0/cpuidle/state2/time:
0
/sys/devices/system/cpu/cpu0/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu0/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu0/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu0/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu0/cpuidle/state3/usage:
0
/sys/devices/system/cpu/cpu0/cpuidle/state3/time:
0
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
37c5e180
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
8678
/sys/devices/system/cpu/cpu1/cpuidle/state0/time:
134676284
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
0
/sys/devices/system/cpu/cpu1/cpuidle/state2/time:
0
/sys/devices/system/cpu/cpu1/cpuidle/state3/name:
C3
/sys/devices/system/cpu/cpu1/cpuidle/state3/desc:
ACPI FFH INTEL MWAIT 0x31
/sys/devices/system/cpu/cpu1/cpuidle/state3/latency:
55
/sys/devices/system/cpu/cpu1/cpuidle/state3/power:
100
/sys/devices/system/cpu/cpu1/cpuidle/state3/usage:
0
/sys/devices/system/cpu/cpu1/cpuidle/state3/time:
0
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
tsc
/sys/devices/system/clocksource/clocksource0/available_clocksource:
tsc hpet acpi_pm jiffies 
-- top: --
top - 18:36:38 up 2 min,  2 users,  load average: 0.27, 0.18, 0.07
Tasks: 105 total,   1 running, 104 sleeping,   0 stopped,   0 zombie
Cpu(s):  7.5%us,  2.7%sy,  0.0%ni, 74.3%id, 15.3%wa,  0.0%hi,  0.1%si,  0.0%st
Mem:   2060888k total,   231972k used,  1828916k free,    11324k buffers
Swap:  1214416k total,        0k used,  1214416k free,    91488k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
    1 root      20   0  1612  560  484 S    0  0.0   0:00.33 init [3]           
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
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  133 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  137 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  156 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  179 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  224 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  844 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  846 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  851 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  853 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  874 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  880 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  950 root      16  -4  2612 1452  468 S    0  0.1   0:00.49 /sbin/udevd --daemo
 2020 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 2032 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 2034 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2046 root      15  -5     0    0    0 S    0  0.0   0:00.00 [knodemgrd_0]      
 2216 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2217 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2537 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2581 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2590 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2591 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2641 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2643 root      15  -5     0    0    0 S    0  0.0   0:00.20 [kcryptd_io]       
 2644 root      15  -5     0    0    0 S    0  0.0   0:02.78 [kcryptd]          
 2698 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2804 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2980 root      20   0  1916  580  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2981 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2990 root      20   0  1604  560  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 3000 messageb  20   0  2396  948  672 S    0  0.0   0:00.16 /usr/bin/dbus-daemo
 3069 root      20   0  106m  976  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3088 haldaemo  20   0  4748 2928 2280 S    0  0.1   0:00.46 /usr/sbin/hald --us
 3089 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 3135 root      20   0  3144 1116  960 S    0  0.1   0:00.00 hald-addon-input: L
 3137 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3140 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3141 haldaemo  20   0  1904  760  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3147 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3159 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3201 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3212 root      20   0  191m  55m 3608 S    0  2.7   0:10.68 /usr/bin/X -br -nov
 3251 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3265 root      20   0  7040 2288 1560 S    0  0.1   0:00.16 /usr/sbin/cupsd    
 3318 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3372 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3389 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3403 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3414 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3422 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3425 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3426 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3427 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3428 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3429 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3452 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3453 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3461 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.02 /bin/sh /usr/kde/4.
 3512 thomas    20   0  2812  684  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3513 thomas    20   0  2188  892  640 S    0  0.0   0:00.14 /usr/bin/dbus-daemo
 3518 thomas    20   0 27476 4644 3556 S    0  0.2   0:00.02 kdeinit4: kdeinit4 
 3519 thomas    20   0 28292 8640 7480 S    0  0.4   0:00.10 klauncher          
 3521 thomas    20   0 67952  17m  13m S    0  0.9   0:00.59 kded4              
 3523 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3528 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3530 thomas    20   0 59940  11m 9.9m S    0  0.6   0:00.13 ksmserver          
 3535 thomas    20   0 47636  13m  10m S    0  0.7   0:00.63 kwin -session 1013c
 3538 thomas    20   0 81268  23m  16m S    0  1.2   0:02.66 /usr/kde/4.0/bin/pl
 3539 thomas    20   0 45332 7908 6600 S    0  0.4   0:00.61 /usr/kde/4.0/bin/kn
 3541 thomas    20   0 27888 4268 3092 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3543 thomas    20   0  100m  16m  13m S    0  0.8   0:01.13 /usr/kde/4.0/bin/kr
 3552 thomas    20   0 45268 7904 6588 S    0  0.4   0:00.07 /usr/kde/4.0/bin/ka
 3553 thomas    20   0 54084  12m 9.8m S    0  0.6   0:00.17 kmix -session 1013c
 3562 thomas    20   0 82372  24m  18m S    0  1.2   0:00.83 /usr/kde/4.0/bin/ko
 3564 thomas    20   0 29120 4976 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3565 thomas    20   0 29128 4964 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3566 thomas    20   0 29132 4956 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3567 thomas    20   0 29128 4952 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3573 thomas    20   0 57304  15m  10m S    0  0.8   0:00.55 /usr/kde/4.0/bin/ko
 3574 thomas    20   0  3232 1608 1284 S    0  0.1   0:00.00 /bin/bash          
 3583 thomas    20   0 84144  24m  18m S    0  1.2   0:00.83 kate               
 3585 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3588 root      20   0  2976 1600 1292 S    0  0.1   0:00.00 bash               
 3593 root      20   0  2976  992  656 S    0  0.0   0:00.06 bash               
 3834 root      20   0  2044  920  692 R    0  0.0   0:00.00 top -c -b -d 1 -n 5


top - 18:36:39 up 2 min,  2 users,  load average: 0.27, 0.18, 0.07
Tasks: 105 total,   1 running, 104 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060888k total,   232120k used,  1828768k free,    11324k buffers
Swap:  1214416k total,        0k used,  1214416k free,    91572k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3834 root      20   0  2052 1012  772 R    1  0.0   0:00.01 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.33 init [3]           
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
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  133 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  137 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  156 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  179 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  224 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  844 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  846 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  851 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  853 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  874 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  880 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  950 root      16  -4  2612 1452  468 S    0  0.1   0:00.49 /sbin/udevd --daemo
 2020 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 2032 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 2034 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2046 root      15  -5     0    0    0 S    0  0.0   0:00.00 [knodemgrd_0]      
 2216 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2217 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2537 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2581 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2590 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2591 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2641 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2643 root      15  -5     0    0    0 S    0  0.0   0:00.20 [kcryptd_io]       
 2644 root      15  -5     0    0    0 S    0  0.0   0:02.78 [kcryptd]          
 2698 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2804 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2980 root      20   0  1916  580  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2981 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2990 root      20   0  1604  560  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 3000 messageb  20   0  2396  948  672 S    0  0.0   0:00.16 /usr/bin/dbus-daemo
 3069 root      20   0  106m  976  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3088 haldaemo  20   0  4748 2928 2280 S    0  0.1   0:00.46 /usr/sbin/hald --us
 3089 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 3135 root      20   0  3144 1116  960 S    0  0.1   0:00.00 hald-addon-input: L
 3137 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3140 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3141 haldaemo  20   0  1904  760  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3147 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3159 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3201 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3212 root      20   0  191m  55m 3608 S    0  2.7   0:10.68 /usr/bin/X -br -nov
 3251 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3265 root      20   0  7040 2288 1560 S    0  0.1   0:00.16 /usr/sbin/cupsd    
 3318 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3372 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3389 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3403 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3414 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3422 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3425 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3426 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3427 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3428 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3429 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3452 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3453 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3461 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.02 /bin/sh /usr/kde/4.
 3512 thomas    20   0  2812  684  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3513 thomas    20   0  2188  892  640 S    0  0.0   0:00.14 /usr/bin/dbus-daemo
 3518 thomas    20   0 27476 4644 3556 S    0  0.2   0:00.02 kdeinit4: kdeinit4 
 3519 thomas    20   0 28292 8640 7480 S    0  0.4   0:00.10 klauncher          
 3521 thomas    20   0 67952  17m  13m S    0  0.9   0:00.59 kded4              
 3523 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3528 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3530 thomas    20   0 59940  11m 9.9m S    0  0.6   0:00.13 ksmserver          
 3535 thomas    20   0 47636  13m  10m S    0  0.7   0:00.63 kwin -session 1013c
 3538 thomas    20   0 81268  23m  16m S    0  1.2   0:02.66 /usr/kde/4.0/bin/pl
 3539 thomas    20   0 45332 7908 6600 S    0  0.4   0:00.61 /usr/kde/4.0/bin/kn
 3541 thomas    20   0 27888 4268 3092 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3543 thomas    20   0  100m  16m  13m S    0  0.8   0:01.13 /usr/kde/4.0/bin/kr
 3552 thomas    20   0 45268 7904 6588 S    0  0.4   0:00.07 /usr/kde/4.0/bin/ka
 3553 thomas    20   0 54084  12m 9.8m S    0  0.6   0:00.17 kmix -session 1013c
 3562 thomas    20   0 82372  24m  18m S    0  1.2   0:00.83 /usr/kde/4.0/bin/ko
 3564 thomas    20   0 29120 4976 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3565 thomas    20   0 29128 4964 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3566 thomas    20   0 29132 4956 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3567 thomas    20   0 29128 4952 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3573 thomas    20   0 57304  15m  10m S    0  0.8   0:00.55 /usr/kde/4.0/bin/ko
 3574 thomas    20   0  3232 1608 1284 S    0  0.1   0:00.00 /bin/bash          
 3583 thomas    20   0 84144  24m  18m S    0  1.2   0:00.83 kate               
 3585 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3588 root      20   0  2976 1600 1292 S    0  0.1   0:00.00 bash               
 3593 root      20   0  2976  992  656 S    0  0.0   0:00.06 bash               


top - 18:36:40 up 2 min,  2 users,  load average: 0.27, 0.18, 0.07
Tasks: 105 total,   1 running, 104 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060888k total,   232120k used,  1828768k free,    11324k buffers
Swap:  1214416k total,        0k used,  1214416k free,    91580k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3834 root      20   0  2052 1012  772 R    1  0.0   0:00.02 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.33 init [3]           
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
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  133 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  137 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  156 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  179 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  224 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  844 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  846 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  851 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  853 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  874 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  880 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  950 root      16  -4  2612 1452  468 S    0  0.1   0:00.49 /sbin/udevd --daemo
 2020 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 2032 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 2034 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2046 root      15  -5     0    0    0 S    0  0.0   0:00.00 [knodemgrd_0]      
 2216 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2217 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2537 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2581 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2590 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2591 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2641 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2643 root      15  -5     0    0    0 S    0  0.0   0:00.20 [kcryptd_io]       
 2644 root      15  -5     0    0    0 S    0  0.0   0:02.78 [kcryptd]          
 2698 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2804 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2980 root      20   0  1916  580  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2981 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2990 root      20   0  1604  560  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 3000 messageb  20   0  2396  948  672 S    0  0.0   0:00.16 /usr/bin/dbus-daemo
 3069 root      20   0  106m  976  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3088 haldaemo  20   0  4748 2928 2280 S    0  0.1   0:00.46 /usr/sbin/hald --us
 3089 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 3135 root      20   0  3144 1116  960 S    0  0.1   0:00.00 hald-addon-input: L
 3137 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3140 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3141 haldaemo  20   0  1904  760  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3147 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3159 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3201 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3212 root      20   0  191m  55m 3608 S    0  2.7   0:10.68 /usr/bin/X -br -nov
 3251 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3265 root      20   0  7040 2288 1560 S    0  0.1   0:00.16 /usr/sbin/cupsd    
 3318 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3372 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3389 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3403 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3414 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3422 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3425 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3426 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3427 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3428 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3429 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3452 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3453 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3461 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.02 /bin/sh /usr/kde/4.
 3512 thomas    20   0  2812  684  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3513 thomas    20   0  2188  892  640 S    0  0.0   0:00.14 /usr/bin/dbus-daemo
 3518 thomas    20   0 27476 4644 3556 S    0  0.2   0:00.02 kdeinit4: kdeinit4 
 3519 thomas    20   0 28292 8640 7480 S    0  0.4   0:00.10 klauncher          
 3521 thomas    20   0 67952  17m  13m S    0  0.9   0:00.59 kded4              
 3523 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3528 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3530 thomas    20   0 59940  11m 9.9m S    0  0.6   0:00.13 ksmserver          
 3535 thomas    20   0 47636  13m  10m S    0  0.7   0:00.63 kwin -session 1013c
 3538 thomas    20   0 81268  23m  16m S    0  1.2   0:02.66 /usr/kde/4.0/bin/pl
 3539 thomas    20   0 45332 7908 6600 S    0  0.4   0:00.61 /usr/kde/4.0/bin/kn
 3541 thomas    20   0 27888 4268 3092 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3543 thomas    20   0  100m  16m  13m S    0  0.8   0:01.13 /usr/kde/4.0/bin/kr
 3552 thomas    20   0 45268 7904 6588 S    0  0.4   0:00.07 /usr/kde/4.0/bin/ka
 3553 thomas    20   0 54084  12m 9.8m S    0  0.6   0:00.17 kmix -session 1013c
 3562 thomas    20   0 82372  24m  18m S    0  1.2   0:00.83 /usr/kde/4.0/bin/ko
 3564 thomas    20   0 29120 4976 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3565 thomas    20   0 29128 4964 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3566 thomas    20   0 29132 4956 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3567 thomas    20   0 29128 4952 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3573 thomas    20   0 57304  15m  10m S    0  0.8   0:00.55 /usr/kde/4.0/bin/ko
 3574 thomas    20   0  3232 1608 1284 S    0  0.1   0:00.00 /bin/bash          
 3583 thomas    20   0 84144  24m  18m S    0  1.2   0:00.83 kate               
 3585 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3588 root      20   0  2976 1600 1292 S    0  0.1   0:00.00 bash               
 3593 root      20   0  2976  992  656 S    0  0.0   0:00.06 bash               


top - 18:36:41 up 2 min,  2 users,  load average: 0.24, 0.18, 0.07
Tasks: 105 total,   2 running, 103 sleeping,   0 stopped,   0 zombie
Cpu(s): 16.8%us,  1.5%sy,  0.0%ni, 81.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060888k total,   232120k used,  1828768k free,    11324k buffers
Swap:  1214416k total,        0k used,  1214416k free,    91588k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3212 root      20   0  191m  55m 3608 R   26  2.7   0:10.94 /usr/bin/X -br -nov
 3538 thomas    20   0 81268  23m  16m S    9  1.2   0:02.75 /usr/kde/4.0/bin/pl
 3573 thomas    20   0 57304  15m  10m S    1  0.8   0:00.56 /usr/kde/4.0/bin/ko
 3834 root      20   0  2052 1012  772 R    1  0.0   0:00.03 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.33 init [3]           
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
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  133 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  137 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  156 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  179 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  224 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  844 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  846 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  851 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  853 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  874 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  880 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  950 root      16  -4  2612 1452  468 S    0  0.1   0:00.49 /sbin/udevd --daemo
 2020 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 2032 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 2034 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2046 root      15  -5     0    0    0 S    0  0.0   0:00.00 [knodemgrd_0]      
 2216 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2217 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2537 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2581 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2590 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2591 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2641 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2643 root      15  -5     0    0    0 S    0  0.0   0:00.20 [kcryptd_io]       
 2644 root      15  -5     0    0    0 S    0  0.0   0:02.78 [kcryptd]          
 2698 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2804 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2980 root      20   0  1916  580  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2981 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2990 root      20   0  1604  560  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 3000 messageb  20   0  2396  948  672 S    0  0.0   0:00.16 /usr/bin/dbus-daemo
 3069 root      20   0  106m  976  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3088 haldaemo  20   0  4748 2928 2280 S    0  0.1   0:00.46 /usr/sbin/hald --us
 3089 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 3135 root      20   0  3144 1116  960 S    0  0.1   0:00.00 hald-addon-input: L
 3137 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3140 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3141 haldaemo  20   0  1904  760  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3147 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3159 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3201 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3251 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3265 root      20   0  7040 2288 1560 S    0  0.1   0:00.16 /usr/sbin/cupsd    
 3318 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3372 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3389 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3403 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3414 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3422 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3425 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3426 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3427 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3428 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3429 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3452 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3453 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3461 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.02 /bin/sh /usr/kde/4.
 3512 thomas    20   0  2812  684  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3513 thomas    20   0  2188  892  640 S    0  0.0   0:00.14 /usr/bin/dbus-daemo
 3518 thomas    20   0 27476 4644 3556 S    0  0.2   0:00.02 kdeinit4: kdeinit4 
 3519 thomas    20   0 28292 8640 7480 S    0  0.4   0:00.10 klauncher          
 3521 thomas    20   0 67952  17m  13m S    0  0.9   0:00.59 kded4              
 3523 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3528 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3530 thomas    20   0 59940  11m 9.9m S    0  0.6   0:00.13 ksmserver          
 3535 thomas    20   0 47636  13m  10m S    0  0.7   0:00.63 kwin -session 1013c
 3539 thomas    20   0 45332 7908 6600 S    0  0.4   0:00.61 /usr/kde/4.0/bin/kn
 3541 thomas    20   0 27888 4268 3092 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3543 thomas    20   0  100m  16m  13m S    0  0.8   0:01.13 /usr/kde/4.0/bin/kr
 3552 thomas    20   0 45268 7904 6588 S    0  0.4   0:00.07 /usr/kde/4.0/bin/ka
 3553 thomas    20   0 54084  12m 9.8m S    0  0.6   0:00.17 kmix -session 1013c
 3562 thomas    20   0 82372  24m  18m S    0  1.2   0:00.83 /usr/kde/4.0/bin/ko
 3564 thomas    20   0 29120 4976 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3565 thomas    20   0 29128 4964 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3566 thomas    20   0 29132 4956 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3567 thomas    20   0 29128 4952 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3574 thomas    20   0  3232 1608 1284 S    0  0.1   0:00.00 /bin/bash          
 3583 thomas    20   0 84144  24m  18m S    0  1.2   0:00.83 kate               
 3585 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3588 root      20   0  2976 1600 1292 S    0  0.1   0:00.00 bash               
 3593 root      20   0  2976  992  656 S    0  0.0   0:00.06 bash               


top - 18:36:42 up 2 min,  2 users,  load average: 0.24, 0.18, 0.07
Tasks: 105 total,   1 running, 104 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.5%us,  0.5%sy,  0.0%ni, 99.0%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   2060888k total,   232204k used,  1828684k free,    11324k buffers
Swap:  1214416k total,        0k used,  1214416k free,    91600k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 3212 root      20   0  191m  55m 3608 S    1  2.7   0:10.95 /usr/bin/X -br -nov
 3538 thomas    20   0 81268  23m  16m S    1  1.2   0:02.76 /usr/kde/4.0/bin/pl
 3573 thomas    20   0 57304  15m  10m S    1  0.8   0:00.57 /usr/kde/4.0/bin/ko
 3834 root      20   0  2052 1012  772 R    1  0.0   0:00.04 top -c -b -d 1 -n 5
    1 root      20   0  1612  560  484 S    0  0.0   0:00.33 init [3]           
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
  129 root      15  -5     0    0    0 S    0  0.0   0:00.00 [cqueue]           
  133 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/0]            
  134 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata/1]            
  135 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ata_aux]          
  137 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kseriod]          
  156 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/0]      
  157 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kondemand/1]      
  179 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  180 root      20   0     0    0    0 S    0  0.0   0:00.00 [pdflush]          
  181 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kswapd0]          
  224 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/0]            
  225 root      15  -5     0    0    0 S    0  0.0   0:00.00 [aio/1]            
  844 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_0]        
  846 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_1]        
  851 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_2]        
  853 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_3]        
  874 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kstriped]         
  880 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
  950 root      16  -4  2612 1452  468 S    0  0.1   0:00.49 /sbin/udevd --daemo
 2020 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khpsbpkt]         
 2032 root      15  -5     0    0    0 S    0  0.0   0:00.00 [ksuspend_usbd]    
 2034 root      15  -5     0    0    0 S    0  0.0   0:00.00 [khubd]            
 2046 root      15  -5     0    0    0 S    0  0.0   0:00.00 [knodemgrd_0]      
 2216 root      15  -5     0    0    0 S    0  0.0   0:00.00 [scsi_eh_4]        
 2217 root      15  -5     0    0    0 S    0  0.0   0:00.00 [usb-storage]      
 2537 root      15  -5     0    0    0 S    0  0.0   0:00.00 [applesmc-led]     
 2581 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2590 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kcryptd_io]       
 2591 root      15  -5     0    0    0 S    0  0.0   0:00.01 [kcryptd]          
 2641 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kdmflush]         
 2643 root      15  -5     0    0    0 S    0  0.0   0:00.20 [kcryptd_io]       
 2644 root      15  -5     0    0    0 S    0  0.0   0:02.78 [kcryptd]          
 2698 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kjournald]        
 2804 root      20   0  1636  476  388 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 2980 root      20   0  1916  580  460 S    0  0.0   0:00.01 metalog [MASTER]   
 2981 root      20   0  1900  212  120 S    0  0.0   0:00.00 metalog [KERNEL]   
 2990 root      20   0  1604  560  476 S    0  0.0   0:00.00 /usr/sbin/acpid    
 3000 messageb  20   0  2396  948  672 S    0  0.0   0:00.16 /usr/bin/dbus-daemo
 3069 root      20   0  106m  976  732 S    0  0.0   0:00.00 /usr/sbin/nscd     
 3088 haldaemo  20   0  4748 2928 2280 S    0  0.1   0:00.46 /usr/sbin/hald --us
 3089 root      20   0  3048 1016  864 S    0  0.0   0:00.00 hald-runner        
 3135 root      20   0  3144 1116  960 S    0  0.1   0:00.00 hald-addon-input: L
 3137 root      20   0  3224 1116  972 S    0  0.1   0:00.00 /usr/libexec/hald-a
 3140 root      20   0  3156  992  848 S    0  0.0   0:00.00 /usr/libexec/hald-a
 3141 haldaemo  20   0  1904  760  664 S    0  0.0   0:00.00 hald-addon-acpi: li
 3147 root      20   0  1776  268  160 S    0  0.0   0:00.00 /sbin/dhcpcd -m 2 e
 3159 root      20   0  3144 1012  864 S    0  0.0   0:00.00 hald-addon-storage:
 3201 root      20   0  3676  680  488 S    0  0.0   0:00.00 /usr/kde/4.0/bin/kd
 3251 root      20   0  4416 1580 1196 S    0  0.1   0:00.00 -:0                
 3265 root      20   0  7040 2288 1560 S    0  0.1   0:00.16 /usr/sbin/cupsd    
 3318 root      20   0  1636  440  364 S    0  0.0   0:00.00 /usr/sbin/ifplugd -
 3372 root       0 -20     0    0    0 S    0  0.0   0:00.00 [pktcdvd0]         
 3389 root      20   0  2996  544  384 S    0  0.0   0:00.00 /usr/sbin/smartd -p
 3403 root      20   0  4920  952  616 S    0  0.0   0:00.00 /usr/sbin/sshd     
 3414 root      20   0  1948  384  296 S    0  0.0   0:00.00 /usr/sbin/cron     
 3422 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3425 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3426 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3427 root      20   0  1612  600  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3428 root      20   0  1612  596  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3429 root      20   0  1612  592  524 S    0  0.0   0:00.00 /sbin/agetty 38400 
 3452 root      20   0  2812  688  496 S    0  0.0   0:00.00 dbus-launch --autol
 3453 root      20   0  2056  668  580 S    0  0.0   0:00.00 /usr/bin/dbus-daemo
 3461 thomas    20   0  3096 1316 1108 S    0  0.1   0:00.02 /bin/sh /usr/kde/4.
 3512 thomas    20   0  2812  684  496 S    0  0.0   0:00.00 dbus-launch --sh-sy
 3513 thomas    20   0  2188  892  640 S    0  0.0   0:00.14 /usr/bin/dbus-daemo
 3518 thomas    20   0 27476 4644 3556 S    0  0.2   0:00.02 kdeinit4: kdeinit4 
 3519 thomas    20   0 28292 8640 7480 S    0  0.4   0:00.10 klauncher          
 3521 thomas    20   0 67952  17m  13m S    0  0.9   0:00.59 kded4              
 3523 thomas    20   0  2472  936  836 S    0  0.0   0:00.00 /usr/libexec/gam_se
 3528 thomas    20   0  8356 2072 1776 S    0  0.1   0:00.00 kwrapper4 ksmserver
 3530 thomas    20   0 59940  11m 9.9m S    0  0.6   0:00.13 ksmserver          
 3535 thomas    20   0 47636  13m  10m S    0  0.7   0:00.63 kwin -session 1013c
 3539 thomas    20   0 45332 7908 6600 S    0  0.4   0:00.61 /usr/kde/4.0/bin/kn
 3541 thomas    20   0 27888 4268 3092 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3543 thomas    20   0  100m  16m  13m S    0  0.8   0:01.13 /usr/kde/4.0/bin/kr
 3552 thomas    20   0 45268 7904 6588 S    0  0.4   0:00.07 /usr/kde/4.0/bin/ka
 3553 thomas    20   0 54084  12m 9.8m S    0  0.6   0:00.17 kmix -session 1013c
 3562 thomas    20   0 82372  24m  18m S    0  1.2   0:00.83 /usr/kde/4.0/bin/ko
 3564 thomas    20   0 29120 4976 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3565 thomas    20   0 29128 4964 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3566 thomas    20   0 29132 4956 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3567 thomas    20   0 29128 4952 3668 S    0  0.2   0:00.00 kdeinit4: kio_file 
 3574 thomas    20   0  3232 1608 1284 S    0  0.1   0:00.00 /bin/bash          
 3583 thomas    20   0 84144  24m  18m S    0  1.2   0:00.83 kate               
 3585 root      20   0  2712 1296 1000 S    0  0.1   0:00.00 su                 
 3588 root      20   0  2976 1600 1292 S    0  0.1   0:00.00 bash               
 3593 root      20   0  2976  992  656 S    0  0.0   0:00.06 bash               

-- vmstat: --
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 0  0      0 1828644  11328  91624    0    0   327     6  195  624  7  3 75 15
 0  0      0 1828644  11328  91628    0    0     0     0  305  100  0  0 100  0
 0  0      0 1828644  11328  91628    0    0     0     0  420  858  0  0 100  0
 0  0      0 1828644  11328  91628    0    0     0     0  333  233  0  0 100  0
 0  0      0 1828644  11328  91628    0    0     0     0  301   78  0  0 100  0
-- sched_debug #0: --
Mi 26. Mär 18:36:46 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 160490.033540 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 123759
  .nr_load_updates               : 48142
  .nr_uninterruptible            : 4294967152
  .jiffies                       : 4294925438
  .next_balance                  : 4294.925440
  .curr->pid                     : 0
  .clock                         : 160462.924718
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1135382.826931
  .clock_warps                   : 0
  .clock_overflows               : 1805
  .clock_underflows              : 46406
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 256
  .cpu_load[2]                   : 192
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 60

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39717.005323
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 72490
  .nr_load_updates               : 48065
  .nr_uninterruptible            : 144
  .jiffies                       : 4294925438
  .next_balance                  : 4294.925496
  .curr->pid                     : 3838
  .clock                         : 160206.220623
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1135382.776574
  .clock_warps                   : 0
  .clock_overflows               : 4803
  .clock_underflows              : 43345
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 512
  .cpu_load[3]                   : 256
  .cpu_load[4]                   : 128

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39803.541442
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 86.536119
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
R            cat  3838     39759.503530         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #1: --
Mi 26. Mär 18:36:48 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 161542.806446 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 123837
  .nr_load_updates               : 48458
  .nr_uninterruptible            : 4294967152
  .jiffies                       : 4294925754
  .next_balance                  : 4294.925755
  .curr->pid                     : 0
  .clock                         : 161516.135197
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1136435.545380
  .clock_warps                   : 0
  .clock_overflows               : 1806
  .clock_underflows              : 46721
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 256
  .cpu_load[2]                   : 192
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 60

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39758.832247
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 72549
  .nr_load_updates               : 48381
  .nr_uninterruptible            : 144
  .jiffies                       : 4294925754
  .next_balance                  : 4294.925812
  .curr->pid                     : 3841
  .clock                         : 161259.485279
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1136435.548689
  .clock_warps                   : 0
  .clock_overflows               : 4807
  .clock_underflows              : 43657
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 512
  .cpu_load[3]                   : 256
  .cpu_load[4]                   : 128

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 39863.783872
  .min_vruntime                  : 39863.783872
  .max_vruntime                  : 39863.783872
  .spread                        : 0.000000
  .spread0                       : 104.951625
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3593     39863.783872       407   120               0               0               0.000000               0.000000               0.000000
R            cat  3841     39845.105821         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #2: --
Mi 26. Mär 18:36:49 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 162549.579090 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 124191
  .nr_load_updates               : 48760
  .nr_uninterruptible            : 4294967152
  .jiffies                       : 4294926056
  .next_balance                  : 4294.926082
  .curr->pid                     : 0
  .clock                         : 162522.736229
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1137441.680183
  .clock_warps                   : 0
  .clock_overflows               : 1810
  .clock_underflows              : 47019
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 258
  .cpu_load[2]                   : 218
  .cpu_load[3]                   : 168
  .cpu_load[4]                   : 138

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39800.312943
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 72597
  .nr_load_updates               : 48683
  .nr_uninterruptible            : 144
  .jiffies                       : 4294926056
  .next_balance                  : 4294.926114
  .curr->pid                     : 3844
  .clock                         : 162266.086311
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1137441.684285
  .clock_warps                   : 0
  .clock_overflows               : 4839
  .clock_underflows              : 43927
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 512
  .cpu_load[3]                   : 256
  .cpu_load[4]                   : 128

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 39924.034762
  .min_vruntime                  : 39924.034762
  .max_vruntime                  : 39924.034762
  .spread                        : 0.000000
  .spread0                       : 123.721819
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3593     39924.034762       412   120               0               0               0.000000               0.000000               0.000000
R            cat  3844     39905.274295         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #3: --
Mi 26. Mär 18:36:50 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 163556.322540 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 124700
  .nr_load_updates               : 49062
  .nr_uninterruptible            : 4294967152
  .jiffies                       : 4294926358
  .next_balance                  : 4294.926359
  .curr->pid                     : 0
  .clock                         : 163529.337261
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1138447.810590
  .clock_warps                   : 0
  .clock_overflows               : 1815
  .clock_underflows              : 47316
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 256
  .cpu_load[2]                   : 192
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 60

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39873.846932
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 2
  .load                          : 2048
  .nr_switches                   : 72656
  .nr_load_updates               : 48985
  .nr_uninterruptible            : 144
  .jiffies                       : 4294926358
  .next_balance                  : 4294.926416
  .curr->pid                     : 3847
  .clock                         : 163272.687343
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1138447.814067
  .clock_warps                   : 0
  .clock_overflows               : 4861
  .clock_underflows              : 44207
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 512
  .cpu_load[3]                   : 256
  .cpu_load[4]                   : 128

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 39984.319682
  .min_vruntime                  : 39984.319682
  .max_vruntime                  : 39984.319682
  .spread                        : 0.000000
  .spread0                       : 110.472750
  .nr_running                    : 2
  .load                          : 2048
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
            bash  3593     39984.319682       417   120               0               0               0.000000               0.000000               0.000000
R            cat  3847     39965.426512         0   120               0               0               0.000000               0.000000               0.000000

-- sched_debug #4: --
Mi 26. Mär 18:36:51 CET 2008
Sched Debug Version: v0.07, 2.6.25-rc7-x86-latest.git #12
now at 164562.695121 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_batch_wakeup_granularity   : 20.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 15

cpu#0, 1830.914 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 124772
  .nr_load_updates               : 49364
  .nr_uninterruptible            : 4294967152
  .jiffies                       : 4294926660
  .next_balance                  : 4294.926661
  .curr->pid                     : 3593
  .clock                         : 164535.946075
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1139453.949885
  .clock_warps                   : 0
  .clock_overflows               : 1815
  .clock_underflows              : 47618
  .clock_deep_idle_events        : 2
  .clock_max_delta               : 3.333112
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 256
  .cpu_load[2]                   : 192
  .cpu_load[3]                   : 112
  .cpu_load[4]                   : 60

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 39915.329028
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#1, 1830.914 MHz
  .nr_running                    : 2
  .load                          : 4145
  .nr_switches                   : 72711
  .nr_load_updates               : 49287
  .nr_uninterruptible            : 144
  .jiffies                       : 4294926660
  .next_balance                  : 4294.926718
  .curr->pid                     : 3850
  .clock                         : 164279.291480
  .idle_clock                    : 0.000000
  .prev_clock_raw                : 1139453.948360
  .clock_warps                   : 0
  .clock_overflows               : 4864
  .clock_underflows              : 44506
  .clock_deep_idle_events        : 0
  .clock_max_delta               : 3.333113
  .cpu_load[0]                   : 2048
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 512
  .cpu_load[3]                   : 256
  .cpu_load[4]                   : 128

cfs_rq
  .exec_clock                    : 0.000000
  .MIN_vruntime                  : 40024.569051
  .min_vruntime                  : 40044.559276
  .max_vruntime                  : 40024.569051
  .spread                        : 0.000000
  .spread0                       : 129.230248
  .nr_running                    : 2
  .load                          : 4145
  .nr_spread_over                : 0

runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
     kondemand/1   157     40024.569051      2337   115               0               0               0.000000               0.000000               0.000000
R            cat  3850     40025.917063         0   120               0               0               0.000000               0.000000               0.000000


--------------030407010603090703020802--

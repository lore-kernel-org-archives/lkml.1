Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZHRWuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZHRWuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbZHRWuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:50:18 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:61550 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZHRWuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OMryCJHWcy53PJbrFFfM0pwtqrZqraMBP++uBoBfi8Zr67y8ZnVt1i78xj54/xwmwP
         eWOpnElcNP1gROKAGq7lHVtVS2S22Ch0/M9jQ99DPQcKjt+swvIg+nKkmAovpl6WkAsk
         RIM2b3J5Kp5qc9ZHILt8C1Z+TTrFrc35QFnEw=
MIME-Version: 1.0
In-Reply-To: <1f1b08da0908181531v77a2ebc2m53a20512f5266334@mail.gmail.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <1f1b08da0908181531v77a2ebc2m53a20512f5266334@mail.gmail.com>
Date: Tue, 18 Aug 2009 15:50:17 -0700
X-Google-Sender-Auth: 40d7fbedaecff2c3
Message-ID: <1f1b08da0908181550l766805e8kca5c9487e3857e92@mail.gmail.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc6-rt2
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 3:31 PM, john stultz<johnstul@us.ibm.com> wrote:
> On Sun, Aug 16, 2009 at 1:41 PM, Thomas Gleixner<tglx@linutronix.de> wrote:
>> We are pleased to announce the next update to our new preempt-rt
>> series.
>>
>>    - update to 2.6.31-rc6
>>
>
> I'm seeing some bad scheduler behavior with this patch. I've seen
> occasional bad behavior with 2.6.29-rt as well, but with .31-rt its
> much worse.
>
> I'm running a SCHED_OTHER cpubound benchmark  (censored to
> xxxxxxxxxxxxx in the logs) that runs for a number of minutes. With
> 2.6.31-rc6 I'm seeing really poor numbers and if I cat
> /proc/sched_debug I see all of the cpu bound tasks are  running on the
> same cpu, while the other procs are basically idle. See the log below:

Thomas didn't like that I censored the benchmark, so until I know
better about what I can say there, I've reproduced a similar effect
with a make -j8 bzImage. See below:

thanks
-john


Sched Debug Version: v0.09, 2.6.31-rc6-rt2 #2
now at 3297823.422240 msecs
  .jiffies                                 : 4297965119
  .sysctl_sched_latency                    : 60.000000
  .sysctl_sched_min_granularity            : 12.000000
  .sysctl_sched_wakeup_granularity         : 15.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 113917

cpu#0, 2193.531 MHz
  .nr_running                    : 4
  .load                          : 3087
  .nr_switches                   : 10622255
  .nr_load_updates               : 3297812
  .nr_uninterruptible            : 51
  .next_balance                  : 4297.965146
  .curr->pid                     : 26387
  .clock                         : 3297823.016251
  .cpu_load[0]                   : 180594
  .cpu_load[1]                   : 231489
  .cpu_load[2]                   : 238710
  .cpu_load[3]                   : 236501
  .cpu_load[4]                   : 233349
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -13
  .rto_schedule                  : 3359261
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 1
  .sched_switch                  : 0
  .sched_count                   : 17260145
  .sched_goidle                  : 1789234
  .ttwu_count                    : 7093762
  .ttwu_local                    : 7041555
  .bkl_count                     : 544

cfs_rq[0]:
  .exec_clock                    : 1526490.657852
  .MIN_vruntime                  : 1697673.859107
  .min_vruntime                  : 1697721.435148
  .max_vruntime                  : 1697722.132915
  .spread                        : 48.273808
  .spread0                       : 0.000000
  .nr_running                    : 4
  .load                          : 3087
  .nr_spread_over                : 0

rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 2.794815
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
          kipmi0   655   1697673.859107   3125949   139
1697673.859107     22219.014181   3087520.179107
            bash  3472   1697721.436567       311   120
1697721.436567        36.956916   2565232.593307
             cc1 26385   1697722.132915       124   120
1697722.132915       113.879128         0.000000
R            cat 26387   1697662.324743         4   120
1697662.324743         1.030048        16.225876

cpu#1, 2193.531 MHz
  .nr_running                    : 7
  .load                          : 7168
  .nr_switches                   : 7939426
  .nr_load_updates               : 3297202
  .nr_uninterruptible            : 165
  .next_balance                  : 4297.965173
  .curr->pid                     : 26336
  .clock                         : 3297823.399906
  .cpu_load[0]                   : 184690
  .cpu_load[1]                   : 229070
  .cpu_load[2]                   : 218000
  .cpu_load[3]                   : 204927
  .cpu_load[4]                   : 198665
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -13
  .rto_schedule                  : 3372469
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 7948572
  .sched_goidle                  : 2241052
  .ttwu_count                    : 4381283
  .ttwu_local                    : 4325894
  .bkl_count                     : 657

cfs_rq[1]:
  .exec_clock                    : 1071210.085128
  .MIN_vruntime                  : 384918.473172
  .min_vruntime                  : 384918.235870
  .max_vruntime                  : 384918.873276
  .spread                        : 0.400104
  .spread0                       : -1312803.199278
  .nr_running                    : 7
  .load                          : 7168
  .nr_spread_over                : 6

rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 3.774163
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------
             cc1 26050    384918.473172      2253   120
384918.473172      1909.594817       113.729925
             cc1 26315    384918.593007       500   120
384918.593007       454.022678        28.557925
R            cc1 26336    384918.237098       405   120
384918.237098       356.613052        25.673456
             cc1 26351    384918.816523       304   120
384918.816523       274.220163        24.214767
             cc1 26357    384918.476355       290   120
384918.476355       254.796027        28.269487
             cc1 26364    384918.730242       339   120
384918.730242       314.419053        17.154139
             cc1 26378    384918.873276       110   120
384918.873276       100.034046         5.567260

cpu#2, 2193.531 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 7657407
  .nr_load_updates               : 3296882
  .nr_uninterruptible            : -118
  .next_balance                  : 4297.965123
  .curr->pid                     : 0
  .clock                         : 3297823.260220
  .cpu_load[0]                   : 177522
  .cpu_load[1]                   : 177522
  .cpu_load[2]                   : 177522
  .cpu_load[3]                   : 177522
  .cpu_load[4]                   : 177522
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -6
  .rto_schedule                  : 3332888
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 7657972
  .sched_goidle                  : 3078184
  .ttwu_count                    : 4260805
  .ttwu_local                    : 4234948
  .bkl_count                     : 0

cfs_rq[2]:
  .exec_clock                    : 233036.033916
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 107747.557398
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1589973.877750
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[2]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.856935
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

cpu#3, 2193.531 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 7631340
  .nr_load_updates               : 3296553
  .nr_uninterruptible            : -98
  .next_balance                  : 4297.965121
  .curr->pid                     : 0
  .clock                         : 3297823.383808
  .cpu_load[0]                   : 177522
  .cpu_load[1]                   : 177522
  .cpu_load[2]                   : 177522
  .cpu_load[3]                   : 177522
  .cpu_load[4]                   : 177522
  .rt.rt_nr_running              : 0
  .rt.rt_nr_uninterruptible      : -15
  .rto_schedule                  : 3331154
  .rto_schedule_tail             : 0
  .rto_wakeup                    : 0
  .rto_pulled                    : 0
  .rto_pushed                    : 0
  .yld_count                     : 0
  .sched_switch                  : 0
  .sched_count                   : 7632024
  .sched_goidle                  : 3084753
  .ttwu_count                    : 4240808
  .ttwu_local                    : 4233012
  .bkl_count                     : 0

cfs_rq[3]:
  .exec_clock                    : 226437.391084
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 121397.454749
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -1576323.980399
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

rt_rq[3]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.818937
  .rt_runtime                    : 950.000000

runnable tasks:
            task   PID         tree-key  switches  prio
exec-runtime         sum-exec        sum-sleep
----------------------------------------------------------------------------------------------------------

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518AbYAQKNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518AbYAQKNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 05:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYAQKNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 05:13:35 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:48026 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYAQKNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 05:13:33 -0500
X-Auth-Info: wRUDrV8ruEXohwP3U1JhOPbLEkHlDJI/OZTL99EkqrY=
X-Auth-Info: wRUDrV8ruEXohwP3U1JhOPbLEkHlDJI/OZTL99EkqrY=
X-Auth-Info: wRUDrV8ruEXohwP3U1JhOPbLEkHlDJI/OZTL99EkqrY=
X-Auth-Info: wRUDrV8ruEXohwP3U1JhOPbLEkHlDJI/OZTL99EkqrY=
X-Auth-Info: wRUDrV8ruEXohwP3U1JhOPbLEkHlDJI/OZTL99EkqrY=
Message-ID: <478F2A46.5070506@grandegger.com>
Date: Thu, 17 Jan 2008 11:13:26 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-rt1
References: <1200544050.318.18.camel@localhost.localdomain>
In-Reply-To: <1200544050.318.18.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.4.0
Content-Type: multipart/mixed;
 boundary="------------070502000902050303030309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070502000902050303030309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Steven Rostedt wrote:
> We are pleased to announce the 2.6.24-rc8-rt1 tree, which can be
> downloaded from the location:
> 
>   http://rt.et.redhat.com/download/

It builds and runs fine on my Icecube-MPC5200 board, now also with the
latency tracer enabled. That's great. Still, "cyclictest -n -p80 -i1000"
reports latencies up to 400 us and therefore I tried to trigger and save
a high latency trace using:

  # ./cyclictest -n -p80 -i1000 -b400
  1.21 0.33 0.11 4/42 1048

  T: 0 (  914) P:80 I:1000 C:  38726 Min:     61 Act:  107 Avg:  106
Max:     377
  [   91.042169] (      cyclictest-914  |#0): new 39733427 us user-latency.
  bash-3.00# cat /proc/latency_trace > trace.log

Well, I'm not sure if this is the correct way to do it. Is there some
doc on how to use the latency tracer and interpret the results?
Nevertheless, I have attached the beginning of trace.log. Maybe it rings
an experts bell.

TIA.

Wolfgang.

--------------070502000902050303030309
Content-Type: text/x-log;
 name="trace-partial.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="trace-partial.log"

preemption latency trace v1.1.5 on 2.6.24-rc8-rt1
--------------------------------------------------------------------
 latency: 39733427 us, #65536/1202801, CPU#0 | (M:rt VP:0, KP:0, SP:1 HP:1)
    -----------------
    | task: cyclictest-914 (uid:0 nice:0 policy:1 rt_prio:80)
    -----------------

                 _------=> CPU#            
                / _-----=> irqs-off        
               | / _----=> need-resched    
               || / _---=> hardirq/softirq 
               ||| / _--=> preempt-depth   
               |||| /                      
               |||||     delay             
   cmd     pid ||||| time  |   caller      
      \   /    |||||   \   |   /           
cyclicte-914   0D..2    0us+: __schedule+0x21c/0x444 <in.telne-915> (0 180)
cyclicte-914   0D..1   40us+: enqueue_hrtimer+0x50/0x1a0 (   89 5aa9862 c3a6dea8)
cyclicte-914   0D..1   47us+: clockevents_program_event+0x84/0x1c0 (   89 5aa9862 d6316)
cyclicte-914   0D..2   66us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 3)
in.telne-915   0D..2   76us+: __schedule+0x21c/0x444 <cyclicte-914> (180 0)
in.telne-915   0D..2  132us+: deactivate_task+0x60/0xa4 <in.telne-915> (0 2)
      ls-1032  0D..2  143us+: __schedule+0x21c/0x444 <in.telne-915> (0 0)
      ls-1032  0D..3  182us+: activate_task+0x60/0xa4 <in.telne-915> (0 1)
      ls-1032  0DN.3  194us+: try_to_wake_up+0x194/0x1b4 <in.telne-915> (0 0)
in.telne-915   0D..2  211us!: __schedule+0x21c/0x444 <ls-1032> (0 0)
in.telne-915   0D.h2  459us+: activate_task+0x60/0xa4 <IRQ-193-681> (150 2)
in.telne-915   0D.h2  469us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
in.telne-915   0DNh2  476us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
in.telne-915   0DNh2  478us+: try_to_wake_up+0x194/0x1b4 <IRQ-193-681> (150 0)
 IRQ-193-681   0D..2  507us+: __schedule+0x21c/0x444 <in.telne-915> (0 150)
 IRQ-193-681   0D..1  531us+: activate_task+0x60/0xa4 <softirq--6> (150 3)
 IRQ-193-681   0D..2  555us+: deactivate_task+0x60/0xa4 <IRQ-193-681> (150 4)
softirq--6     0D..2  564us+: __schedule+0x21c/0x444 <IRQ-193-681> (150 150)
softirq--6     0D.h2  583us+: activate_task+0x60/0xa4 <IRQ-192-680> (150 3)
softirq--6     0D..2  623us+: deactivate_task+0x60/0xa4 <softirq--6> (150 4)
 IRQ-192-680   0D..2  633us+: __schedule+0x21c/0x444 <softirq--6> (150 150)
 IRQ-192-680   0D..1  668us+: activate_task+0x60/0xa4 <softirq--7> (150 3)
 IRQ-192-680   0D..2  689us+: deactivate_task+0x60/0xa4 <IRQ-192-680> (150 4)
softirq--7     0D..2  698us+: __schedule+0x21c/0x444 <IRQ-192-680> (150 150)
softirq--7     0D..2  769us+: deactivate_task+0x60/0xa4 <softirq--7> (150 3)
in.telne-915   0D..2  782us!: __schedule+0x21c/0x444 <softirq--7> (150 0)
in.telne-915   0D..2  930us+: deactivate_task+0x60/0xa4 <in.telne-915> (0 2)
      ls-1032  0D..2  950us+: __schedule+0x21c/0x444 <in.telne-915> (0 0)
      ls-1032  0D.h.  973us+: hrtimer_interrupt+0xa4/0x2ac (   89 5ab4b1f     0)
      ls-1032  0D.h1  978us+: hrtimer_interrupt+0x114/0x2ac (   89 5aa9862 c3a6dea8)
      ls-1032  0D.h2  988us+: activate_task+0x60/0xa4 <cyclicte-914> (180 1)
      ls-1032  0D.h2  994us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1032  0DNh2  999us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1032  0DNh2 1001us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
      ls-1032  0DNh. 1008us+: clockevents_program_event+0x84/0x1c0 (   89 5ad6bbf 18e8e)
cyclicte-914   0D..2 1033us+: __schedule+0x21c/0x444 <ls-1032> (0 180)
cyclicte-914   0D..1 1071us+: enqueue_hrtimer+0x50/0x1a0 (   89 5b9daa2 c3a6dea8)
cyclicte-914   0D..2 1086us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 2)
      ls-1032  0D..2 1096us+: __schedule+0x21c/0x444 <cyclicte-914> (180 0)
      ls-1032  0D.h. 1124us+: hrtimer_interrupt+0xa4/0x2ac (   89 5ad9cdf     0)
      ls-1032  0D.h1 1127us+: hrtimer_interrupt+0x114/0x2ac (   89 5ad6bbf c3aadea8)
      ls-1032  0D.h2 1142us+: activate_task+0x60/0xa4 <cyclicte-913> (0 1)
      ls-1032  0DNh2 1155us+: try_to_wake_up+0x194/0x1b4 <cyclicte-913> (0 0)
      ls-1032  0DNh. 1163us+: clockevents_program_event+0x84/0x1c0 (   89 5b8d800 a9d94)
cyclicte-913   0D..2 1189us!: __schedule+0x21c/0x444 <ls-1032> (0 0)
cyclicte-913   0D..2 1706us+: deactivate_task+0x60/0xa4 <cyclicte-913> (0 2)
      ls-1032  0D..2 1729us+: __schedule+0x21c/0x444 <cyclicte-913> (0 0)
      ls-1032  0D..2 1747us+: activate_task+0x60/0xa4 <cyclicte-913> (0 1)
      ls-1032  0DN.2 1759us+: try_to_wake_up+0x194/0x1b4 <cyclicte-913> (0 0)
cyclicte-913   0D..2 1773us+: __schedule+0x21c/0x444 <ls-1032> (0 0)
cyclicte-913   0D.h2 1836us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D.h2 1842us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 1848us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 1850us+: try_to_wake_up+0x194/0x1b4 <IRQ-129-682> (150 0)
 IRQ-129-682   0D..2 1873us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D.h. 1893us+: hrtimer_interrupt+0xa4/0x2ac (   89 5b953b0     0)
 IRQ-129-682   0D.h1 1897us+: hrtimer_interrupt+0x114/0x2ac (   89 5b8d800 c0334168)
 IRQ-129-682   0D.h1 1930us+: activate_task+0x60/0xa4 <softirq--5> (150 3)
 IRQ-129-682   0D.h1 1958us+: activate_task+0x60/0xa4 <softirq--12> (150 4)
 IRQ-129-682   0D.h1 1965us+: enqueue_hrtimer+0x50/0x1a0 (   89 5f5e100 c0334168)
 IRQ-129-682   0D.h. 1976us+: clockevents_program_event+0x84/0x1c0 (   89 5b9daa2 -50757)
 IRQ-129-682   0D.h. 1979us+: hrtimer_interrupt+0xa4/0x2ac (   89 5bab507     0)
 IRQ-129-682   0D.h1 1981us+: hrtimer_interrupt+0x114/0x2ac (   89 5b9daa2 c3a6dea8)
 IRQ-129-682   0D.h2 1989us+: activate_task+0x60/0xa4 <cyclicte-914> (180 5)
 IRQ-129-682   0D.h2 1993us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
 IRQ-129-682   0DNh2 1995us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
 IRQ-129-682   0DNh2 1997us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 150)
 IRQ-129-682   0DNh. 2002us+: clockevents_program_event+0x84/0x1c0 (   89 5f5e100 3ad49e)
cyclicte-914   0D..2 2031us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 180)
cyclicte-914   0D..1 2072us+: enqueue_hrtimer+0x50/0x1a0 (   89 5c91ce2 c3a6dea8)
cyclicte-914   0D..1 2078us+: clockevents_program_event+0x84/0x1c0 (   89 5c91ce2 ce9c1)
cyclicte-914   0D..2 2095us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 6)
 IRQ-129-682   0D..2 2102us+: __schedule+0x21c/0x444 <cyclicte-914> (180 150)
 IRQ-129-682   0D..3 2137us+: task_setprio+0xc8/0x268 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 2143us+: task_setprio+0x148/0x268 (    0     0     0)
 IRQ-129-682   0D..2 2151us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 5)
softirq--5     0D..2 2158us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--5     0D..2 2204us+: deactivate_task+0x60/0xa4 <softirq--5> (150 4)
softirq--12    0D..2 2212us+: __schedule+0x21c/0x444 <softirq--5> (150 150)
softirq--12    0D..2 2252us+: deactivate_task+0x60/0xa4 <softirq--12> (150 3)
cyclicte-913   0D..2 2258us+: __schedule+0x21c/0x444 <softirq--12> (150 150)
cyclicte-913   0D..2 2274us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D..2 2284us+: task_setprio+0x190/0x268 <cyclicte-913> (150 0)
cyclicte-913   0DN.2 2293us+: task_setprio+0x148/0x268 (    0     1     0)
 IRQ-129-682   0D..2 2309us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..1 2339us+: activate_task+0x60/0xa4 <softirq--9> (150 3)
 IRQ-129-682   0D..2 2378us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 4)
softirq--9     0D..2 2388us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--9     0D..2 2415us+: deactivate_task+0x60/0xa4 <softirq--9> (150 3)
cyclicte-913   0D..2 2425us+: __schedule+0x21c/0x444 <softirq--9> (150 0)
cyclicte-913   0D.h2 2460us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D.h2 2464us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 2470us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 2472us+: try_to_wake_up+0x194/0x1b4 <IRQ-129-682> (150 0)
 IRQ-129-682   0D..2 2491us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 2518us+: task_setprio+0xc8/0x268 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 2522us+: task_setprio+0x148/0x268 (    0     0     0)
 IRQ-129-682   0D..2 2533us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 3)
cyclicte-913   0D..2 2538us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
cyclicte-913   0D..2 2551us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D..2 2560us+: task_setprio+0x190/0x268 <cyclicte-913> (150 0)
cyclicte-913   0DN.2 2568us+: task_setprio+0x148/0x268 (    0     1     0)
 IRQ-129-682   0D..2 2581us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..1 2595us+: activate_task+0x60/0xa4 <softirq--9> (150 3)
 IRQ-129-682   0D..2 2630us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 4)
softirq--9     0D..2 2637us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--9     0D..2 2663us+: deactivate_task+0x60/0xa4 <softirq--9> (150 3)
cyclicte-913   0D..2 2672us+: __schedule+0x21c/0x444 <softirq--9> (150 0)
cyclicte-913   0D.h2 2708us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D.h2 2712us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 2718us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 2720us+: try_to_wake_up+0x194/0x1b4 <IRQ-129-682> (150 0)
 IRQ-129-682   0D..2 2738us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 2764us+: task_setprio+0xc8/0x268 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 2769us+: task_setprio+0x148/0x268 (    0     0     0)
 IRQ-129-682   0D..2 2779us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 3)
cyclicte-913   0D..2 2783us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
cyclicte-913   0D..2 2796us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D..2 2805us+: task_setprio+0x190/0x268 <cyclicte-913> (150 0)
cyclicte-913   0DN.2 2813us+: task_setprio+0x148/0x268 (    0     1     0)
 IRQ-129-682   0D..2 2826us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..1 2840us+: activate_task+0x60/0xa4 <softirq--9> (150 3)
 IRQ-129-682   0D..2 2875us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 4)
softirq--9     0D..2 2882us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--9     0D..2 2906us+: deactivate_task+0x60/0xa4 <softirq--9> (150 3)
cyclicte-913   0D..2 2915us+: __schedule+0x21c/0x444 <softirq--9> (150 0)
cyclicte-913   0D.h. 2943us+: hrtimer_interrupt+0xa4/0x2ac (   89 5c957d4     0)
cyclicte-913   0D.h1 2947us+: hrtimer_interrupt+0x114/0x2ac (   89 5c91ce2 c3a6dea8)
cyclicte-913   0D.h2 2957us+: activate_task+0x60/0xa4 <cyclicte-914> (180 2)
cyclicte-913   0D.h2 2962us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
cyclicte-913   0DNh2 2968us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
cyclicte-913   0DNh2 2970us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
cyclicte-913   0DNh. 2977us+: clockevents_program_event+0x84/0x1c0 (   89 5f5e100 2bf7ee)
cyclicte-914   0D..2 3001us+: __schedule+0x21c/0x444 <cyclicte-913> (0 180)
cyclicte-914   0D..1 3039us+: enqueue_hrtimer+0x50/0x1a0 (   89 5d85f22 c3a6dea8)
cyclicte-914   0D..1 3045us+: clockevents_program_event+0x84/0x1c0 (   89 5d85f22 d69f3)
cyclicte-914   0D..2 3062us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 3)
cyclicte-913   0D..2 3072us!: __schedule+0x21c/0x444 <cyclicte-914> (180 0)
cyclicte-913   0D.h2 3250us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D.h2 3259us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 3266us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 3268us+: try_to_wake_up+0x194/0x1b4 <IRQ-129-682> (150 0)
 IRQ-129-682   0D..2 3295us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 3329us+: task_setprio+0xc8/0x268 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 3334us+: task_setprio+0x148/0x268 (    0     0     0)
 IRQ-129-682   0D..2 3346us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 3)
cyclicte-913   0D..2 3352us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
cyclicte-913   0D..2 3365us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D..2 3374us+: task_setprio+0x190/0x268 <cyclicte-913> (150 0)
cyclicte-913   0DN.2 3382us+: task_setprio+0x148/0x268 (    0     1     0)
 IRQ-129-682   0D..2 3395us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..1 3433us+: activate_task+0x60/0xa4 <softirq--9> (150 3)
 IRQ-129-682   0D..2 3470us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 4)
softirq--9     0D..2 3478us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--9     0D..2 3504us+: deactivate_task+0x60/0xa4 <softirq--9> (150 3)
cyclicte-913   0D..2 3514us+: __schedule+0x21c/0x444 <softirq--9> (150 0)
cyclicte-913   0D.h2 3546us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D.h2 3549us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 3555us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-129-682> (49 -1)
cyclicte-913   0DNh2 3557us+: try_to_wake_up+0x194/0x1b4 <IRQ-129-682> (150 0)
 IRQ-129-682   0D..2 3575us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 3600us+: task_setprio+0xc8/0x268 <cyclicte-913> (0 150)
 IRQ-129-682   0D..3 3605us+: task_setprio+0x148/0x268 (    0     0     0)
 IRQ-129-682   0D..2 3615us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 3)
cyclicte-913   0D..2 3620us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
cyclicte-913   0D..2 3632us+: activate_task+0x60/0xa4 <IRQ-129-682> (150 2)
cyclicte-913   0D..2 3642us+: task_setprio+0x190/0x268 <cyclicte-913> (150 0)
cyclicte-913   0DN.2 3649us+: task_setprio+0x148/0x268 (    0     1     0)
 IRQ-129-682   0D..2 3662us+: __schedule+0x21c/0x444 <cyclicte-913> (0 150)
 IRQ-129-682   0D..1 3676us+: activate_task+0x60/0xa4 <softirq--9> (150 3)
 IRQ-129-682   0D..2 3711us+: deactivate_task+0x60/0xa4 <IRQ-129-682> (150 4)
softirq--9     0D..2 3718us+: __schedule+0x21c/0x444 <IRQ-129-682> (150 150)
softirq--9     0D..2 3743us+: deactivate_task+0x60/0xa4 <softirq--9> (150 3)
cyclicte-913   0D..2 3752us+: __schedule+0x21c/0x444 <softirq--9> (150 0)
cyclicte-913   0D..1 3812us+: enqueue_hrtimer+0x50/0x1a0 (   89 66f30a0 c3aadea8)
cyclicte-913   0D..2 3831us+: deactivate_task+0x60/0xa4 <cyclicte-913> (0 2)
      ls-1032  0D..2 3844us+: __schedule+0x21c/0x444 <cyclicte-913> (0 0)
      ls-1032  0D.h. 3943us+: hrtimer_interrupt+0xa4/0x2ac (   89 5d89cec     0)
      ls-1032  0D.h1 3947us+: hrtimer_interrupt+0x114/0x2ac (   89 5d85f22 c3a6dea8)
      ls-1032  0D.h2 3965us+: activate_task+0x60/0xa4 <cyclicte-914> (180 1)
      ls-1032  0D.h2 3971us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1032  0DNh2 3977us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1032  0DNh2 3979us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
      ls-1032  0DNh. 3987us+: clockevents_program_event+0x84/0x1c0 (   89 5f5e100 1c90a1)
cyclicte-914   0D..2 4015us+: __schedule+0x21c/0x444 <ls-1032> (0 180)
cyclicte-914   0D..1 4063us+: enqueue_hrtimer+0x50/0x1a0 (   89 5e7a162 c3a6dea8)
cyclicte-914   0D..1 4071us+: clockevents_program_event+0x84/0x1c0 (   89 5e7a162 d086a)
cyclicte-914   0D..2 4088us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 2)
      ls-1032  0D..2 4101us!: __schedule+0x21c/0x444 <cyclicte-914> (180 0)
      ls-1032  0D..1 4259us+: activate_task+0x60/0xa4 <in.telne-915> (0 1)
      ls-1032  0DN.1 4276us+: try_to_wake_up+0x194/0x1b4 <in.telne-915> (0 0)
in.telne-915   0D..2 4301us+: __schedule+0x21c/0x444 <ls-1032> (0 0)
in.telne-915   0D..2 4371us+: deactivate_task+0x60/0xa4 <in.telne-915> (0 2)
      ls-1032  0D..2 4381us+: __schedule+0x21c/0x444 <in.telne-915> (0 0)
      ls-1032  0D..2 4393us+: activate_task+0x60/0xa4 <in.telne-915> (0 1)
      ls-1032  0DN.2 4401us+: try_to_wake_up+0x194/0x1b4 <in.telne-915> (0 0)
in.telne-915   0D..2 4413us+: __schedule+0x21c/0x444 <ls-1032> (0 0)
in.telne-915   0D..2 4474us+: deactivate_task+0x60/0xa4 <in.telne-915> (0 2)
      ls-1032  0D..2 4483us+: __schedule+0x21c/0x444 <in.telne-915> (0 0)
      ls-1032  0D..3 4518us+: activate_task+0x60/0xa4 <in.telne-915> (0 1)
      ls-1032  0DN.3 4529us+: try_to_wake_up+0x194/0x1b4 <in.telne-915> (0 0)
in.telne-915   0D..2 4546us!: __schedule+0x21c/0x444 <ls-1032> (0 0)
in.telne-915   0D.h2 4801us+: activate_task+0x60/0xa4 <IRQ-193-681> (150 2)
in.telne-915   0D.h2 4811us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
in.telne-915   0DNh2 4818us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
in.telne-915   0DNh2 4820us+: try_to_wake_up+0x194/0x1b4 <IRQ-193-681> (150 0)
 IRQ-193-681   0D..2 4849us+: __schedule+0x21c/0x444 <in.telne-915> (0 150)
 IRQ-193-681   0D..1 4873us+: activate_task+0x60/0xa4 <softirq--6> (150 3)
 IRQ-193-681   0D..2 4897us+: deactivate_task+0x60/0xa4 <IRQ-193-681> (150 4)
softirq--6     0D..2 4906us+: __schedule+0x21c/0x444 <IRQ-193-681> (150 150)
softirq--6     0D.h2 4926us+: activate_task+0x60/0xa4 <IRQ-192-680> (150 3)
softirq--6     0D.h. 4949us+: hrtimer_interrupt+0xa4/0x2ac (   89 5e7f499     0)
softirq--6     0D.h1 4953us+: hrtimer_interrupt+0x114/0x2ac (   89 5e7a162 c3a6dea8)
softirq--6     0D.h2 4962us+: activate_task+0x60/0xa4 <cyclicte-914> (180 4)
softirq--6     0D.h2 4966us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
softirq--6     0DNh2 4968us : __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
softirq--6     0DNh2 4970us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 150)
softirq--6     0DNh. 4976us+: clockevents_program_event+0x84/0x1c0 (   89 5f5e100 d74d9)
...
 IRQ-192-680   0D..2 1904945us+: __schedule+0x21c/0x444 <softirq--6> (150 150)
 IRQ-192-680   0D.h. 1904964us+: hrtimer_interrupt+0xa4/0x2ac (   90 3b8d19da     0)
 IRQ-192-680   0D.h1 1904969us+: hrtimer_interrupt+0x114/0x2ac (   90 3b8c8a62 c3a6dea8)
 IRQ-192-680   0D.h2 1904981us+: activate_task+0x60/0xa4 <cyclicte-914> (180 4)
 IRQ-192-680   0D.h2 1904986us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
 IRQ-192-680   0DNh2 1904988us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
 IRQ-192-680   0DNh2 1904990us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 150)
 IRQ-192-680   0DNh. 1904997us+: clockevents_program_event+0x84/0x1c0 (   91     0 d2386)
cyclicte-914   0D..2 1905019us+: __schedule+0x21c/0x444 <IRQ-192-680> (150 180)
cyclicte-914   0D..1 1905066us+: enqueue_hrtimer+0x50/0x1a0 (   91 66210 c3a6dea8)
cyclicte-914   0D..2 1905080us+: deactivate_task+0x60/0xa4 <cyclicte-914> (180 5)
 IRQ-192-680   0D..2 1905087us+: __schedule+0x21c/0x444 <cyclicte-914> (180 150)
 IRQ-192-680   0D..1 1905123us+: activate_task+0x60/0xa4 <softirq--7> (150 4)
 IRQ-192-680   0D..2 1905147us+: deactivate_task+0x60/0xa4 <IRQ-192-680> (150 5)
softirq--7     0D..2 1905156us!: __schedule+0x21c/0x444 <IRQ-192-680> (150 150)
softirq--7     0D..2 1905281us+: deactivate_task+0x60/0xa4 <softirq--7> (150 4)
      ls-1048  0D..2 1905300us!: __schedule+0x21c/0x444 <softirq--7> (150 0)
      ls-1048  0D.h1 1905880us+: hrtimer_interrupt+0xa4/0x2ac (   91 17423     0)
      ls-1048  0D.h2 1905888us+: hrtimer_interrupt+0x114/0x2ac (   91     0 c0334168)
      ls-1048  0D.h2 1905932us+: activate_task+0x60/0xa4 <softirq--5> (150 3)
      ls-1048  0D.h2 1905938us+: __trace_start_sched_wakeup+0x154/0x18c <softirq--5> (49 -1)
      ls-1048  0DNh2 1905943us+: __trace_start_sched_wakeup+0x154/0x18c <softirq--5> (49 -1)
      ls-1048  0DNh2 1905945us+: try_to_wake_up+0x194/0x1b4 <softirq--5> (150 0)
      ls-1048  0DNh2 1905971us+: activate_task+0x60/0xa4 <softirq--12> (150 4)
      ls-1048  0DNh2 1905973us+: __trace_start_sched_wakeup+0x154/0x18c <softirq--12> (49 -1)
      ls-1048  0DNh2 1905977us : __trace_start_sched_wakeup+0x154/0x18c <softirq--12> (49 -1)
      ls-1048  0DNh2 1905978us+: try_to_wake_up+0x194/0x1b4 <softirq--12> (150 0)
      ls-1048  0DNh2 1905985us+: enqueue_hrtimer+0x50/0x1a0 (   91 3d0900 c0334168)
      ls-1048  0DNh1 1905995us+: clockevents_program_event+0x84/0x1c0 (   91 66210 -69455)
      ls-1048  0DNh1 1905998us+: hrtimer_interrupt+0xa4/0x2ac (   91 225b6     0)
      ls-1048  0DNh2 1906000us+: hrtimer_interrupt+0x114/0x2ac (   91 66210 c3a6dea8)
      ls-1048  0DNh3 1906013us+: activate_task+0x60/0xa4 <cyclicte-914> (180 5)
      ls-1048  0DNh3 1906017us+: __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1048  0DNh3 1906021us : __trace_start_sched_wakeup+0x154/0x18c <cyclicte-914> (19 -1)
      ls-1048  0DNh3 1906023us+: try_to_wake_up+0x194/0x1b4 <cyclicte-914> (180 0)
      ls-1048  0DNh1 1906028us!: clockevents_program_event+0x84/0x1c0 (   91 391676 367eff)
      ls-1048  0DNh2 1906274us+: activate_task+0x60/0xa4 <IRQ-193-681> (150 6)
      ls-1048  0DNh2 1906285us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
      ls-1048  0DNh2 1906293us+: __trace_start_sched_wakeup+0x154/0x18c <IRQ-193-681> (49 -1)
      ls-1048  0DNh2 1906295us+: try_to_wake_up+0x194/0x1b4 <IRQ-193-681> (150 0)
cyclicte-914   0D..2 1906332us : __schedule+0x21c/0x444 <ls-1048> (0 180)


vim:ft=help

--------------070502000902050303030309--

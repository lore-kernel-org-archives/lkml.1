Return-Path: <linux-kernel-owner+w=401wt.eu-S1752348AbZK1Prg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbZK1Prg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZK1Prg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:47:36 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:51400 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZK1Prf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:47:35 -0500
Date: Sat, 28 Nov 2009 10:47:38 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
In-reply-to: <20091128071808.GA32183@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Message-id: <4B11461A.3020408@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4B106CC0.4050406@majjas.com> <20091128071808.GA32183@elte.hu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok - did the following in runlevel 3 to avoid the dmar errors I'm 
getting with nouveau & vt-d.
In theory, the system was similarly loaded (i.e., doing pretty much 
nothing) for both runs.
The sample is consistent with what I've seen previously.

Perhaps there's no issue, or perhaps the issue is with my broken bios 
and intel_iommu=on.

Perf top with intel_iommu=off: (snapshop) - acpi_os_read_port is often 
#1 and I've seen it over 30%.
------------------------------------------------------------------------------
   PerfTop:    3957 irqs/sec  kernel:84.0% [100000 cycles],  (all, 8 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

             3183.00 - 16.7% : _spin_lock
             3167.00 - 16.7% : acpi_os_read_port
             1053.00 -  5.5% : io_apic_modify_irq
              810.00 -  4.3% : hpet_next_event
              529.00 -  2.8% : _spin_lock_irqsave
              522.00 -  2.7% : io_apic_sync
              283.00 -  1.5% : tg_shares_up
              270.00 -  1.4% : acpi_idle_enter_bm
              259.00 -  1.4% : irq_to_desc
              222.00 -  1.2% : i8042_interrupt
              213.00 -  1.1% : acpi_hw_validate_io_request
              204.00 -  1.1% : ktime_get
              180.00 -  0.9% : find_busiest_group
              169.00 -  0.9% : _spin_unlock_irqrestore
              168.00 -  0.9% : sub_preempt_count

 Performance counter stats for 'sleep 1' (10 runs):

    8021.581362  task-clock-msecs         #      8.009 CPUs    ( +-   
0.033% )
            607  context-switches         #      0.000 M/sec   ( +-   
4.251% )
             27  CPU-migrations           #      0.000 M/sec   ( +-  
11.455% )
            408  page-faults              #      0.000 M/sec   ( +-  
34.557% )
      311405638  cycles                   #     38.821 M/sec   ( +-   
6.887% )
       85807775  instructions             #      0.276 IPC     ( +-  
13.824% )
        2300079  cache-references         #      0.287 M/sec   ( +-   
6.859% )
          77314  cache-misses             #      0.010 M/sec   ( +-  
11.184% )

    1.001616593  seconds time elapsed   ( +-   0.009% )

intel_iommu on:
------------------------------------------------------------------------------
   PerfTop:    9941 irqs/sec  kernel:81.9% [100000 cycles],  (all, 8 CPUs)
------------------------------------------------------------------------------

             samples    pcnt   kernel function
             _______   _____   _______________

            11465.00 - 20.8% : _spin_lock
             3679.00 -  6.7% : io_apic_modify_irq
             3295.00 -  6.0% : hpet_next_event
             2172.00 -  3.9% : _spin_lock_irqsave
             2111.00 -  3.8% : acpi_os_read_port
             1094.00 -  2.0% : io_apic_sync
              904.00 -  1.6% : find_busiest_group
              695.00 -  1.3% : _spin_unlock_irqrestore
              686.00 -  1.2% : tg_shares_up
              620.00 -  1.1% : acpi_idle_enter_bm
              577.00 -  1.0% : add_preempt_count
              568.00 -  1.0% : sub_preempt_count
              475.00 -  0.9% : audit_filter_syscall
              470.00 -  0.9% : schedule
              450.00 -  0.8% : tick_nohz_stop_sched_tick

 Performance counter stats for 'sleep 1' (10 runs):

    8015.967731  task-clock-msecs         #      8.003 CPUs    ( +-   
0.024% )
           2628  context-switches         #      0.000 M/sec   ( +-  
20.053% )
            124  CPU-migrations           #      0.000 M/sec   ( +-  
20.561% )
           3014  page-faults              #      0.000 M/sec   ( +-  
35.573% )
      850702031  cycles                   #    106.126 M/sec   ( +-  
10.601% )
      311032631  instructions             #      0.366 IPC     ( +-  
17.859% )
        8578386  cache-references         #      1.070 M/sec   ( +-  
13.894% )
         333768  cache-misses             #      0.042 M/sec   ( +-  
21.894% )

    1.001656333  seconds time elapsed   ( +-   0.008% )


Ingo Molnar wrote:
> * Michael Breuer <mbreuer@majjas.com> wrote:
>
>   
>> Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
>> intel_iommu=off. Whilst my myriad of broken bios issues cleared, I now 
>> see in perf top acpi_os_read_port as continually the busiest function. 
>> With intel_iommu enabled, _spin_lock was always on top, and nothing 
>> else was notable.
>>
>> This seems odd to me, perhaps this will make sense to someone else.
>>
>> FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors or 
>> oddities in dmesg or /var/log/messages.
>>     
>
> Could you post the perf top output please?
>
> Also, could you also post the output of:
>
> 	perf stat -a --repeat 10 sleep 1
>
> this will show us how idle the system is. (My guess is that your system 
> is idle and perf top shows acpi_os_read_port because the system goes to 
> idle via ACPI methods and PIO is slow. In that case all is nominal and 
> your system is fine. But it's hard to tell without more details.)
>
> Thanks,
>
> 	Ingo
>   


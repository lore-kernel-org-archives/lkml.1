Return-Path: <linux-kernel-owner+w=401wt.eu-S1759032AbZDWWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032AbZDWWll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbZDWWld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:41:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22635 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbZDWWlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:41:32 -0400
X-BigFish: VPS-44(zz154dM1432R98dR936eQ1805M936fK1804K197bizz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <49F0EE7A.8090400@am.sony.com>
Date: Thu, 23 Apr 2009 15:40:58 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: =?UTF-8?B?VXdlIO+/vQ==?= <u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH] Add function graph tracer support for ARM
References: <49F0AEA2.5010309@am.sony.com> <20090423183905.GA8383@pengutronix.de> <49F0E284.2080104@am.sony.com> <20090423221516.GB5976@nowhere>
In-Reply-To: <20090423221516.GB5976@nowhere>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 23 Apr 2009 22:40:59.0897 (UTC) FILETIME=[9302AE90:01C9C464]
X-SEL-encryption-scan: scanned
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> On Thu, Apr 23, 2009 at 02:49:56PM -0700, Tim Bird wrote:
>> Uwe � wrote:
>>>> Signed-off-by: <tim.bird@am.sony.com>
>>> According to Documentation/SubmittingPatches you need to provide your
>>> real name in the S-o-b line.
>> OK -that's embarrassing - I'll fix this.
>> scripts/checkpatch.pl didn't catch this.  I may look at adding
>> something to checkpatch.pl to catch empty names.
>>
>>> For the lazy of us, can you point me^Uus to some documentation how to
>>> use the graph tracer?
>> It looks like Documentation/ftrace.txt is missing anything about
>> function graph tracing.
>>
>> Should I add a section?
> 
> 
> 
> There is already a section in Documentation/frace.txt as well in 2.6.30 :-)

LOL. :-)

> Oh, that's the first function graph trace from Arm I can see.
> /me feels a bit moved...
> 
> Just one childish caprice...it would be nice to see a part of a
> trace which shows specific Arm arch functions in the next changelog :-)

Will do.  Here's something to tide you over.  I have pages and
pages of the following (repeating over and over):

 0)               |  omap_pm_idle() {
 0) + 30.518 us   |    omap_dma_running();
 0)               |    __exception_text_start() {
 0)               |      irq_enter() {
 0)   0.000 us    |        idle_cpu();
 0)   0.000 us    |      }
 0)   0.000 us    |      irq_to_desc();
 0)               |      handle_level_irq() {
 0) + 30.517 us   |        omap_mask_irq();
 0)               |        omap_mask_ack_irq() {
 0)   0.000 us    |          omap_mask_irq();
 0) + 30.518 us   |        }
 0)               |        handle_IRQ_event() {
 0)               |          omap_mpu_timer1_interrupt() {
 0)               |            tick_handle_periodic() {
 0)               |              tick_periodic() {
 0)               |                do_timer() {
 0)               |                  update_wall_time() {
 0)   0.000 us    |                    mpu_read();
 0)   0.000 us    |                    update_xtime_cache();
 0) + 30.517 us   |                    clocksource_get_next();
 0) ! 122.070 us  |                  }
 0) ! 183.106 us  |                }
 0)               |                update_process_times() {
 0)               |                  account_process_tick() {
 0) + 30.517 us   |                    account_idle_time();
 0) + 30.517 us   |                  }
 0)               |                  run_local_timers() {
 0)               |                    hrtimer_run_queues() {
 0)   0.000 us    |                      current_kernel_time();
 0) + 30.518 us   |                    }
 0)   0.000 us    |                    raise_softirq();
 0)               |                    softlockup_tick() {
 0)               |                      get_timestamp() {
 0)   0.000 us    |                        sched_clock();
 0)   0.000 us    |                      }
 0) + 61.035 us   |                    }
 0) ! 122.071 us  |                  }
 0)               |                  rcu_pending() {
 0)   0.000 us    |                    __rcu_pending();
 0)   0.000 us    |                    __rcu_pending();
 0) + 61.035 us   |                  }
 0)   0.000 us    |                  printk_tick();
 0)               |                  scheduler_tick() {
 0)   0.000 us    |                    sched_clock();
 0) + 30.518 us   |                    task_tick_idle();
 0) + 61.035 us   |                  }
 0)   0.000 us    |                  run_posix_cpu_timers();
 0) ! 305.176 us  |                }
 0)   0.000 us    |                profile_tick();
 0) ! 518.799 us  |              }
 0) ! 518.799 us  |            }
 0) ! 549.316 us  |          }
 0) ! 549.316 us  |        }
 0)   0.000 us    |        note_interrupt();
 0)   0.000 us    |        omap_unmask_irq();
 0) ! 671.386 us  |      }
 0)               |      irq_exit() {
 0)               |        __do_softirq() {
 0)               |          run_timer_softirq() {
 0)   0.000 us    |            hrtimer_run_pending();
 0) + 30.518 us   |          }
 0)   0.000 us    |          _local_bh_enable();
 0) + 61.036 us   |        }
 0) + 91.553 us   |      }
 0) ! 823.975 us  |    }
 0) ! 9979.248 us |  }

Enjoy :-)
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================


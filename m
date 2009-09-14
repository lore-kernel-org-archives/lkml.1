Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZINGQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZINGQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 02:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbZINGQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 02:16:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINGQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 02:16:42 -0400
Date: Mon, 14 Sep 2009 08:15:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Eric Paris <eparis@redhat.com>
Cc: James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, dhowells@redhat.com
Subject: Re: [origin tree boot hang] lockup in key_schedule_gc()
Message-ID: <20090914061552.GA23803@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org> <20090912072450.GA6767@elte.hu> <1252748791.2305.89.camel@dhcp231-106.rdu.redhat.com> <20090912104346.GB27935@elte.hu> <20090912135808.GA17416@elte.hu> <1252787226.13780.1.camel@dhcp231-106.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252787226.13780.1.camel@dhcp231-106.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Paris <eparis@redhat.com> wrote:

> On Sat, 2009-09-12 at 15:58 +0200, Ingo Molnar wrote:
> > here's a new crash related to security changes - a boot lockup on a 
> > testbox:
> > 
> > Pid: 5, comm: events/0 Tainted: G        W  (2.6.31-tip-02301-g1c11bd7-dirty #13102) System Product Name
> > EIP: 0060:[<c104ad77>] EFLAGS: 00000046 CPU: 0
> > EIP is at trace_hardirqs_off_caller+0x30/0x9a
> > EAX: 00000002 EBX: f70431c0 ECX: c18c8e58 EDX: c10138ce
> > ESI: c10138ce EDI: 00000002 EBP: f7051ddc ESP: f7051dd4
> >  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> > CR0: 8005003b CR2: b745e530 CR3: 3618f000 CR4: 000006d0
> > DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: c210fa6c
> > DR6: ffff0ff0 DR7: 00000400
> > Call Trace:
> >  [<c104adec>] trace_hardirqs_off+0xb/0xd
> >  [<c10138ce>] default_send_IPI_mask_logical+0xd2/0xe3
> >  [<c1013759>] default_send_IPI_all+0x27/0x67
> >  [<c1013a97>] arch_trigger_all_cpu_backtrace+0x30/0x54
> >  [<c1060c46>] __rcu_pending+0x49/0x113
> >  [<c1060d2d>] rcu_check_callbacks+0x1d/0x9c
> >  [<c103390c>] update_process_times+0x29/0x3e
> >  [<c104713c>] tick_periodic+0x6a/0x6c
> >  [<c1047152>] tick_handle_periodic+0x14/0x6a
> >  [<c1013463>] smp_apic_timer_interrupt+0x63/0x73
> >  [<c100302f>] apic_timer_interrupt+0x2f/0x40
> >  [<c15fdaaa>] ? _spin_unlock_irqrestore+0x3d/0x41
> >  [<c103a685>] __queue_work+0x2b/0x30
> >  [<c103a6d1>] queue_work_on+0x2c/0x36
> >  [<c103a7b2>] queue_work+0x13/0x15
> >  [<c103a7c8>] schedule_work+0x14/0x16
> >  [<c125178a>] key_schedule_gc+0x28/0x4e
> >  [<c1251917>] key_garbage_collector+0x167/0x180
> >  [<c103a004>] run_workqueue+0xfb/0x1c4
> >  [<c1039fe5>] ? run_workqueue+0xdc/0x1c4
> >  [<c12517b0>] ? key_garbage_collector+0x0/0x180
> >  [<c103a146>] worker_thread+0x79/0x85
> >  [<c103d3e3>] ? autoremove_wake_function+0x0/0x38
> >  [<c103a0cd>] ? worker_thread+0x0/0x85
> >  [<c103d1d2>] kthread+0x65/0x6a
> >  [<c103d16d>] ? kthread+0x0/0x6a
> >  [<c1003267>] kernel_thread_helper+0x7/0x10
> > Pid: 5, comm: events/0 Tainted: G        W  2.6.31-tip-02301-g1c11bd7-dirty #13102
> > 
> > config and bootlog attached.
> 
> Adding dhowells, the keys maintainer, this one certainly isn't 
> obvious to me off hand.

this bug also manifests itself in a plain 64-bit x86 defconfig 
bootup on a system, events/1 goes looping burning 100% CPU time a 
few minutes into the bootup:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND                    
    8 root      20   0     0    0    0 R  100  0.0   4:39.22 events/1                   
 3005 mingo     20   0 14728 1068  736 R    2  0.1   0:00.01 top                        
    1 root      20   0 10308  732  616 S    0  0.1   0:01.59 init                       
    2 root      20   0     0    0    0 S    0  0.0   0:00.00 kthreadd                   

i've enabled the function graph tracer and events/1 does an ever 
repeating loop of key_garbage_collector(), the same thing i reported 
in the lockup:

 1)               |  key_garbage_collector() {
 1)   0.310 us    |    current_kernel_time();
 1)   0.349 us    |    _spin_lock();
 1)               |    key_schedule_gc() {
 1)   0.327 us    |      current_kernel_time();
 1)               |      schedule_work() {
 1)               |        queue_work() {
 1)               |          queue_work_on() {
 1)               |            __queue_work() {
 1)               |              _spin_lock_irqsave() {
 1)               |              insert_work() {
 1)               |                __wake_up() {
 1)   0.317 us    |                  _spin_lock_irqsave();
 1)   0.345 us    |                  __wake_up_common();
 1)   0.298 us    |                  _spin_unlock_irqrestore();
 1)   2.242 us    |                }
 1)   2.865 us    |              }
 1)   0.351 us    |              _spin_unlock_irqrestore();
 1)   4.811 us    |            }
 1)   5.434 us    |          }
 1)   5.946 us    |        }
 1)   6.601 us    |      }
 1)   7.964 us    |    }
 1) + 10.169 us   |  }
 1)   0.358 us    |  _spin_lock_irq();

find below a few more excerpts from the trace.

	Ingo

 1)               |  key_garbage_collector() {
 1)   0.310 us    |    current_kernel_time();
 1)   0.349 us    |    _spin_lock();
 1)               |    key_schedule_gc() {
 1)   0.327 us    |      current_kernel_time();
 1)               |      schedule_work() {
 1)               |        queue_work() {
 1)               |          queue_work_on() {
 1)               |            __queue_work() {
 1)               |              _spin_lock_irqsave() {
 1)               |              insert_work() {
 1)               |                __wake_up() {
 1)   0.317 us    |                  _spin_lock_irqsave();
 1)   0.345 us    |                  __wake_up_common();
 1)   0.298 us    |                  _spin_unlock_irqrestore();
 1)   2.242 us    |                }
 1)   2.865 us    |              }
 1)   0.351 us    |              _spin_unlock_irqrestore();
 1)   4.811 us    |            }
 1)   5.434 us    |          }
 1)   5.946 us    |        }
 1)   6.601 us    |      }
 1)   7.964 us    |    }
 1) + 10.169 us   |  }
 1)   0.358 us    |  _spin_lock_irq();
 1)               |  key_garbage_collector() {
 1)   0.319 us    |    current_kernel_time();
 1)   0.317 us    |    _spin_lock();
 1)               |    key_schedule_gc() {
 1)   0.286 us    |      current_kernel_time();
 1)               |      schedule_work() {
 1)               |        queue_work() {
 1)               |          queue_work_on() {
 1)               |            __queue_work() {
 1)   0.310 us    |              _spin_lock_irqsave();
 1)               |              insert_work() {
 1)               |                __wake_up() {
 1)   0.335 us    |                  _spin_lock_irqsave();
 1)   0.293 us    |                  __wake_up_common();
 1)   0.341 us    |                  _spin_unlock_irqrestore();
 1)   2.206 us    |                }
 1)   2.873 us    |              }
 1)   0.311 us    |              _spin_unlock_irqrestore();
 1)   4.765 us    |            }
 1)   5.380 us    |          }
 1)   6.063 us    |        }
 1)   6.691 us    |      }
 1)   8.023 us    |    }
 1) + 10.250 us   |  }
 1)   0.336 us    |  _spin_lock_irq();
 1)               |  key_garbage_collector() {
 1)   0.285 us    |    current_kernel_time();
 1)               |    _spin_lock() {
 1)               |    key_schedule_gc() {
 1)   0.323 us    |      current_kernel_time();
 1)               |      schedule_work() {
 1)               |        queue_work() {
 1)               |          queue_work_on() {
 1)               |            __queue_work() {
 1)   0.287 us    |              _spin_lock_irqsave();
 1)               |              insert_work() {
 1)               |                __wake_up() {
 1)   0.326 us    |                  _spin_lock_irqsave();
 1)   0.297 us    |                  __wake_up_common();
 1)   0.228 us    |                  _spin_unlock_irqrestore();
 1)   2.197 us    |                }
 1)   3.173 us    |              }
 1)   0.386 us    |              _spin_unlock_irqrestore();
 1)   5.049 us    |            }
 1)   5.659 us    |          }
 1)   6.191 us    |        }
 1)   6.723 us    |      }
 1)   7.946 us    |    }
 1) + 10.031 us   |  }
 1)   0.301 us    |  _spin_lock_irq();
 1)               |  key_garbage_collector() {
 1)   0.252 us    |    current_kernel_time();
 1)   0.234 us    |    _spin_lock();
 1)               |    key_schedule_gc() {
 1)   0.262 us    |      current_kernel_time();
 1)               |      schedule_work() {
 1)               |        queue_work() {
 1)               |          queue_work_on() {
 1)               |            __queue_work() {
 1)   0.235 us    |              _spin_lock_irqsave();
 1)               |              insert_work() {
 1)               |                __wake_up() {
 1)   0.267 us    |                  _spin_lock_irqsave();
 1)   0.231 us    |                  __wake_up_common();
 1)   0.266 us    |                  _spin_unlock_irqrestore();
 1)   1.785 us    |                }
 1)   2.320 us    |              }
 1)   0.228 us    |              _spin_unlock_irqrestore();
 1)   3.900 us    |            }
 1)   4.433 us    |          }
 1)   4.980 us    |        }
 1)   5.505 us    |      }
 1)   6.571 us    |    }
 1)   8.376 us    |  }

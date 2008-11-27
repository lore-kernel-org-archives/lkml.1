Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYK0K4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYK0K4J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755009AbYK0Ken
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:34:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55390 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712AbYK0Kel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:34:41 -0500
Date: Thu, 27 Nov 2008 11:34:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tim Bird <tim.bird@am.sony.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] tracing/function-branch-tracer: enhancements for the
	trace output
Message-ID: <20081127103424.GA9132@elte.hu>
References: <492DEDE9.9010109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DEDE9.9010109@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Here is an example of the new output:
> 
> CPU[000]           dequeue_entity() {                    -
> CPU[000]             update_curr() {                    -
> CPU[000]               update_min_vruntime();                    + 0.512 us
> CPU[000]             }                                + 1.504 us
> CPU[000]             clear_buddies();                    + 0.481 us
> CPU[000]             update_min_vruntime();                    + 0.504 us
> CPU[000]           }                                + 4.557 us
> CPU[000]           hrtick_update() {                    -
> CPU[000]             hrtick_start_fair();                    + 0.489 us
> CPU[000]           }                                + 1.443 us
> CPU[000] +       }                                + 14.655 us
> CPU[000] +     }                                + 15.678 us
> CPU[000] +   }                                + 16.686 us
> CPU[000]     msecs_to_jiffies();                    + 0.481 us
> CPU[000]     put_prev_task_fair();                    + 0.504 us
> CPU[000]     pick_next_task_fair();                    + 0.482 us
> CPU[000]     pick_next_task_rt();                    + 0.504 us
> CPU[000]     pick_next_task_fair();                    + 0.481 us
> CPU[000]     pick_next_task_idle();                    + 0.489 us
> CPU[000]     _spin_trylock();                    + 0.655 us
> CPU[000]     _spin_unlock();                    + 0.609 us
> 
> CPU[000]  ------------8<---------- thread bash-2794 ------------8<----------
> 
> CPU[000]               finish_task_switch() {                    -
> CPU[000]                 _spin_unlock_irq();                    + 0.722 us
> CPU[000]               }                                + 2.369 us
> CPU[000] !           }                                + 501972.605 us
> CPU[000] !         }                                + 501973.763 us
> CPU[000]           copy_from_read_buf() {                    -
> CPU[000]             _spin_lock_irqsave();                    + 0.670 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.699 us
> CPU[000]             copy_to_user() {                    -
> CPU[000]               might_fault() {                    -
> CPU[000]                 __might_sleep();                    + 0.503 us
> CPU[000]               }                                + 1.632 us
> CPU[000]               __copy_to_user_ll();                    + 0.542 us
> CPU[000]             }                                + 3.858 us
> CPU[000]             tty_audit_add_data() {                    -
> CPU[000]               _spin_lock_irq();                    + 0.609 us
> CPU[000]               _spin_unlock_irq();                    + 0.624 us
> CPU[000]             }                                + 3.196 us
> CPU[000]             _spin_lock_irqsave();                    + 0.624 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.625 us
> CPU[000] +         }                                + 13.611 us
> CPU[000]           copy_from_read_buf() {                    -
> CPU[000]             _spin_lock_irqsave();                    + 0.624 us
> CPU[000]             _spin_unlock_irqrestore();                    + 0.616 us
> CPU[000]           }                                + 2.820 us
> CPU[000]

cool :-)

One small detail. Could you please make the cost numbers on the right 
side be aligned to the _left_ boundary of the function name, not the 
right side of it?

I.e. instead of:


CPU[000]   sys_read() {                    -
CPU[000]     fget_light();                    + 0.331 us
CPU[000]     vfs_read() {                    -
CPU[000]       rw_verify_area() {                    -
CPU[000]         security_file_permission() {                    -
CPU[000]           cap_file_permission();                    + 0.306 us
CPU[000]         }                                + 0.993 us
CPU[000]       }                                + 1.649 us
CPU[000]       do_sync_read() {                    -
CPU[000]         sock_aio_read() {                    -
CPU[000]           __sock_recvmsg() {                    -
CPU[000]             security_socket_recvmsg() {                    -
CPU[000]               cap_socket_recvmsg();                    + 0.319 us

My original suggestion was to have:

CPU[000]   sys_read() {                        -
CPU[000]     fget_light();                       + 0.331 us
CPU[000]     vfs_read() {                        -
CPU[000]       rw_verify_area() {                  -
CPU[000]         security_file_permission() {        -
CPU[000]           cap_file_permission();              + 0.306 us
CPU[000]         }                                   + 0.993 us
CPU[000]       }                                   + 1.649 us
CPU[000]       do_sync_read() {                    -
CPU[000]         sock_aio_read() {                   -
CPU[000]           __sock_recvmsg() {                  -
CPU[000]             security_socket_recvmsg() {         -
CPU[000]               cap_socket_recvmsg();               + 0.319 us

Note how much easier it is to line up numbers and nesting with each 
other.

But in fact, it might be even better to display the costs like this, 
on the left side [mockup]:

---------------------------------------------------------
CPU)     cost    |  function
---------------------------------------------------------

  0)             |  sys_read() {
  0)    0.331 us |    fget_light();
  0)             |    vfs_read() {
  0)             |      rw_verify_area() {
  0)             |        security_file_permission() {
  0)    0.306 us |          cap_file_permission();
  0)    0.300 us |          cap_file_permission();
  0)    8.909 us |        }
  0)    0.993 us |      }
  0)   11.649 us |    }
  0)             |    do_sync_read() {
  0)             |      sock_aio_read() {
  0)             |        __sock_recvmsg() {
  0)             |          security_socket_recvmsg() {
  0)  100.319 us |            cap_socket_recvmsg();
---------------------------------------------------------

note the 8 small tweaks i did to optimize the visual real estate of 
the tracer output:

1) we done need reminders on the left side that this is about CPU 
   numbers. It will be obvious anyway if it's "all mixed up". 
   (microseconds is different - that is a unit that will be quoted and 
    it's also a number that actually matters more in the daily use of 
    such traces )

2) no need for [] on the left side - a single separator is enough. I 
   picked ')' as it looks pretty natural and unintrusive.

3) we should use the CPU number width on the left side that 
   log10(cpus_weight_nr(cpu_online_map)) tells us. So if a system has 
   just two cores, we should print single-width. If it has 16 CPUs, we 
   should print 00..01....15.

4) I left 4 decimal points for the cost. That's up to 9999.999
   microseconds, after that point we should lose precision and print: 
   99999.99, then should print up to 999999.9, and then print up to 
   99999999 microseconds. Always keep the length of the number at 8 
   characters. Above that, just let the rest shift to the right a bit. 
   (but that will be about delays of more than 100 seconds - that does 
   not really matter in practice)

5) Note, by printing the cost at fixed width, we can leave out the '+' 
   and '!' visual alerts (sorry! :-). The visible width of the numbers 
   will be enough of an attention grabber - as you can see it in the 
   mockup above already.

6) Note the vertical '|' separator. I tried it with and without, and i 
   think the code on the right side looks more structured that way. It 
   looks like a sheet of paper, and it looks tidier - so please add 
   it.

7) Note how unobscured the right side code portion looks like this 
   way. Since this is the only piece of information that is heavily 
   variable-width, we keep it at the end and dont worry about length 
   problems.

8) Please print this in the trace header:

   ---------------------------------------------------------
   CPU)     cost    |  function
   ---------------------------------------------------------

   The tabulation format and the field names makes it all more familar 
   and more friendly to people.

What do you think?

	Ingo

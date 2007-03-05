Return-Path: <linux-kernel-owner+w=401wt.eu-S933567AbXCEPzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933567AbXCEPzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933564AbXCEPzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:55:05 -0500
Received: from nz-out-0506.google.com ([64.233.162.229]:13619 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567AbXCEPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:55:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=erg5q9FYIqeNKep/pl0AzBmICkWoa0qWmIuzAt6AVSoPTsTKk117oChMkTuja3yBuCD16Vvn0ZIYoYHtFyF4YXglABwx2lrkOUKtSWtL7MpOX/NTqD+88QEMoElJUey0BMJ4HMme/yInMJ0fXq9UfyZAOEyrKs9emlhoP0sA0gY=
Message-ID: <45EC3CEC.1010405@googlemail.com>
Date: Mon, 05 Mar 2007 16:53:16 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Russell King <rmk@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: mm snapshot broken-out-2007-03-05-02-22.tar.gz uploaded
References: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
In-Reply-To: <200703051024.l25AOIF3015951@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org napisa³(a):
> The mm snapshot broken-out-2007-03-05-02-22.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-03-05-02-22.tar.gz
> 
> It contains the following patches against 2.6.21-rc2:
> 

Hmmm... lockdep bug, possible serial8250 problem and suspend to disk doesn't work.

PM: suspend-to-disk mode set to 'shutdown'
Stopping tasks ... BUG: at kernel/lockdep.c:2428 check_flags()
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c013d3bd>] check_flags+0xb7/0x187
 [<c01405f2>] lock_acquire+0x3a/0x93
 [<c033ae3f>] _spin_lock+0x35/0x42
 [<c0149b77>] refrigerator+0x14/0xb5
 [<c012eb85>] get_signal_to_deliver+0x42/0x709
 [<c0103786>] do_notify_resume+0x94/0x778
 [<c0104339>] work_notifysig+0x13/0x1a
 =======================
irq event stamp: 158057
hardirqs last  enabled at (158057): [<c0104391>] syscall_exit_work+0x11/0x26
hardirqs last disabled at (158056): [<c010427d>] syscall_exit+0x9/0x1a
softirqs last  enabled at (157962): [<c0128a03>] __do_softirq+0xc7/0xcc
softirqs last disabled at (157957): [<c0128a41>] do_softirq+0x39/0x55
BUG: workqueue leaked lock or atomic: events/0/0x00000000/8
    last function: console_callback+0x0/0xca
1 lock held by events/0/8:
 #0:  (&port_lock_key){....}, at: [<c0267c1f>] serial8250_console_write+0x55/0x13c
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0132945>] run_workqueue+0x121/0x14f
 [<c0133298>] worker_thread+0x118/0x126
 [<c01354eb>] kthread+0xb5/0xde
 [<c0104ed7>] kernel_thread_helper+0x7/0x10
 =======================
BUG: workqueue leaked lock or atomic: events/0/0x00000000/8
    last function: console_callback+0x0/0xca
1 lock held by events/0/8:
 #0:  (&port_lock_key){....}, at: [<c0267c1f>] serial8250_console_write+0x55/0x13c
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0132945>] run_workqueue+0x121/0x14f
 [<c0133298>] worker_thread+0x118/0x126
 [<c01354eb>] kthread+0xb5/0xde
 [<c0104ed7>] kernel_thread_helper+0x7/0x10
 =======================
done.
Shrinking memory...  <3>BUG: workqueue leaked lock or atomic: events/0/0x00000000/8
    last function: cache_reap+0x0/0x100
1 lock held by events/0/8:
 #0:  (&port_lock_key){....}, at: [<c0267c1f>] serial8250_console_write+0x55/0x13c
 [<c0105256>] show_trace_log_lvl+0x1a/0x2f
 [<c010597b>] show_trace+0x12/0x14
 [<c0105a3d>] dump_stack+0x16/0x18
 [<c0132945>] run_workqueue+0x121/0x14f
 [<c0133298>] worker_thread+0x118/0x126
 [<c01354eb>] kthread+0xb5/0xde
 [<c0104ed7>] kernel_thread_helper+0x7/0x10
 =======================
-\|/-\done (76069 pages freed)
Freed 304276 kbytes in 1.04 seconds (292.57 MB/s)
Suspending console(s)

l *0xc0267c1f
0xc0267c1f is in serial8250_console_write (drivers/serial/8250.c:2469).
2464                    /* serial8250_handle_port() already took the lock */
2465                    locked = 0;
2466            } else if (oops_in_progress) {
2467                    locked = spin_trylock(&up->port.lock);
2468            } else
2469                    spin_lock(&up->port.lock);
2470
2471            /*
2472             *      First save the IER then disable the interrupts
2473             */

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-05-02-22/mm-config

serial console log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-03-05-02-22/mm_snaps.txt

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752389AbXDDWKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbXDDWKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbXDDWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:10:32 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58002 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbXDDWKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:10:31 -0400
Date: Wed, 4 Apr 2007 15:10:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>
Subject: Re: 2.6.21-rc5-mm4
Message-Id: <20070404151027.29dfec58.akpm@linux-foundation.org>
In-Reply-To: <1175723795.4014.6.camel@daplas>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
	<1175723795.4014.6.camel@daplas>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 05:56:35 +0800
"Antonino A. Daplas" <adaplas@gmail.com> wrote:

> On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> > 
> > - The oops in git-net.patch has been fixed, so that tree has been restored. 
> >   It is huge.
> > 
> > - Added the device-mapper development tree to the -mm lineup (Alasdair
> >   Kergon).  It is a quilt tree, living at
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> > 
> > - Added davidel's signalfd stuff.
> > 
> > 
> > 
> 
> I'm getting a kernel panic intermittently, approximately 50% of boots.
> The tracing is not always the same, but it always dies on an
> atomic_bitop operation.  Here are two hand-copied tracings (for the life
> of me, I can't make netconsole work).
> 
> 
> /---------------------------First Tracing----------------------/
> Oops: 0000 [#1]
> last sysfs file: class/firmware/microcode
> Modules linked in: ...
> ....
> ...
> CPU: 0
> EIP: ...
> EFLAGS:...
> EIP is at find_next_zero_bit
> ...
> ...
> ...
> Process set_disk_settin
> Call Trace:
> show_trace_log
> show_stack_log
> show_register
> die
> do_page_fault
> error_code
> recalc_task_prio
> activate_task
> try_to_wake_up
> deault_wake_function
> __wake_up_common
> __wake_up
> sock_def_readable
> soc_queue_rev_skb
> udp_queue_rcv_skb
> __udp4_libr_rcv
> udp_rcv
> ip_local_delivery
> ip_rcv
> netif_receive_skb
> rtl8139_poll
> net_rx_action
> __do_soft_irq
> do_softirq
> irq_exit
> do_IRQ
> common_interrupt

Thanks - that'll be the CPU scheduler changes.

Con has produced a patch or two which might address this but afaik we don't
yet have a definitive fix?

I believe that reverting
sched-implement-staircase-deadline-cpu-scheduler-staircase-improvements.patch
will prevent it.


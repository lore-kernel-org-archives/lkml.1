Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbXDDV4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbXDDV4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXDDV4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:56:44 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:47574 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbXDDV4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DXFt27/cgQxMhF0XD8qqnuCPfmc2jLi7BzBw7GhEq9rObzrl6ieSQcMtVnyIcovPHGTXeKDNuk4m7Ucm111R+sXYJD6NcR5ONb2sz7WKIQ2ZqSzJAt69vC2HowPgJ39YKOn25Bsbk9UBdHQv0q7yFRRzPteHJg2K7XzfB5yKaZQ=
Subject: Re: 2.6.21-rc5-mm4
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 05:56:35 +0800
Message-Id: <1175723795.4014.6.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-02 at 22:47 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/
> 
> - The oops in git-net.patch has been fixed, so that tree has been restored. 
>   It is huge.
> 
> - Added the device-mapper development tree to the -mm lineup (Alasdair
>   Kergon).  It is a quilt tree, living at
>   ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/.
> 
> - Added davidel's signalfd stuff.
> 
> 
> 

I'm getting a kernel panic intermittently, approximately 50% of boots.
The tracing is not always the same, but it always dies on an
atomic_bitop operation.  Here are two hand-copied tracings (for the life
of me, I can't make netconsole work).


/---------------------------First Tracing----------------------/
Oops: 0000 [#1]
last sysfs file: class/firmware/microcode
Modules linked in: ...
....
...
CPU: 0
EIP: ...
EFLAGS:...
EIP is at find_next_zero_bit
...
...
...
Process set_disk_settin
Call Trace:
show_trace_log
show_stack_log
show_register
die
do_page_fault
error_code
recalc_task_prio
activate_task
try_to_wake_up
deault_wake_function
__wake_up_common
__wake_up
sock_def_readable
soc_queue_rev_skb
udp_queue_rcv_skb
__udp4_libr_rcv
udp_rcv
ip_local_delivery
ip_rcv
netif_receive_skb
rtl8139_poll
net_rx_action
__do_soft_irq
do_softirq
irq_exit
do_IRQ
common_interrupt

/---------------------- Second Tracing --------------------------/
CPU: 0
EIP: ...
EFLAGS:...
EIP is at find_next_zero_bit
...
...
...
Process sshd
Call Trace:
show_trace_log
show_stack_log
show_register
die
do_page_fault
error_code
recalc_task_prio
enqueue_task
activate_task
try_to_wake_up
wake_up_state
signal_wake_up
__group_complete_signal
__group_send_signal
group_send_sig_info
send_group_sig_info
it_real_fn
run_hrtimer_softirq
__do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
error_code

EIP: [<c01bfa1c>. find_next_zero_bit+...

Tony

PS: I might try use a serial console and bisection, but this might take
me a few days.


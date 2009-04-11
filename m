Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZDTNCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZDTNCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 09:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbZDTNCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 09:02:38 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39904 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340AbZDTNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 09:02:37 -0400
Subject: Re: [2.6.29-git12] BUG: scheduling while atomic:
 swapper/0/0x10000100
From: Marcel Holtmann <marcel@holtmann.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <a8e1da0904180604k8108bc5hf95705c42d80fcf9@mail.gmail.com>
References: <8db1092f0904070037q426fd8dcx4aa48c70e40b5d6c@mail.gmail.com>
	 <20090409212028.7b2aa88c.akpm@linux-foundation.org>
	 <8db1092f0904100340g7b7eb310y805e8680a32e3ac8@mail.gmail.com>
	 <alpine.LFD.2.00.0904101329170.21577@localhost.localdomain>
	 <8db1092f0904100747w297a0daas9ebd05486d06e706@mail.gmail.com>
	 <alpine.LFD.2.00.0904101819070.21577@localhost.localdomain>
	 <8db1092f0904100952x64048907gea6bbaf25488de26@mail.gmail.com>
	 <alpine.LFD.2.00.0904101854250.21577@localhost.localdomain>
	 <8db1092f0904101057x56000b73w9de3227b2a3a9abb@mail.gmail.com>
	 <alpine.LFD.2.00.0904102019220.21577@localhost.localdomain>
	 <a8e1da0904180604k8108bc5hf95705c42d80fcf9@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 21:52:44 +0200
Message-Id: <1239479565.8206.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> > On Fri, 10 Apr 2009, Maciej Rutecki wrote:
> >> 2009/4/10 Thomas Gleixner <tglx@linutronix.de>:
> >>
> >> [...]
> >> > Please upload trace.bz2 file to some place.
> >>
> >> http://unixy.pl/maciek/download/kernel/2.6.30-rc1-git3/laptop/trace-2.6.30-rc1-git3.bz2
> >
> > Ok. That gives us the necessary information:
> >
> >  <idle>-0       1d... 76597263us : do_softirq <-irq_exit
> >  <idle>-0       1d... 76597263us : __do_softirq <-do_softirq
> >  <idle>-0       1..s. 76597264us : tasklet_action <-__do_softirq
> >  <idle>-0       1..s. 76597265us : hci_rx_task <-tasklet_action
> >  <idle>-0       1..s. 76597266us : _read_lock <-hci_rx_task
> >  <idle>-0       1..s. 76597267us : skb_dequeue <-hci_rx_task
> >  <idle>-0       1..s. 76597268us : _spin_lock_irqsave <-skb_dequeue
> >  <idle>-0       1d.s. 76597269us : _spin_unlock_irqrestore <-skb_dequeue
> >  <idle>-0       1..s. 76597270us : hci_send_to_sock <-hci_rx_task
> >  <idle>-0       1..s. 76597270us+: _read_lock <-hci_send_to_sock
> >  <idle>-0       1..s. 76597272us : skb_clone <-hci_send_to_sock
> >  <idle>-0       1..s. 76597273us : kmem_cache_alloc <-skb_clone
> >  <idle>-0       1..s. 76597274us : __skb_clone <-skb_clone
> >  <idle>-0       1..s. 76597275us : __copy_skb_header <-__skb_clone
> >  <idle>-0       1..s. 76597276us : skb_push <-hci_send_to_sock
> >  <idle>-0       1..s. 76597277us : sock_queue_rcv_skb <-hci_send_to_sock
> >  <idle>-0       1..s. 76597278us : sk_filter <-sock_queue_rcv_skb
> >  <idle>-0       1..s. 76597279us : security_sock_rcv_skb <-sk_filter
> >  <idle>-0       1..s. 76597280us : cap_socket_sock_rcv_skb <-security_sock_rcv_skb
> >  <idle>-0       1..s. 76597280us : local_bh_disable <-sk_filter
> >  <idle>-0       1..s. 76597281us : local_bh_enable <-sk_filter
> >  <idle>-0       1..s. 76597282us : skb_queue_tail <-sock_queue_rcv_skb
> >  <idle>-0       1..s. 76597283us : _spin_lock_irqsave <-skb_queue_tail
> >  <idle>-0       1d.s. 76597284us : _spin_unlock_irqrestore <-skb_queue_tail
> >  <idle>-0       1..s. 76597285us : sock_def_readable <-sock_queue_rcv_skb
> >  <idle>-0       1..s. 76597286us : _read_lock <-sock_def_readable
> >  <idle>-0       1..s. 76597286us : __wake_up_sync_key <-sock_def_readable
> >  <idle>-0       1..s. 76597287us : _spin_lock_irqsave <-__wake_up_sync_key
> >  <idle>-0       1d.s. 76597288us : __wake_up_common <-__wake_up_sync_key
> >  <idle>-0       1d.s. 76597289us : pollwake <-__wake_up_common
> >  <idle>-0       1d.s. 76597290us : default_wake_function <-pollwake
> >  <idle>-0       1d.s. 76597290us : try_to_wake_up <-default_wake_function
> >  <idle>-0       1d.s. 76597292us : update_shares <-try_to_wake_up
> >  <idle>-0       1d.s. 76597293us : walk_tg_tree <-update_shares
> >  <idle>-0       1d.s. 76597294us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597294us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597295us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597297us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597297us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597298us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597299us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597300us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597301us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597302us : tg_nop <-walk_tg_tree
> >  <idle>-0       1d.s. 76597303us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597304us : tg_shares_up <-walk_tg_tree
> >  <idle>-0       1d.s. 76597305us+: task_rq_lock <-try_to_wake_up
> >  <idle>-0       1d.s. 76597314us : _spin_lock <-task_rq_lock
> >  <idle>-0       1d.s. 76597315us : select_task_rq_fair <-try_to_wake_up
> >  <idle>-0       1d.s. 76597316us : activate_task <-try_to_wake_up
> >  <idle>-0       1d.s. 76597317us : enqueue_task_fair <-activate_task
> >  <idle>-0       1d.s. 76597317us : enqueue_entity <-enqueue_task_fair
> >  <idle>-0       1d.s. 76597318us : update_curr <-enqueue_entity
> >  <idle>-0       1d.s. 76597319us : place_entity <-enqueue_entity
> >  <idle>-0       1d.s. 76597320us : enqueue_entity <-enqueue_task_fair
> >  <idle>-0       1d.s. 76597321us : update_curr <-enqueue_entity
> >  <idle>-0       1d.s. 76597321us : place_entity <-enqueue_entity
> >  <idle>-0       1d.s. 76597322us : check_preempt_curr_idle <-try_to_wake_up
> >  <idle>-0       1d.s. 76597323us : resched_task <-check_preempt_curr_idle
> >  <idle>-0       1dNs. 76597324us : _spin_unlock_irqrestore <-try_to_wake_up
> >  <idle>-0       1dNs. 76597325us+: _spin_unlock_irqrestore <-__wake_up_sync_key
> >  <idle>-0       1.Ns. 76597326us : hci_event_packet <-hci_rx_task
> >  <idle>-0       1.Ns. 76597327us : skb_pull <-hci_event_packet
> >  <idle>-0       1.Ns. 76597328us : _spin_lock <-hci_event_packet
> >  <idle>-0       1.Ns. 76597330us : del_timer <-hci_event_packet
> >  <idle>-0       1.Ns. 76597331us : hci_conn_add_sysfs <-hci_event_packet
> >  <idle>-0       1.Ns. 76597332us+: dev_set_name <-hci_conn_add_sysfs
> 
> Marcel, this is caused by hci conn id changes, originally the conn id
> is like "acl:xx:xx:xx:xx:xx:xx", then it was changed to
> "hdev_name:connection_handle", yes use the handle looks better, but it
> need to be done in the event handling function.
> 
> What do you think about change back to original way plus hdev_name?
> like:  "hdev_name:xx:xx:xx:xx:xx:xx"

that is actually a bad idea since in theory we can have more than one
SCO connection in the end. So we should use the handle. Also with the
upcoming High Speed or Low Energy stuff we need to differentiate by the
handle since more and more connections are possible.

We should fix the real problem here and to proper reference counting for
the kobject with kref here. This code might need bigger fixing since
when it was creating for 2.4, the driver model was not present.

Feel free to propose something. I am open for ideas.

Regards

Marcel



Return-Path: <linux-kernel-owner+w=401wt.eu-S1762333AbXKQSAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333AbXKQSAO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 13:00:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbXKQR76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:59:58 -0500
Received: from homer.mvista.com ([63.81.120.158]:60426 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755265AbXKQR75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:59:57 -0500
Subject: Re: [BUG on PREEMPT_RT, 2.6.23.1-rt5] in rt-mutex code and signals
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Remy Bohmer <linux@bohmer.net>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20071117174608.GA30641@elte.hu>
References: <3efb10970711160751l279fe99dl9f3a130a4373a449@mail.gmail.com>
	 <Pine.LNX.4.58.0711161516580.25989@gandalf.stny.rr.com>
	 <3efb10970711161502m6216bf5rc19a34184b4f3a2b@mail.gmail.com>
	 <Pine.LNX.4.58.0711161830570.28002@gandalf.stny.rr.com>
	 <3efb10970711170344n670d8b69w6679d494922c5bb@mail.gmail.com>
	 <1195316550.25393.21.camel@imap.mvista.com>
	 <3efb10970711170909n3acca605j70525e36faf8da7f@mail.gmail.com>
	 <1195320569.25393.38.camel@imap.mvista.com>
	 <20071117174608.GA30641@elte.hu>
Content-Type: text/plain
Date: Sat, 17 Nov 2007 09:55:40 -0800
Message-Id: <1195322141.25393.41.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-11-17 at 18:46 +0100, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > Actually, IMO, compat_semaphores behave like semaphores should 
> > > behave, and thus the same as they behave on a non-RT kernel, and at 
> > > the locations where the semaphores are now misused as mutexes on RT, 
> > > we should replace them by differently-named-mutex-type-semaphores, 
> > > or better: real-RT-mutexes..
> > 
> > The vast majority of semaphore are actually binary semaphores in the 
> > Linux kernel .. So it's easier to mass convert semaphores to mutexes, 
> > then address the ones that don't conform.. Usually they are converted 
> > to the complete API in mainline..
> 
> right now there are 3992 mutex_lock() critical sections in the kernel 
> and only 351 down() based critical sections are left.
> 
> fixing the top 20:
> 
>       4 &vuart_bus_priv.probe_mutex
>       5 &connections_lock
>       5 &irq_ptr->setting_up_sema
>       5 &kbd->sem
>       5 &pnp_res_mutex
>       5 &port->port_lock
>       5 &tq_init_sem
>       6 &adb_handler_sem
>       6 &dev->parent->sem
>       6 &driver_lock
>       6 &ha->vport_sem
>       7 &big_buffer_sem
>       8 &dir_f->sem
>       9 &c->alloc_sem
>      11 &dev->sem
>      11 &usbvision->lock
>      12 &c->erase_free_sem
>      15 &u132->scheduler_lock
>      16 &zfcp_data.config_sema
>      17 &f->sem
> 
> would remove 164 of them, so it would convert half of the remaining 
> semaphore use in the kernel. So the job is almost finished - would 
> anyone like to go for the final grand feat: complete removal of 
> semaphores from the kernel? :-)

Sure, you want to split the list?

Daniel


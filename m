Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYCUDHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYCUDHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 23:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYCUDHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 23:07:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4851 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651AbYCUDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 23:07:17 -0400
Date: Thu, 20 Mar 2008 23:07:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Michael Buesch <mb@bu3sch.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       <netdev@vger.kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, <linux-usb@vger.kernel.org>,
       <linux-wireless@vger.kernel.org>, <video4linux-list@redhat.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, <lm-sensors@lm-sensors.org>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
In-Reply-To: <20080320192719.6a32386e.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0803202301140.16520-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008, Andrew Morton wrote:

> > > > Now, it happens that in_atomic() returns true on non-preemtible kernels
> > > > when running in interrupt or softirq context.  But if the above code really
> > > > is using in_atomic() to detect am-i-called-from-interrupt and NOT
> > > > am-i-called-from-inside-spinlock, they should be using in_irq(),
> > > > in_softirq() or in_interrupt().
> > > 
> > > Presumably most of these places are actually trying to detect 
> > > am-i-allowed-to-sleep.  Isn't that what in_atomic() is supposed to do?  
> > 
> > No, I think there is no such check in the kernel. Most likely for performance
> > reasons, as it would require a global flag that is set on each spinlock.
> 
> Yup.  non-preemptible kernels avoid the inc/dec of
> current_thread_info->preempt_count on spin_lock/spin_unlock

So then what's the point of having in_atomic() at all?  Is it nothing 
more than a shorthand form of (in_irq() | in_softirq() | 
in_interrupt())?

In short, you are saying that there is _no_ reliable way to determine
am-i-called-from-inside-spinlock.  Well, why isn't there?  Would it be 
so terrible if non-preemptible kernels did adjust preempt_count on 
spin_lock/unlock?

Alan Stern


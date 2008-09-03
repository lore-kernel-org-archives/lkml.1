Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbYICRyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbYICRyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759496AbYICRyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:54:21 -0400
Received: from inhex.net ([193.33.178.145]:43265 "EHLO inhex.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759494AbYICRyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:54:20 -0400
Date: Wed, 3 Sep 2008 20:54:07 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       herton@mandriva.com.br,
       Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27-rc5 doesn't boot on a Pavilion laptop
Message-ID: <20080903175407.GA27480@laptop.local>
References: <20080902163532.436f8fbd@doriath.conectiva> <alpine.LFD.1.10.0809022208320.3243@apollo.tec.linutronix.de> <20080902175544.131bc54e@doriath.conectiva> <alpine.LFD.1.10.0809031202290.3243@apollo.tec.linutronix.de> <20080903104132.7a736282@doriath.conectiva> <alpine.LFD.1.10.0809031635260.3243@apollo.tec.linutronix.de> <alpine.LFD.1.10.0809031713040.3243@apollo.tec.linutronix.de> <20080903164415.GA24442@laptop.local> <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809031857020.3243@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 07:05:39PM +0200, Thomas Gleixner wrote:
> Yeah, noticed already. Sorry.
> 
> Find a debug patch below, which looks at the two functions which might
> loop forver under certain conditions. Does one of the checks hit ?

This one happens for me
 
> +			if (!once) {
> +				printk(KERN_WARNING
> +				       "tick_broadcast_set_event is "
> +				       "stuck %llx %llx\n",
> +				       now.tv64, expires.tv64);
> +				WARN_ON(1);
> +			}
 
Actually kernel continued to boot, however it panics just before (or maybe
after) mounting rootfs... I've booted it with boot_delay to take photos.

Here is panic stacktrace:

warn_on_slowpath
stop_this_cpu
printk
show_trace
stop_this_cpu
print_oops_end_marker
clocksource_get_next
getnstimeofday
send_IPI_mask_bitmask
tick_do_broadcast
tick_handle_oneshot_broadcast
timer_interrupt
handle_IRQ_event
handle_edge_irq
do_IRQ
....

Here are screenshots:
http://inhex.net/dion/lkml/tick_boradcast_stuck.jpg -- stacktrace from
your patch
http://inhex.net/dion/lkml/panic_on_rootfs_mount.jpg -- final kernel panic

I'm using linux-2.6-x86.git as suggested by Glauber

-- 
WBR, Dmitry

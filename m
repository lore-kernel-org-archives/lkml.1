Return-Path: <linux-kernel-owner+w=401wt.eu-S933257AbXF2MvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbXF2MvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 08:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXF2MvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 08:51:18 -0400
Received: from mathups.math.u-psud.fr ([129.175.52.4]:35281 "EHLO
	matups.math.u-psud.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752825AbXF2MvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 08:51:17 -0400
X-Greylist: delayed 3757 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2007 08:51:17 EDT
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Date: Fri, 29 Jun 2007 13:48:19 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
References: <20070622040014.234651401@goodmis.org> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru>
In-Reply-To: <20070629113423.GA9042@ms2.inr.ac.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706291348.21193.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > Just look at the tasklet_disable() logic.
> 
> Do not count this.
> 
> Done this way because nobody needed that thing, except for _one_ place
> in keyboard/console driver, which was very difficult to fix that time,
> when vt code was utterly messy and not smp safe at all.
> 
> start_bh_atomic() was successfully killed, but we had to preserve analogue
> of disable_bh() with the same semantics for some time.
> It is deliberately implemented in a way, which does not impact hot paths
> and is easy to remove.
> 
> It is sad that some usb drivers started to use this creepy and
> useless thing.

the usbatm USB driver uses it in the methods for opening and closing a new network
connection, and on device disconnect.  Yes, tasklet_disable could be eliminated by
adding a spinlock.  However this would mean taking the lock every time a packet is
received or transmitted.  As it is, typically open occurs once, when the computer
boots, and close and disconnect also occur once each, when the computer shuts down.
I felt that three calls to tasklet_disable were better than a gazillion calls to
spin_(un)lock.  Please feel free to educate me :)

Ciao,

Duncan.

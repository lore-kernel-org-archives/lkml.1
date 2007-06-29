Return-Path: <linux-kernel-owner+w=401wt.eu-S933658AbXF2QW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933658AbXF2QW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765749AbXF2QWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:22:18 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:43285 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1763426AbXF2QWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:22:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=VZJmF0UIcfATPEkPmY1EDGsWQK9RBJtE9eBwSHpQd6aQ7jnW67tSEmUtkccNKdp4n8Jy2cOub2wxNFqxJ0nImrttJsgxEscLjNym6SQTLcllSaRSDZa9Nzp7qTMp1o4L7XKFH3k9kghQUkkIXh2+jMfRfjVrEqdeu2oChItAWdc=;
Date: Fri, 29 Jun 2007 20:21:44 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070629162144.GA17709@ms2.inr.ac.ru>
References: <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org> <20070622204058.GA11777@elte.hu> <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org> <20070622215953.GA22917@elte.hu> <46834BB8.1020007@garzik.org> <20070628092340.GB23566@elte.hu> <20070628143850.GA11780@ms2.inr.ac.ru> <20070628160001.GA15495@elte.hu> <20070629113423.GA9042@ms2.inr.ac.ru> <20070629155116.GA422@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070629155116.GA422@tv-sign.ru>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> If I understand correctly, this is because tasklet_head.list is protected
> by local_irq_save(), and t could be scheduled on another CPU, so we just
> can't steal it, yes?

Yes. All that code is written to avoid synchronization as much as possible.


> If we use worqueues, we can change the semantics of tasklet_kill() so
> that it really cancels an already scheduled tasklet.
> 
> The question is: would it be the wrong/good change?

If it does not add another usec to tasklet_schedule(), it would be good.

Alexey

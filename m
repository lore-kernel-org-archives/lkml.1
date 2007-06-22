Return-Path: <linux-kernel-owner+w=401wt.eu-S1759628AbXFVWyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759628AbXFVWyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXFVWyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:54:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46538 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751258AbXFVWyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:54:43 -0400
Date: Fri, 22 Jun 2007 23:57:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Roland Dreier <rdreier@cisco.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       john stultz <johnstul@us.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Message-ID: <20070622235703.28ded4b2@the-village.bc.nu>
In-Reply-To: <aday7ibzk3f.fsf@cisco.com>
References: <20070622040014.234651401@goodmis.org>
	<alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	<20070622204058.GA11777@elte.hu>
	<alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	<20070622215953.GA22917@elte.hu>
	<20070622220901.GA26207@elte.hu>
	<aday7ibzk3f.fsf@cisco.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As a second example, msr_seek() in arch/i386/kernel/msr.c... is the
> inode semaphore enough or not?  Who understands the implications well
> enough to say?

lseek is one of the nasty remaining cases. tty is another real horror
that needs further work but we slowly get closer - drivers/char is almost
but not entirely lock_kernel free now and several users look quite easy
to swat (everyone but tty_io.c)

Alan

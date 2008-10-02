Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbYJBAwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbYJBAwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYJBAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:52:43 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:57068 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYJBAwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:52:43 -0400
Subject: Re: [RFC patch 5/5] genirq: make irq threading robust
From: Jon Masters <jonathan@jonmasters.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <20081001223302.210089249@linutronix.de>
References: <20081001223213.078984344@linutronix.de>
	 <20081001223302.210089249@linutronix.de>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 01 Oct 2008 20:52:31 -0400
Message-Id: <1222908751.31183.79.camel@perihelion.int.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:

> To make sure that a crashed irq thread does not cause more trouble
> when the irq code tries to wake up a gone thread or the device code
> calling free_irq and trying to kthread_stop the dead thread, we plug a
> pointer to irqaction into task_struct, which is evaluated in
> do_exit(). When the thread crashes the do_exit code marks the thread
> as DIED in irqaction->flags to prevent further wakeups from the
> interrupt handler code.

> @@ -1301,6 +1301,7 @@ struct task_struct {
>  	int latency_record_count;
>  	struct latency_record latency_record[LT_SAVECOUNT];
>  #endif
> +	struct irqaction *irqaction;
>  };

Is that going to fly? For the vast majority of task_structs this is now
a wasted 4/8 bytes that won't be used.

Jon.



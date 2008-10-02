Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYJBAr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYJBAr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 20:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJBArt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 20:47:49 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:48951 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYJBArs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 20:47:48 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Oct 2008 20:47:48 EDT
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
From: Jon Masters <jonathan@jonmasters.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>, Sven Dietrich <sdietrich@suse.de>
In-Reply-To: <20081001223301.900862899@linutronix.de>
References: <20081001223213.078984344@linutronix.de>
	 <20081001223301.900862899@linutronix.de>
Content-Type: text/plain
Organization: World Organi[sz]ation of Broken Dreams
Date: Wed, 01 Oct 2008 20:47:39 -0400
Message-Id: <1222908459.31183.73.camel@perihelion.int.jonmasters.org>
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

>  struct irqaction {
> +	irq_handler_t quick_check_handler;
>  	irq_handler_t handler;

When we originally discussed this, there was an idea to modify the
request_irq API to take this handler and an IRQF_THREADED type to mark
the interrupt accordingly. I understand why it's a separate function in
this implementation for ease of migration, but what do you think should
happen in the end? Also, I suggest calling this something like
"quiesce_device" because the quickcheck also needs to do that.

We probably need some documentation eventually so people realize what
this "quickcheck" handler is for and what it's not for - under no
circumstances should anything more than the bare minimum be done.
Otherwise it breaks the benefit of deferred threaded handling. It's hard
to enforce that - but this is *not* a return of top/bottom half handling
where you can do whatever crap you like in the quickcheck bit.

Jon.



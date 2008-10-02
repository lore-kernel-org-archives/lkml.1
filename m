Return-Path: <linux-kernel-owner+w=401wt.eu-S1754702AbYJBOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbYJBOqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 10:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYJBOqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 10:46:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33370 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYJBOqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 10:46:11 -0400
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt handlers
From: Andi Kleen <andi@firstfloor.org>
References: <20081001223213.078984344@linutronix.de>
Date: Thu, 02 Oct 2008 16:46:09 +0200
In-Reply-To: <20081001223213.078984344@linutronix.de> (Thomas Gleixner's message of "Wed, 01 Oct 2008 23:02:08 -0000")
Message-ID: <873ajfoy1a.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> writes:
>
>  - move long running handlers out of the hard interrupt context

I'm not sure I'm really looking forward to this brave new world
of very long running interrupt handlers. e.g. what do you
do for example when some handler blocks for a very long time?

>  - improved debugability of the kernel: faulty handlers do not take
>    down the system.

I had an old patch to handle this without threaded interrupts. 

What normally happens is when a interrupt oopses it tries to kill the
idle process which panics.  My fix was to just restart another idle
process instead of panicing.

But back then it was rejected by Linus with the argument that
a crashing interrupt handler will typically hold some lock
and the next time the interrupt happens it will deadlock on that
lock. 

Has that changed with your threaded interrupts? 

If it has changed I suspect the restart idle change could
be made to work to be equivalent in debuggability.

> Comments, reviews, flames as usual.

To be honest my opinion is that it will encourage badly written interrupt
code longer term.

-Andi

-- 
ak@linux.intel.com

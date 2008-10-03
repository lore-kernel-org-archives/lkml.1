Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbYJCE3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbYJCE3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYJCE3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:29:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45688 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYJCE3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:29:20 -0400
Date: Fri, 3 Oct 2008 06:35:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt handlers
Message-ID: <20081003043502.GG8318@one.firstfloor.org>
References: <20081001223213.078984344@linutronix.de> <873ajfoy1a.fsf@basil.nowhere.org> <20081002213146.GA9201@kroah.com> <20081002153305.057cf6d9@infradead.org> <20081003032504.GF8318@one.firstfloor.org> <20081002204851.1836e465@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002204851.1836e465@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> while I don't disagree that oprofile will give you more detailed
> results, I think there's a HUGE difference between asking a bugreporter
> "can you paste a screen of 'top'" and "can you configure and run
> oprofile".

Perhaps the better fix would be to make oprofile easier to configure.
I never quite understood for example why it doesn't get the symbol
table simply from the kallsyms. Or simply unpacks gzip'ed vmlinux
by itself.

> CHances are good that the user already thought of top him/herself and
> just reports "interrupt X is eating CPU" rather than "something seems
> to be eating CPU".

> 
> I'm not going argue that this alone is enough justification for
> irqthreads, but you can't deny it's an advantage.

Do we have that many cases of runaway irqs? The only common
one I can think of is ACPI, but that is a separate thread already.

Or for networking high performance goes into polling mode
and most of the work is outside hardirq so it wouldn't be visible
in the thread statistics either. But even there livelocks are not
very common.

Also that would assume that the proposed opt in irq threads are used
for all interrupts.

-Andi

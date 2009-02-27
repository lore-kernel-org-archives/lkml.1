Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbZB0FqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbZB0FqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 00:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbZB0FqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 00:46:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53805 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751997AbZB0FqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 00:46:05 -0500
Date: Thu, 26 Feb 2009 21:45:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, peterz@infradead.org, rostedt@goodmis.org,
       jonathan@jonmasters.org
Subject: Re: [patch 4/4] genirq: add support for threaded interrupt handlers
Message-Id: <20090226214514.f8a58731.akpm@linux-foundation.org>
In-Reply-To: <20090226212752.332ba546@infradead.org>
References: <20090226131336.423054348@linutronix.de>
	<20090226131719.760899560@linutronix.de>
	<20090226153216.5db66bc3.akpm@linux-foundation.org>
	<20090226212752.332ba546@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 21:27:52 -0800 Arjan van de Ven <arjan@infradead.org> wrote:

> > 
> > Bearing in mind that the driver might choose to split the IRQ handling
> > between hard-irq context fastpath and process-context slowpath (I
> > hope), and that each path might want to take the same lock.
> > 
> 
> 
> Realistically, for the "we go threaded interrupts" case (which is
> opt-in), I think the only sane option is
> * the quickhandler runs with irqs off
> * the "slow" threaded handler runs with irqs on
> And we guarantee both of these conditions from the core, to the point
> that I think we should not allow any other combination.
> 
> This also should be fine for basically all cases; the quick handler
> really needs to be quick so irq off makes sense, and the slow handler
> can, worst case, turn off interrupts by itself, but normally is
> preemptable etc etc.

I was actually kinda surprised by the patch - it needs moderate changes
to each driver.  I'd have thought that it would be possible to arrange for
_all_ drivers to have their interrupt handlers automagically called from
process context with no driver changes.

Did anyone ever try that?  I think they did...

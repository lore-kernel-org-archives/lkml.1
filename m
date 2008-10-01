Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYJAXlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYJAXlA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJAXkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:40:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46389 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbYJAXkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:40:52 -0400
Date: Wed, 1 Oct 2008 16:40:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, mingo@elte.hu, benh@kernel.crashing.org,
       rostedt@goodmis.org, jonathan@jonmasters.org, sdietrich@suse.de
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded
 interrupt handlers
Message-Id: <20081001164013.f72036c9.akpm@linux-foundation.org>
In-Reply-To: <20081001162950.61887d08@infradead.org>
References: <20081001223213.078984344@linutronix.de>
	<20081001162333.e1509240.akpm@linux-foundation.org>
	<20081001162950.61887d08@infradead.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 16:29:50 -0700
Arjan van de Ven <arjan@infradead.org> wrote:

> On Wed, 1 Oct 2008 16:23:33 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > I'm a bit surprised to see that there is no facility for per-cpu
> > interrupt threads?
> > 
> 
> per handler is the right approach (that way, if one dies, all other
> interrupts will likely keep working)
> 
> now.. normally an interrupt only goes to one cpu, so effectively it is
> per cpu already anyway

Yes, if a) the thread was asleep when it was woken up and b) if the
scheduler does the right thing and wakes the thread on the CPU which
called wake_up().

The ongoing sagas of tbench/mysql/volanomark regressions make me think
that any behaviour which we "expect" of the scheduler should be
triple-checked daily :(

> we should however make the irq threads follow the affinity masks of the
> irq... that'd be an easy add-on and probably worthwhile.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZKWMu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZKWMu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 07:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbZKWMuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 07:50:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:48719 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbZKWMuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 07:50:54 -0500
Subject: Re: [tip:perf/core] perf_events: Undo some recursion damage
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091123123935.GB4989@nowhere>
References: <20091123103819.993226816@chello.nl>
	 <tip-4ed7c92d68a5387ba5f7030dc76eab03558e27f5@git.kernel.org>
	 <20091123123935.GB4989@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 13:50:48 +0100
Message-ID: <1258980648.4531.390.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 13:39 +0100, Frederic Weisbecker wrote:
> On Mon, Nov 23, 2009 at 11:55:08AM +0000, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  4ed7c92d68a5387ba5f7030dc76eab03558e27f5
> > Gitweb:     http://git.kernel.org/tip/4ed7c92d68a5387ba5f7030dc76eab03558e27f5
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Mon, 23 Nov 2009 11:37:29 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 23 Nov 2009 11:49:57 +0100
> > 
> > perf_events: Undo some recursion damage
> > 
> > Make perf_swevent_get_recursion_context return a context number
> > and disable preemption.
> > 
> > This could be used to remove the IRQ disable from the trace bit
> > and index the per-cpu buffer with.
> 
> 
> But if I do that, it means I will lose traces once irq nest.

Ah yes, that crap :-(

Maybe its about time we extend the generic irq bits to know about nested
irqs, or firmly kill the whole notion.


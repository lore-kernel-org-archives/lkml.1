Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZGHVRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZGHVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 17:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZGHVRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 17:17:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51565 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbZGHVRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:17:03 -0400
Date: Wed, 8 Jul 2009 17:16:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] ring-buffer: make lockless
In-Reply-To: <20090708210522.GA17430@Krystal>
Message-ID: <alpine.DEB.2.00.0907081711200.22197@gandalf.stny.rr.com>
References: <20090708201312.222046866@goodmis.org> <20090708201445.696220393@goodmis.org> <20090708210522.GA17430@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 8 Jul 2009, Mathieu Desnoyers wrote:

> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > This patch converts the ring buffers into a completely lockless
> > buffer recording system. The read side still takes locks since
> > we still serialize readers. But the writers are the ones that
> > must be lockless (those can happen in NMIs).
> 
> Hi Steven,
> 
> Have you started modeling this scheme with Promela as I previously
> discussed with you ? Paul McKenney did a lot of nice papers on the
> topic, and given the complexity level of this lockless buffering
> algorithm, I'd be much more comfortable if it was formally verified. The
> idea here is to make sure we don't start an endless bug-chasing hunt as
> trace buffers gets more exposure to various workloads.

I would when I get time. Too many things on my plate at the moment. But 
I do constantly run my ring-buffer-benchmark module, which highly stresses 
the buffer. I have not had to fix a bug in it for a long time, and nothing 
that needed a design change.

I'll try it out (or better yet, maybe someone else will) when I get more 
time.

-- Steve


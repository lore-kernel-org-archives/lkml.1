Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZAJCA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZAJCA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 21:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZAJCAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 21:00:50 -0500
Received: from ozlabs.org ([203.10.76.45]:48062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZAJCAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 21:00:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18791.60479.79841.734481@cargo.ozlabs.ibm.com>
Date: Sat, 10 Jan 2009 11:30:55 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/9] Performance counters for POWER
In-Reply-To: <1231507715.11687.618.camel@twins>
References: <18791.10652.298501.863657@cargo.ozlabs.ibm.com>
	<1231507715.11687.618.camel@twins>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> Hmm, the model I thought would make most sense for power and other
> machines with such heavy constraints was that you'd compose a register
> set when you create groups, and then when you RR the groups, you just
> program the pre-computed sets.

Groups are user-created entities, and in practice (at least so far)
most groups consist of just a single counter.  I don't want to build
in a limitation that you can only count one thing at a time unless you
construct a multi-counter group.  (There is no easy way to combine the
register settings for two groups, short of working out the register
settings for the combined set of events from scratch.)

It would be possible to have an entity that describes a set of groups
(i.e. the result of a scheduling decision) and precompute register
settings for that.  That's the kind of thing I was alluding to when I
talked about major changes to the generic code.  But that entity is a
distinct thing from the current notion of a "group".

> Right, esp on high context switch rates it might dominate the machine.

Currently the constraint check/alternative search seems to take a
fraction of a microsecond, so I'm hopeful it'll be OK.  We'll see.

Paul.

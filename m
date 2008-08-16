Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbYHPT4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbYHPT4n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 15:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYHPT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 15:56:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42625 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYHPT4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 15:56:33 -0400
Subject: Re: [PATCH RT RFC v4 1/8] add generalized priority-inheritance
	interface
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: mingo@elte.hu, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       David.Holmes@sun.com, jkacur@gmail.com
In-Reply-To: <20080815202823.668.26199.stgit@dev.haskins.net>
References: <20080815202408.668.23736.stgit@dev.haskins.net>
	 <20080815202823.668.26199.stgit@dev.haskins.net>
Content-Type: text/plain
Date: Sat, 16 Aug 2008 21:56:00 +0200
Message-Id: <1218916561.10880.11.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-15 at 16:28 -0400, Gregory Haskins wrote:
> The kernel currently addresses priority-inversion through priority-
> inheritence.  However, all of the priority-inheritence logic is
> integrated into the Real-Time Mutex infrastructure.  This causes a few
> problems:
> 
>  1) This tightly coupled relationship makes it difficult to extend to
>     other areas of the kernel (for instance, pi-aware wait-queues may
>     be desirable).
>  2) Enhancing the rtmutex infrastructure becomes challenging because
>     there is no seperation between the locking code, and the pi-code.
> 
> This patch aims to rectify these shortcomings by designing a stand-alone
> pi framework which can then be used to replace the rtmutex-specific
> version.  The goal of this framework is to provide similar functionality
> to the existing subsystem, but with sole focus on PI and the
> relationships between objects that can boost priority, and the objects
> that get boosted.
> 
> We introduce the concept of a "pi_source" and a "pi_sink", where, as the
> name suggests provides the basic relationship of a priority source, and
> its boosted target.  A pi_source acts as a reference to some arbitrary
> source of priority, and a pi_sink can be boosted (or deboosted) by
> a pi_source.  For more details, please read the library documentation.
> 
> There are currently no users of this inteface.

You should have started out by discussing your design - the document
just rambles a bit about some implementation details - it doesn't talk
about how it maps to the PI problem space.

Anyway - from what I can make of the code, you managed to convert the pi
graph walking code that used to be in rt_mutex_adjust_prio_chain() and
was iterative, into a recursive function call.

Not something you should do lightly..


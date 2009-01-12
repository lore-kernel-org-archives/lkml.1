Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZALQFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZALQFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 11:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbZALQFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 11:05:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576AbZALQFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 11:05:32 -0500
Date: Mon, 12 Jan 2009 08:04:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
In-Reply-To: <1231774622.4371.96.camel@laptop>
Message-ID: <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Peter Zijlstra wrote:
> 
> Change mutex contention behaviour such that it will sometimes busy wait on
> acquisition - moving its behaviour closer to that of spinlocks.

This version seems worse in so many ways.

You made the mutex bigger, for no obvious reason.

You made it back into the locked version.

You have unnecessary preempt_enable/preempt_disable calls in functions 
that need to be called (and are called) with preemption already disabled.

Things seem to be going backwards.

		Linus

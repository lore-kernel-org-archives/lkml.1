Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZAFVp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZAFVp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbZAFVpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:45:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:37399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZAFVpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:45:09 -0500
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
In-Reply-To: <20090106214229.GD6741@linux.vnet.ibm.com>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 22:44:35 +0100
Message-Id: <1231278275.11687.111.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 13:42 -0800, Paul E. McKenney wrote:
> Preemptable RCU needs to be faster.  Got it -- and might have a way
> to do it by eliminating the irq disabling and cutting way back on the
> number of operations that must be performed.  It would probably still
> be necessary to access the task structure.
> 
> Or is something other than the raw performance of rcu_read_lock() and
> rcu_read_unlock() at issue here?

With Linus' mutex_spin_or_schedule() function the whole - keeping
owner's task_struct alive issue goes away,.. now if only the thing would
boot...

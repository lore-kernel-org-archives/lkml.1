Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbYFYTJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbYFYTJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758729AbYFYTJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:09:25 -0400
Received: from www.tglx.de ([62.245.132.106]:54651 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637AbYFYTJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:09:24 -0400
Date: Wed, 25 Jun 2008 21:06:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] futex: fix miss ordered wakeups
In-Reply-To: <1214412463.21035.57.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0806252053400.3297@apollo.tec.linutronix.de>
References: <20080624232018.817822790@mvista.com>  <20080624232020.505470899@mvista.com>  <1214371767.16881.5.camel@twins>  <1214404611.21035.20.camel@localhost.localdomain>  <1214406451.24356.13.camel@lappy.programming.kicks-ass.net> 
 <1214407507.21035.32.camel@localhost.localdomain>  <1214410654.24356.22.camel@lappy.programming.kicks-ass.net> <1214412463.21035.57.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2008, Daniel Walker wrote:
> On Wed, 2008-06-25 at 18:17 +0200, Peter Zijlstra wrote:
> > Also, the main point was about mixing user and kernel space state, you
> > still do so by including the futex waiter in the same union. That's a
> > fundamental fugly - no matter if you can make it work.
> 
> I don't think it's ugly at all, but I'm open to suggestion for alternate
> methods of implementing it .. I don't need to unify the blocked_on
> structures, but it does allow for some nice things like reducing the
> size of the task struct, and potentially later doing PI across different
> API's.

Just get it. Mixing concurrency controls and futex waiters is
fundamentally wrong. A task can be blocked on exactly one concurrency
control, but it can be on a futex waiter _AND_ then block on a
concurrency control. 

Unifying the mutex and the rtmutex blocked_on is semantically correct
and is a worthwhile thing to do, but adding the futex waiter to it is
simply a semantical brain fart which can not be excused by reducing
the size of task struct.

No thanks,

	tglx

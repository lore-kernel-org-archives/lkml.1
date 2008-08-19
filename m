Return-Path: <linux-kernel-owner+w=401wt.eu-S1755150AbYHSOHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150AbYHSOHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYHSOHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:07:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:54435 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYHSOHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:07:43 -0400
Subject: Re: [PATCH RT 2/2] ftrace: fix elevated preempt_count in
	wakeup-tracer
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0808190942070.23667@gandalf.stny.rr.com>
References: <20080819091817.21725.81831.stgit@dev.haskins.net>
	 <20080819091923.21725.41087.stgit@dev.haskins.net>
	 <1219151556.10800.383.camel@twins> <48AAC8E7.1030506@novell.com>
	 <alpine.DEB.1.10.0808190942070.23667@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 16:07:48 +0200
Message-Id: <1219154869.10800.386.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-19 at 09:45 -0400, Steven Rostedt wrote:
> On Tue, 19 Aug 2008, Gregory Haskins wrote:
> > > 
> > > Is preempt_count > 1 at all times here?
> > > 
> > > If not, it might drop to 0 and any interrupt might cause preemption -
> > > and its not obvious to me that that is actually correct.
> > >   
> > According to Steve, we are already in an interrupt-disabled section here, but
> > I will defer to him.  He suggested I try this over an IRC conversation when I
> > noticed a strange wakeup trace, and it seems to have solved the problem.
> 
> Exactly.
> 
> Peter,
> 
> We disable preemption, do a per_cpu check, if we are not nested we grab 
> disable interrupts and grab the spin lock.
> 
> The issue that Gregory brought up, was that the tracer would always show 
> that preemption was disabled, when it really wasn't. It was recording the
> preempt disabled that the trace function itself made. The answer was 
> simply to do as Greg did, and enable preemption (but interrupts are 
> still disabled), call the function tracer, then disable preemption again 
> (to match the outside preemption enabling.

Ok good. 


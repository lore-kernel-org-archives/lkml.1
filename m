Return-Path: <linux-kernel-owner+w=401wt.eu-S1761344AbZCTTf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344AbZCTTf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZCTTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:35:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46355 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZCTTfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:35:19 -0400
Subject: cpu hotplug and lockdep (was: Re: [tip:core/ipi] generic-ipi:
 eliminate spurious pointlessWARN_ON()s)
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Beulich <jbeulich@novell.com>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <1237575134.4667.5.camel@laptop>
References: <49B91A7E.76E4.0078.0@novell.com>
	 <tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	 <1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	 <1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	 <m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	 <m14oxo8qis.fsf@fess.ebiederm.org>  <20090320182404.GA31629@elte.hu>
	 <1237575134.4667.5.camel@laptop>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 20:34:48 +0100
Message-Id: <1237577688.4667.68.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 19:52 +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-20 at 19:24 +0100, Ingo Molnar wrote:
> > * Eric W. Biederman <ebiederm@xmission.com> wrote:
> > 
> > > Now back to my regularly scheduled hotunplug challenges starting 
> > > with getting lockdep to warn about the dead locks.
> 
> http://programming.kicks-ass.net/kernel-patches/cpu-hotplug/
> 
> The recursive read code needs more work.. 

You'll find some network softirq inversion 'fixes' there, but those are
false, (soft)irq recursion isn't a problem for recursive read locks, but
of course only as long as writes (and thereby all nesting exclusive
locks) are irq-safe so as to not create write in read deadlocks.

Just never gotten around to actually implementing that, ego also offered
to look at that at one point, but I guess he didn't get around to it
either ;-)


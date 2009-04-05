Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZDERjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZDERjs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 13:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbZDERjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 13:39:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40931 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZDERji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 13:39:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] PM: Warn if interrupts are enabled during suspend-resume of sysdevs
Date: Sun, 5 Apr 2009 19:39:29 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Len Brown <lenb@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200904042323.19866.rjw@sisk.pl> <20090405135108.GC25250@elte.hu>
In-Reply-To: <20090405135108.GC25250@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904051939.30170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Sysdev have to be suspended and resumed with interrupts disabled 
> > and things usually break in a way that's difficult to debug if one 
> > of sysdev drivers enables interrupts by mistake during suspend or 
> > resume.  Add extra checks that will generate warnings in such 
> > cases.
> 
> no objections - but obviously the real solution would be to finish 
> PeterZ's "detect assymetric kernel functions" patch:
> 
> That patch (Peter posted an initial version of it already on lkml) 
> works the following way:
> 
> the ftrace function-graph-tracer plugin is utilized to instrument 
> every function call in the kernel. That is extended with the 
> following check: every function except __lockfunc and __sched 
> functions must be 'balanced' - i.e. they must enter and exit with 
> the same IRQ flags, preempt count and lock depth counter.

Nothing wrong with that, but I'd also like to have checks that don't depend on
ftrace. :-)

Thanks,
Rafael

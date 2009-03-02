Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZCBVhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZCBVhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZCBVh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:37:26 -0500
Received: from n63.bullet.mail.sp1.yahoo.com ([98.136.44.33]:33482 "HELO
	n63.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752922AbZCBVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:37:25 -0500
X-Yahoo-Newman-Id: 29016.25359.bm@omp413.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RzBUHxo/F5ZliErXHR+Juw2HG/rglvsz+36zXJjj0jc8CxPa9X6Q2pxjsC67kljkEnfus+2ujEYcKFPGsu78RdbWxO4nfG81EA9JMo6SfZ79PwTElYUyetIJjWMlk2aitdCB4Azt63g3BuNZm7I/BpK2rEoyrV/YFYtjHuKGFzs=  ;
X-YMail-OSG: i2dIMXYVM1leMOrnRvg03TRGiy73FEjpWom.disTK1YJqCPorvMMAVahF_s.bgkUzdqdZ9Hos5JZHkY6LqeqTxKLw.HLbgR9hyv1o2QHb1wjudRHzfg19g6VyyjcV2dyAw1PVx9VguzZHpJPNCFPlBcC
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Mon, 2 Mar 2009 13:37:20 -0800
User-Agent: KMail/1.9.10
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200903021304.56881.david-b@pacbell.net> <1236028617.18955.14.camel@twins>
In-Reply-To: <1236028617.18955.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903021337.20887.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 March 2009, Peter Zijlstra wrote:
> On Mon, 2009-03-02 at 13:04 -0800, David Brownell wrote:
> > On Monday 02 March 2009, Peter Zijlstra wrote:
> > > IRQF_DISABLED is bonkers,
> > 
> > Hmm, after all the work that's been done to get Linux
> > to the point where *most* drivers run without IRQs

Typo:  "drivers run *with* IRQs enabled".  Not "without".
Should be evident from context.


> > enabled ... that sentiment surprises me.
> > 
> > And I suspect it would surprise most driver developers.
> 
> How so?, its the natural extension of that work.

Not the work to shrink the amount of time IRQ latencies
by shrinking the amount of time IRQs are disabled by
IRQ handlers.


> > > we should simply always disable interrupts for 
> > > interrupt handlers.
> > 
> > That would be why you have refused to fix the bug
> > in lockdep, whereby it forcibly enables that flag?
> > 
> > I've been wondering for some months now why you've
> > left that bug unfixed.
> 
> Because running irq handlers with irqs enabled it plain silly.

Not if you have hardware-prioritized IRQs, which are
fairly common in some environments ... handling an IRQ
for high priority device A needn't interfere with the
handler for lower priority device B, and the system
overall can work better.

Not if you need to shrink IRQ latencies by minimizing
irqs-off critical sections everywhere ... IRQ handlers
being common offenders for keeping IRQs off too long.

Not when IRQs can be disabled selectively around the
real critical sections ... so drivers can leave IRQs
enabled except in those brief sections.
 



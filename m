Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZBLXoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZBLXoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZBLXn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:43:58 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47434 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZBLXn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:43:58 -0500
Date: Thu, 12 Feb 2009 21:43:49 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rt/threadirqs: don't need to save irqs in
	do_hardirq()
Message-ID: <20090212234349.GE5348@ghostprotocols.net>
References: <4994ae18.1358560a.454d.403b@mx.google.com> <20090212232459.GD5348@ghostprotocols.net> <20090212232758.GA5865@nowhere> <alpine.DEB.1.10.0902121836530.15469@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902121836530.15469@gandalf.stny.rr.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 12, 2009 at 06:37:16PM -0500, Steven Rostedt escreveu:
> 
> On Fri, 13 Feb 2009, Frederic Weisbecker wrote:
> 
> > On Thu, Feb 12, 2009 at 09:24:59PM -0200, Arnaldo Carvalho de Melo wrote:
> > > Em Thu, Feb 12, 2009 at 07:27:08PM +0100, Frederic Weisbecker escreveu:
> > > > do_hardirq() has only one caller do_irqd() in a path where irq are already
> > > > disabled. So we don't need to save irqs while holding desc->lock
> > > > 
> > > > Replace spin_lock_irqsave by spin_lock.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > ---
> > > >  kernel/irq/manage.c |    4 ++--
> > > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > > > index ed7c5e3..6e9baf8 100644
> > > > --- a/kernel/irq/manage.c
> > > > +++ b/kernel/irq/manage.c
> > > > @@ -905,7 +905,7 @@ static void do_hardirq(struct irq_desc *desc)
> > > >  {
> > > >  	unsigned long flags;
> > > 
> > > Can flags be removed too?
> > 
> > 
> > Actually... I cheated.
> > Once the two patches were done, I saw the unused variable warning. So I remade the second patch
> > to remove flags but..yes it should be on the first patch, I must confess...
> 
> That's fine, I'll pull both of them in.
> 
> Thanks Frederic!

Ditto, that was just a follow up thingy, nothing against the change :-)

- Arnaldo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbZBLXh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbZBLXh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBLXhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:37:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64480 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbZBLXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:37:19 -0500
Date: Thu, 12 Feb 2009 18:37:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rt/threadirqs: don't need to save irqs in
 do_hardirq()
In-Reply-To: <20090212232758.GA5865@nowhere>
Message-ID: <alpine.DEB.1.10.0902121836530.15469@gandalf.stny.rr.com>
References: <4994ae18.1358560a.454d.403b@mx.google.com> <20090212232459.GD5348@ghostprotocols.net> <20090212232758.GA5865@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 13 Feb 2009, Frederic Weisbecker wrote:

> On Thu, Feb 12, 2009 at 09:24:59PM -0200, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Feb 12, 2009 at 07:27:08PM +0100, Frederic Weisbecker escreveu:
> > > do_hardirq() has only one caller do_irqd() in a path where irq are already
> > > disabled. So we don't need to save irqs while holding desc->lock
> > > 
> > > Replace spin_lock_irqsave by spin_lock.
> > > 
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  kernel/irq/manage.c |    4 ++--
> > >  1 files changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > > index ed7c5e3..6e9baf8 100644
> > > --- a/kernel/irq/manage.c
> > > +++ b/kernel/irq/manage.c
> > > @@ -905,7 +905,7 @@ static void do_hardirq(struct irq_desc *desc)
> > >  {
> > >  	unsigned long flags;
> > 
> > Can flags be removed too?
> 
> 
> Actually... I cheated.
> Once the two patches were done, I saw the unused variable warning. So I remade the second patch
> to remove flags but..yes it should be on the first patch, I must confess...

That's fine, I'll pull both of them in.

Thanks Frederic!

-- Steve


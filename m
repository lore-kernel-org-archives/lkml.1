Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbYGSE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbYGSE66 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYGSE6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:58:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58056 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYGSE6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:58:50 -0400
Date: Fri, 18 Jul 2008 21:58:47 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
Message-ID: <20080718215847.3db0dc9e@infradead.org>
In-Reply-To: <1216440697.3978.142.camel@localhost.localdomain>
References: <20080718151524.5ef9e29b@infradead.org>
	<20080718151608.46dc17c0@infradead.org>
	<1216430540.3978.137.camel@localhost.localdomain>
	<20080718204406.7426e8fe@infradead.org>
	<1216440697.3978.142.camel@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 21:11:37 -0700
Daniel Walker <dwalker@mvista.com> wrote:

> On Fri, 2008-07-18 at 20:44 -0700, Arjan van de Ven wrote:
> > On Fri, 18 Jul 2008 18:22:20 -0700
> > Daniel Walker <dwalker@mvista.com> wrote:
> > 
> > > On Fri, 2008-07-18 at 15:16 -0700, Arjan van de Ven wrote:
> > > > +static void __init do_initcalls(void)
> > > > +{
> > > > +       initcall_t *call;
> > > > +       static DECLARE_WORK(async_work, do_async_initcalls);
> > > > +       int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 =
> > > > after level 6a */
> > > > +
> > > > +       async_init_wq =
> > > > create_singlethread_workqueue("kasyncinit"); +
> > > 
> > > Could you spawning one thread per cpu, and queuing the work
> > > evenly?
> > 
> > not without loosing the ordering.....
> > 
> 
> I don't think there is any expectation for any given initcall to have
> a special ordering .. There is an ordering expectation for say
> initcall 6 runs before 6a , but not within the initcall ..
> 

that's not right.. device numbering very highly depends on that.
the specified ordering is makefile link order.

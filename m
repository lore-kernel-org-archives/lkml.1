Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbYGSELr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYGSELr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbYGSELk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:11:40 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:27888 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYGSELj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:11:39 -0400
Subject: Re: [patch 1/3] fastboot: Create a "asynchronous" initlevel
From: Daniel Walker <dwalker@mvista.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20080718204406.7426e8fe@infradead.org>
References: <20080718151524.5ef9e29b@infradead.org>
	 <20080718151608.46dc17c0@infradead.org>
	 <1216430540.3978.137.camel@localhost.localdomain>
	 <20080718204406.7426e8fe@infradead.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 21:11:37 -0700
Message-Id: <1216440697.3978.142.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-18 at 20:44 -0700, Arjan van de Ven wrote:
> On Fri, 18 Jul 2008 18:22:20 -0700
> Daniel Walker <dwalker@mvista.com> wrote:
> 
> > On Fri, 2008-07-18 at 15:16 -0700, Arjan van de Ven wrote:
> > > +static void __init do_initcalls(void)
> > > +{
> > > +       initcall_t *call;
> > > +       static DECLARE_WORK(async_work, do_async_initcalls);
> > > +       int phase = 0; /* 0 = levels 0 - 6, 1 = level 6a, 2 = after
> > > level 6a */
> > > +
> > > +       async_init_wq = create_singlethread_workqueue("kasyncinit");
> > > +
> > 
> > Could you spawning one thread per cpu, and queuing the work evenly?
> 
> not without loosing the ordering.....
> 

I don't think there is any expectation for any given initcall to have a
special ordering .. There is an ordering expectation for say initcall 6
runs before 6a , but not within the initcall ..

Daniel


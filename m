Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbYGSE2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbYGSE2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 00:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbYGSE2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 00:28:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:29541 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYGSE2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 00:28:10 -0400
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
Date: Fri, 18 Jul 2008 21:28:08 -0700
Message-Id: <1216441688.3978.149.camel@localhost.localdomain>
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

Your right .. You would think there wouldn't be expectations on the
ordering, but certain sub-systems do have dependencies .. I think it's
really a problem in our initcall system where I've seen lots of initcall
problems popup when drivers select "module_init()" but when the driver
is built in they loose the mandatory module load ordering (shows up in
allyesconfig). Then if the ordering gets mixed in the initcall you end
up with failures.

Daniel


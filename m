Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXISTmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXISTmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXISTmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:42:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44481 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXISTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:42:42 -0400
Date: Wed, 19 Sep 2007 21:41:10 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs
 rcu_read_lock()
Message-ID: <20070919214110.5d832f28@lappy>
In-Reply-To: <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
References: <20070919104125.286538000@chello.nl>
	<20070919105054.332308000@chello.nl>
	<d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
	<20070919163111.05c18021@twins>
	<d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
	<20070919153750.GB8666@linux.vnet.ibm.com>
	<d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
	<20070919173249.GE8666@linux.vnet.ibm.com>
	<20070919174857.GA11922@linux.vnet.ibm.com>
	<d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 14:49:56 -0400 "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> wrote:

> On 9/19/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> > PS to previous -- any problem with inserting rcu_read_lock() and
> > rcu_read_unlock() around the portion of the IRQ handler that has
> > these accesses?
> >
> 
> I guess I could but it is an extra lock that needs to be managed and
> given the fact that it is not really needed (other to make a newly
> developed tool happy) I am hestsant to do that.

As is, these sites are a bug in -rt and we'll need to fix them anyway.

As for the code you pointed me to, the i8042 driver, it seems to play
way to funny tricks for a simple 'slow' driver.

If you replace the spin_lock() + sync_sched(), with rcu_read_lock() +
rcu_call() it should work again without adding an extra lock.

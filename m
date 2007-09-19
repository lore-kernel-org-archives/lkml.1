Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbXISTte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbXISTte (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbXISTt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:49:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36124 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXISTt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TY4ep5HY7hhYjkwkrFr2Nb9qTcxItHEl0lGpT4bZK5ajVqYiGxp3/FnyzU/ZDuQXLgZLnjqQwSMqcFdlAuIPEqk0l0BuZddz8gsZcimpmPA+uurdVE56U5TFU0xm+11Q7bLviBuRIaydsjJKi0cSX9nsC0d3BJsk/pxSrj9A69s=
Message-ID: <d120d5000709191249w461967d6w8da303dc54f2dd41@mail.gmail.com>
Date: Wed, 19 Sep 2007 15:49:24 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs rcu_read_lock()
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <20070919214110.5d832f28@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070919104125.286538000@chello.nl>
	 <d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
	 <20070919163111.05c18021@twins>
	 <d120d5000709190816o2899f85fpb8ae88cbf9a18830@mail.gmail.com>
	 <20070919153750.GB8666@linux.vnet.ibm.com>
	 <d120d5000709190959p351c7ba4mdb1eeb433098e0e6@mail.gmail.com>
	 <20070919173249.GE8666@linux.vnet.ibm.com>
	 <20070919174857.GA11922@linux.vnet.ibm.com>
	 <d120d5000709191149q3d850d07nd8bf864a6e797055@mail.gmail.com>
	 <20070919214110.5d832f28@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 19 Sep 2007 14:49:56 -0400 "Dmitry Torokhov"
> <dmitry.torokhov@gmail.com> wrote:
>
> > On 9/19/07, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>
> > > PS to previous -- any problem with inserting rcu_read_lock() and
> > > rcu_read_unlock() around the portion of the IRQ handler that has
> > > these accesses?
> > >
> >
> > I guess I could but it is an extra lock that needs to be managed and
> > given the fact that it is not really needed (other to make a newly
> > developed tool happy) I am hestsant to do that.
>
> As is, these sites are a bug in -rt and we'll need to fix them anyway.
>
> As for the code you pointed me to, the i8042 driver, it seems to play
> way to funny tricks for a simple 'slow' driver.

Even "slow" driver should try not to slow down the rest of the system
if it can help it. I am sorry if the thing it does do not quite fit in
with the changes you are proposing but it does not make the exeisting
code invalid.

>
> If you replace the spin_lock() + sync_sched(), with rcu_read_lock() +
> rcu_call() it should work again without adding an extra lock.
>

Except that I need spin_lock_irq for other reasons. I could take the
same lock in write-side code and not use RCU at all but using RCU
allows opening/closing input devices without slowing down interrupt
handlers so why not use it?

-- 
Dmitry

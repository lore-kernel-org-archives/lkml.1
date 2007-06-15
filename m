Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbXFOTFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbXFOTFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 15:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbXFOTE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 15:04:58 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:11459 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600AbXFOTE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 15:04:57 -0400
Subject: Re: Using RCU with rcu_read_lock()?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <d120d5000706151200u34bd6728n7fca0983d6175f29@mail.gmail.com>
References: <d120d5000706151200u34bd6728n7fca0983d6175f29@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 21:04:19 +0200
Message-Id: <1181934259.11113.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 15:00 -0400, Dmitry Torokhov wrote:
> Hi,
> 
> I have a piece of code that is always called under a spinlock with
> interrups disabled. Within that piece of code I iterate through a
> list. I have another piece of code that wants to modify that list. I
> have 2 options:
> 
> 1) Have the other piece of code acquire the same spinlock
> 2) Use RCU
> 
> I don't want to do 1) because the otheir piece of code does not really
> care about object owning the spinlock and so acquiring the spinlock is
> "not nice". However it is guaranteed that the piece of code that
> accesses lock runs atomically with interrupts disabled. So
> rcu_read_lock() would be superfluos there.
> 
> Is it possible to still use list_for_each_rcu() and friends to access
> that list without rcu_read_lock()? Or it is betteruse complete RCU
> interface and eat cost of couple of extra instrctions?

Yes, preemptible rcu requires that you use the full interface, also, it
more clearly documents the code. Trying to find code that breaks these
assumptions is very tedious work after the fact.

Please do use the RCU interface in full.


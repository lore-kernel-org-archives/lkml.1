Return-Path: <linux-kernel-owner+w=401wt.eu-S933667AbXBYGhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933667AbXBYGhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 01:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbXBYGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 01:37:47 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932988AbXBYGhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 01:37:46 -0500
Date: Sat, 24 Feb 2007 22:37:44 -0800 (PST)
Message-Id: <20070224.223744.59470086.davem@davemloft.net>
To: mingo@elte.hu
Cc: paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: BUG in 2.6.20-rt8
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070225062747.GA13432@elte.hu>
References: <20070225050212.GA17258@linux.vnet.ibm.com>
	<20070225062747.GA13432@elte.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 25 Feb 2007 07:27:47 +0100

> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > I got the following running stock 2.6.20-rt8 on an 4-CPU 1.8GHz 
> > Opteron box.  The machine continued to run a few rounds of kernbench 
> > and LTP. Looks a bit scary -- a tasklet was "stolen" from 
> > __tasklet_action().
> > 
> > Thoughts?  In the meantime, kicking it off again to see if it repeats.
> 
> > BUG: at kernel/softirq.c:559 __tasklet_action()
> 
> this seems to happen very sporadically. Seems to happen more likely on 
> hyperthreading CPUs. It is very likely caused by the 
> redesign-tasklet-locking-to-be-sane patch below - which is a quick hack 
> of mine from early -rt days. Can you see any obvious bug in it? The 
> cmpxchg logic is certainly a bit ... tricky, locking-wise.

Ingo, please don't use cmpxchg() in generic code, we support several
processors that simply cannot do it.

Instead of saying "it's just something special in -rt for now", take
it out now so that what you do eventually push upstream does get
tested.

Thanks.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760108AbXISObY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108AbXISObY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXISObR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:31:17 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:39829 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751232AbXISObQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:31:16 -0400
Date: Wed, 19 Sep 2007 16:31:11 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH 2/6] lockdep: validate rcu_dereference() vs
 rcu_read_lock()
Message-ID: <20070919163111.05c18021@twins>
In-Reply-To: <d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
References: <20070919104125.286538000@chello.nl>
	<20070919105054.332308000@chello.nl>
	<d120d5000709190717y69dca8b3tf4a17b920267806b@mail.gmail.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 10:17:25 -0400 "Dmitry Torokhov"
<dmitry.torokhov@gmail.com> wrote:

> Hi Peter,
> 
> On 9/19/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Warn when rcu_dereference() is not used in combination with rcu_read_lock()
> >
> 
> According to Paul it is fine to use RCU primitives (when accompanied
> with proper comments) when the read-size critical section is guarded
> by spin_lock_irqsave()/spin_lock_irqsrestore() instead of
> rcu_read_lock()/rcu_read_unlock() and writers synchronize with
> synchronize_sched(), not synchronize_rcu(). Your patch will trigger
> warnign on such valid usages.
> 

Sounds fragile to begin with. But you're right in that that is valid
for Linux as you know it. However in -rt most/all spinlocks are
converted to sleeping locks. In that case sync_sched() is not enough.

So I'd rather recommend against proliferation of such schemes, as we'd
have to clean them up later on.

Still, I'm sure there are other false positives and we need to come up
with proper annotations for those.

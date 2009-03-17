Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZCQNDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZCQNDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbZCQNDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:03:10 -0400
Received: from www.tglx.de ([62.245.132.106]:39720 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbZCQNDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:03:09 -0400
Date: Tue, 17 Mar 2009 14:01:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com
Subject: Re: [v3 PATCH 4/4] timers: logic to move non pinned timers
In-Reply-To: <20090317114557.GA32233@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0903171350020.29264@localhost.localdomain>
References: <20090316111045.GA4686@linux.vnet.ibm.com> <20090316111548.GE4686@linux.vnet.ibm.com> <alpine.LFD.2.00.0903171017590.29264@localhost.localdomain> <20090317114557.GA32233@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Mar 2009, Arun R Bharadwaj wrote:
> * Thomas Gleixner <tglx@linutronix.de> [2009-03-17 11:22:24]:
> >   Let's assume we are on CPU0 and try to enqueue the timer on CPU1,
> >   where the next timer expiry is 5ms away. The timer which we enqueue
> >   is due in 500us. So you introduce 4.5ms latency.
> >
> We are moving timers to the ilb which wakes up every jiffy.
> So we can move the timer to the ilb only if it's expiry
> time is greater than 1 jiffy. Else we can fire on the same CPU.

Please do not start to add some obscure jiffies magic. The correct
check is whether the new timers expiry time is before the first timers
expiry time on the target CPU.

Thanks,

	tglx

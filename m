Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbYHKLlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbYHKLlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYHKLlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:41:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33339 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYHKLlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:41:39 -0400
Date: Mon, 11 Aug 2008 13:42:43 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       marcin.slusarz@gmail.com, linux-kernel@vger.kernel.org,
       davem@davemloft.net, rostedt@goodmis.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] printk: robustify printk
Message-ID: <20080811114243.GO9038@one.firstfloor.org>
References: <alpine.LFD.1.10.0808081014240.3462@nehalem.linux-foundation.org> <1218217257.29098.2.camel@lappy.programming.kicks-ass.net> <alpine.LFD.1.10.0808081043160.3462@nehalem.linux-foundation.org> <1218219269.29098.5.camel@lappy.programming.kicks-ass.net> <20080808121428.646a8b3c.akpm@linux-foundation.org> <1218223269.29098.12.camel@lappy.programming.kicks-ass.net> <1218224829.29098.19.camel@lappy.programming.kicks-ass.net> <20080811104526.GA15186@elte.hu> <87zlnj24qc.fsf@basil.nowhere.org> <1218453726.10800.63.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218453726.10800.63.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2008 at 01:22:06PM +0200, Peter Zijlstra wrote:
> You only loose the msgs with klogd, console still gets everything. If
> firewalls are generating that much data, perhaps its time to think about
> alternative ways to channel that.

Yes, and netfilter has them in fact, but it's clearly still a regression for 
people who rely on klogd for this today.

Also firewall is just an example. Other cases might be people relying
on these selinux messages. Or some other kernel messages.

> 
> > Essentially it makes printk (much?) less reliable than it was before
> > in the general case. Not sure that's a good thing. So the patch
> > title is definitely misleading.
> 
> Depends, I don't give a rats arse about klogd - I get everything through
> serial onto another machine. 

The question of interest is not how you personally configure your systems, 
but what the userbase uses.

> > As Linus pointed out earlier we've survived with this restriction
> > (not doing printk in the scheduler) for a long time, so is there
> > really a that pressing need to change that?
> 
> Why not fix it if its acceptable - the deadlock is just ugly.

Well you fix one thing and you break another thing (high rate
printk). It's not clear to me that the trade off is a good
one in this case. I suppose far more people care about
high rate printk than the number of people who put
printk into the scheduler.

-Andi


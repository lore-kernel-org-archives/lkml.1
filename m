Return-Path: <linux-kernel-owner+w=401wt.eu-S1760439AbZE3TQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439AbZE3TQQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbZE3TQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:16:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41836 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbZE3TQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:16:00 -0400
Subject: Re: SCHED_EDF infos
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: GeunSik Lim <leemgs1@gmail.com>, finarfin@dreamos.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090508091052.GA10429@januz.myftp.org>
References: <164c92d827cbee86ba2c5621716309e6@localhost>
	 <200904300939.31754.henrik@austad.us>
	 <49b7c2350905071935kbd2aa22v9d39cf41c537c24b@mail.gmail.com>
	 <20090508091052.GA10429@januz.myftp.org>
Content-Type: text/plain
Date: Sat, 30 May 2009 21:15:57 +0200
Message-Id: <1243710957.6645.157.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:10 +0200, Henrik Austad wrote:
> > In fact, I also  don't have perfect know how to solve PI in Multicore.
> > [...]
> > > deadline inversion will be a problem, in fact, whatever you chooose to 
> > > be the 'key' for picking tasks (priority, niceness, deadlines, wind 
> > > direction, <whatever>), you can pretty much take that and add a 
> > > -inversion after it. :)
> 
> No, PI is going to be deadly no matter what you do.

Right, we would need to extend the Priority Inheritance Protocol to
include everything the regular scheduling functions operate on.

That is, we can reduce scheduling to a single order operator that orders
all the available tasks, such that t_n < t_n+1.

For pure EDF that would be a comparison on deadlines (and available
bandwidth), for FIFO on static priority and for CFS something based on
the virtual runtimes of the involved tasks. For the combined set of
these scheduling classes the comparator uses the class hierarchy to
order between them.

Lets call the full set of data that is used to determine this order a
task's key.

If we then substitute this key for the static priority of the classic
PIP and use this generic comparison operator, it can be extended to
cover arbitrary complex scheduling functions.


This is a bit like the Proxy Execution Protocol, where we leave the
blocked task in the runqueue, but run another task in its stead. The key
point is that it donates the full task state as relevant to the
scheduling function, or even more directly, it uses the scheduler
itself, to solve the Priority Inversion.




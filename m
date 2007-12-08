Return-Path: <linux-kernel-owner+w=401wt.eu-S1755241AbXLHUvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241AbXLHUvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:51:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbXLHUvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:51:04 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42737 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbXLHUvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:51:03 -0500
Subject: Re: lockdep problem conversion semaphore->mutex (dev->sem)
From: Peter Zijlstra <peterz@infradead.org>
To: Remy Bohmer <linux@bohmer.net>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Dave Chinner <dgc@sgi.com>
In-Reply-To: <3efb10970712081233q10ac7f6bwb2c0ab8107714c1c@mail.gmail.com>
References: <3efb10970712071502p4db9c58ck623c377172ead4b2@mail.gmail.com>
	 <1197116185.31440.1.camel@twins>
	 <1197132792.1568.162.camel@jnielson-xp.ddns.mvista.com>
	 <1197133910.6353.33.camel@lappy>
	 <1197133577.1568.166.camel@jnielson-xp.ddns.mvista.com>
	 <1197135413.6353.36.camel@lappy>
	 <3efb10970712081152o2d4abcfbo634a8d2445c09699@mail.gmail.com>
	 <1197144276.6353.44.camel@lappy>
	 <3efb10970712081233q10ac7f6bwb2c0ab8107714c1c@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 21:50:16 +0100
Message-Id: <1197147016.6353.53.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-08 at 21:33 +0100, Remy Bohmer wrote:

> Which problems? I did not see any special things, it looked rather
> straight forward. What have I overlooked?

On suspend it locks the whole device tree, this means it has 'unbounded'
nesting and holds an 'unbounded' number of locks. Neither things are
easy to annotate (remember that mutex_lock_nested can handle up to 8
nestings and current->held_locks has a max of 30).

In fact, converting this will be the hardest part, it would require
reworking the locking and introduction of a hard limit on the device
tree depth - this might upset some people, but I suspect that 16 or 24
should be deep enough for pretty much anything. Of course, if people
prove me wrong, I'll have to reconsider. The up-side of the locking
scheme I'm thinking of will be that locking the whole tree will only
take 'depth' number of opterations vs the total number of tree elements.




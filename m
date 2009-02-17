Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZBQIZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZBQIZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbZBQIYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:24:53 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbZBQIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:24:53 -0500
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.521787803@chello.nl>
	 <alpine.LFD.2.00.0902161636480.21686@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 09:24:31 +0100
Message-Id: <1234859071.4744.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 16:40 -0800, Linus Torvalds wrote:
> 
> On Mon, 16 Feb 2009, Peter Zijlstra wrote:
> >
> > Now that there is no strict need for kmalloc anymore, and nobody seems to
> > rely it for the queueing behaviour, remove it.
> 
> Peter, I really hate this series.
> 
> Why?
> 
> In 1/4 you introduce that cfd RCU thing, and then in 2/4 you remove it 
> again.

Ah, no, I don't actually. I remove the kmalloc+call_rcu stuff in 2, not
the newly cfd mini rcu thing.

> I realize that you seem to do that in order to do some incremental 
> step-wise changes, but quite frankly, it just complicates the whole series 
> and makes the patches much harder to read and follow.
> 
> Why don't you just combine patches 1&2? That split-up seems to just 
> confuse things. At least it confuses me. Why does it happen?

The idea was to remove the necessity for kmalloc() in patch 1, and then
remove kmalloc() in patch 2.

If you prefer I can fold them, no problem.

But as you might have seen, Oleg has been punching holes in my #1, so I
guess I'm back to the drawing board no matter what :-)


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbZBSQyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbZBSQyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 11:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZBSQyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 11:54:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42061 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738AbZBSQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 11:54:34 -0500
Date: Thu, 19 Feb 2009 08:52:03 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
In-Reply-To: <200902191501.47564.rusty@rustcorp.com.au>
Message-ID: <alpine.LFD.2.00.0902190848570.21686@localhost.localdomain>
References: <20090216163847.431174825@chello.nl> <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu> <200902191501.47564.rusty@rustcorp.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Feb 2009, Rusty Russell wrote:
> 
> So if we care about the kmalloc, why didn't we see benchmarks when we
> switched from the x86 smp_call_function_mask to the generic one?  Or did
> I just miss them (there's nothing in the git commit).

I don't think we care about kmalloc from a performance angle. Sure, it's 
nice if we can make IPI's be really low cost, and we should aim for that, 
but the reason the kmalloc() was added was never performance - nor is that 
the reason we now try to remove it.

The kmalloc() was added for correctness reasons, and we now try to remove 
it to make the code look saner and simpler (and hopefully it gets faster 
too, but I don't think that was ever a primary issue), since we ended up 
having _three_ different cases for the whole insane memory allocation 
(on-stack, per-cpu and kmalloc), and nobody sane really wants that.

			Linus

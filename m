Return-Path: <linux-kernel-owner+w=401wt.eu-S1754208AbZBSEcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbZBSEcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 23:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZBSEcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 23:32:03 -0500
Received: from ozlabs.org ([203.10.76.45]:41976 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbZBSEcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 23:32:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/4] generic-smp: remove kmalloc usage
Date: Thu, 19 Feb 2009 15:01:46 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
References: <20090216163847.431174825@chello.nl> <200902181520.17504.rusty@rustcorp.com.au> <20090218160535.GD23989@elte.hu>
In-Reply-To: <20090218160535.GD23989@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902191501.47564.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 February 2009 02:35:35 Ingo Molnar wrote:
> 
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Tuesday 17 February 2009 20:13:59 Ingo Molnar wrote:
> > > We should not bend backwards trying to preserve that kmalloc() 
> > > [and prove that it's safe and race-free] - i.e. the burden of 
> > > proof is on the person insisting that it's needed, not on the 
> > > person wanting to remove it.
> > 
> > Respectfully disagree.  The kmalloc has been there for a very long time,
> > and doing fine AFAICT.
> 
> The kmalloc(GFP_ATOMIC) has been in kernel/smp.c for about half 
> a year

Oops, yes.

So if we care about the kmalloc, why didn't we see benchmarks when we
switched from the x86 smp_call_function_mask to the generic one?  Or did
I just miss them (there's nothing in the git commit).

Now, I think the current patch is quite neat and may not been benchmarks to
justify it, but it'd still be nice if it were faster, but noone seems to know.

Rusty.

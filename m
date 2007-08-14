Return-Path: <linux-kernel-owner+w=401wt.eu-S936978AbXHNW73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936978AbXHNW73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936662AbXHNW4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 18:56:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40014 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936651AbXHNW4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 18:56:52 -0400
Date: Tue, 14 Aug 2007 15:56:51 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Chris Snook <csnook@redhat.com>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
In-Reply-To: <46C2325C.8040900@redhat.com>
Message-ID: <Pine.LNX.4.64.0708141555300.579@schroedinger.engr.sgi.com>
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141544001.401@schroedinger.engr.sgi.com>
 <46C2325C.8040900@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Chris Snook wrote:

> > volatile means that there is some vague notion of "read it now". But that
> > really does not exist. Instead we control visibility via barriers (smp_wmb,
> > smp_rmb). Would it not be best to not have volatile at all in atomic
> > operations and let the barriers do the work?
> 
> From my reply in the other thread...
> 
> But barriers force a flush of *everything* in scope, which we generally don't
> want.  On the other hand, we pretty much always want to flush atomic_*
> operations.  One way or another, we should be restricting the volatile
> behavior to the thing that needs it.  On most architectures, this patch set
> just moves that from the declaration, where it is considered harmful, to the
> use, where it is considered an occasional necessary evil.
> 
> If you really, *really* distrust the compiler that much, you shouldn't be
> using barrier, since that uses volatile under the hood too.  You should just
> go ahead and implement the atomic operations in assembler, like Segher
> Boessenkool did for powerpc in response to my previous patchset.

>From my reply on the other thread:

Maybe we need two read functions? One volatile, one not?

The atomic_read()s that I have in slub really do not care about when the 
variables are read. And if volatile creates overhead then I rather not have it.


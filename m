Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbZFLNg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbZFLNg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764800AbZFLNax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:30:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:46175 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765436AbZFLNav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:30:51 -0400
Subject: Re: linux-next: origin tree build failure
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
In-Reply-To: <1244812224.7172.146.camel@pasglop>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	 <1244768406.7172.1.camel@pasglop> <20090612092054.GB32052@elte.hu>
	 <1244799197.7172.106.camel@pasglop>  <20090612125335.GH31845@elte.hu>
	 <1244812224.7172.146.camel@pasglop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 23:29:57 +1000
Message-Id: <1244813397.7172.156.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-12 at 23:10 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2009-06-12 at 14:53 +0200, Ingo Molnar wrote:

> To some extent, here, the issue is on Linus side and it's up to him (Hey
> Linus ! still listening ?) to maybe be more proactive at giving an ack
> or nack so that we can get a chance to do that final pass of ironing out
> the mechanical bugs before we hit the main tree.

Let me add a little bit more background to my reasoning here and why I
think having this integration testing step is so valuable...

It all boils down to bisection and having a bisectable tree.

Yes, I hate bisecting and I'm sure you are the same. It's a major PITA
and in most cases, I'm better off tracking down the actual bug and then
finding how it came into being.

However, what the ability to have a reasonably bisectable tree buys us
is all those users, testers, good wills, etc... people who do not have
the knowledge, skill, familiarity with the code etc... to track the bug
down, to be able to still find out what precise patch brought that pesky
regression that doesn't happen on anybody else machine, and thus brings
us some useful material to work with when we cannot reproduce the exact
same setup on our own machines.

Yes, I and I'm sure you can deal with a bisection breakage caused by a
minor screweup like the one we are talking about. But our testers often
can't and will just give up.

It has -nothing- to do with whether the patches are controversial or
not, it is purely about trying to make sure that things going into linus
tree had at least a few days of churning by the various involved parties
to try to get closer to the graal of a fully bisectable tree.

At least that's how I see it.

Now, we may disagree and I'm happy to discuss that more around a beer at
next KS, and to some extent, what is done is done, and if we screwed up
with -next vs. perfmon, then so be it and let's learn from our mistakes,
but I believe it makes a lot of sense to have that staging area that
helps us making sure that within a merge window with gazillion things
being merged pretty much at once, we keep this ability for our users and
testers to track down which individual patch broke something.

Cheers,
Ben.



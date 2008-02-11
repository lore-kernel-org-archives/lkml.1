Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbYBKTgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbYBKTgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbYBKTgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:36:44 -0500
Received: from smtp-out.google.com ([216.239.45.13]:1548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbYBKTgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:36:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=H1rwMCXiCS07SOD/Qaxuli9QBIT4/AV+oIT3awxiujbC2iMGotfTfpC37ImLevT3m
	CnKjCGsNUxTpp7gai6ESQ==
Date: Mon, 11 Feb 2008 11:34:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
In-Reply-To: <1202747811.5014.37.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802111127080.1671@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>  <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com> <1202747811.5014.37.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008, Lee Schermerhorn wrote:

> These patches look good--well, interesting, anyway.  I'm "off on
> assignment" this week, so I won't get to review in detail, merge and
> test them until next...   
> 

If, by "interesting", you mean that they give the most power to the user 
in setting up their mempolicies than they have ever had before, then I 
agree.

> This helper functions introduced by this patch are similar in nature
> [but go further] to one I introduced in the reference counting cleanup
> RFC [http://marc.info/?l=linux-mm&m=119697614520515&w=4] I posted a
> while back.  I've been holding these cleanup patches until Andrew starts
> accepting this sort of thing again.  I have my series based atop Mel
> Gorman's [added to cc] "two zonelist" series, as it depends on removing
> the custom zonelist from the mempolicy.
> 

If my helper functions are similar to yours then basing either of our 
patchsets on top of the other should not be difficult.

> We need to sort out with Andrew, Mel, Paul, ... the order in which these
> interdependent changes go in.  Given such an order, I'm willing to merge
> them all up, test them, and post them [after running checkpatch, of
> course].
> 

Thanks for volunteering to test the changes.  I don't know how many 
patchsets are currently outstanding that touch mempolicies.  So far we 
have mine and the refcounting cleanup of yours that you mentioned.

I think the best way of dealing with it would be for the author of 
whatever patchset is merged second to rebase off the current -mm just like 
I based this entire patchset on your V3 contextualize_policy() patch from 
a couple days ago.

> One other thing:  In the recent mempolicy patch to "silently restrict
> nodemask], I mentioned the issue with regards to whether and when to
> "contextualize" tmpfs/hugetlbfs policies--if/when we fold
> mpol_check_policy() into mpol_new(), as you suggested.  Once we can
> agree on the desired semantics, I had been thinking that an additional
> mode flag could be added to policies obtained from the superblock, and
> passed via mpol_shared_policy_init() [which calls mpol_new()] could be
> used for this purpose.  Your change here seems to lay the foundation for
> implementing that.
> 

My patchset already supports contextualized tmpfs mempolicies with a 
template for how to specify them (see patch 4 in this series for the 
documentation update).  For example, mpol=interleave:1-3 is the equivalent 
of MPOL_INTERLEAVE over nodes 1-3 while mpol=interleave=static:1-3 is the
equivalent of MPOL_INTERLEAVE | MPOL_F_STATIC_NODES.

		David

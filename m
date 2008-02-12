Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbYBLPbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbYBLPbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbYBLPbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:31:32 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7980 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbYBLPba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:31:30 -0500
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802111127080.1671@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <1202747811.5014.37.camel@localhost>
	 <alpine.DEB.1.00.0802111127080.1671@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 12 Feb 2008 08:31:07 -0700
Message-Id: <1202830267.4974.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 11:34 -0800, David Rientjes wrote:
> On Mon, 11 Feb 2008, Lee Schermerhorn wrote:
> 
> > These patches look good--well, interesting, anyway.  I'm "off on
> > assignment" this week, so I won't get to review in detail, merge and
> > test them until next...   
> > 
> 
> If, by "interesting", you mean that they give the most power to the user 
> in setting up their mempolicies than they have ever had before, then I 
> agree.

Hi David:  to clarify:  I added the "interesting" because I didn't want
the "look good" to be interpreted as an informed judgement.  I hadn't
time to review in detail.  I do have some comments, which I'll send in
response to the original patch messages [or any later posting thereof,
should that occur before I have time].  

> 
> > This helper functions introduced by this patch are similar in nature
> > [but go further] to one I introduced in the reference counting cleanup
> > RFC [http://marc.info/?l=linux-mm&m=119697614520515&w=4] I posted a
> > while back.  I've been holding these cleanup patches until Andrew starts
> > accepting this sort of thing again.  I have my series based atop Mel
> > Gorman's [added to cc] "two zonelist" series, as it depends on removing
> > the custom zonelist from the mempolicy.
> > 
> 
> If my helper functions are similar to yours then basing either of our 
> patchsets on top of the other should not be difficult.
> 
> > We need to sort out with Andrew, Mel, Paul, ... the order in which these
> > interdependent changes go in.  Given such an order, I'm willing to merge
> > them all up, test them, and post them [after running checkpatch, of
> > course].
> > 
> 
> Thanks for volunteering to test the changes.  I don't know how many 
> patchsets are currently outstanding that touch mempolicies.  So far we 
> have mine and the refcounting cleanup of yours that you mentioned.
> 
> I think the best way of dealing with it would be for the author of 
> whatever patchset is merged second to rebase off the current -mm just like 
> I based this entire patchset on your V3 contextualize_policy() patch from 
> a couple days ago.
> 
> > One other thing:  In the recent mempolicy patch to "silently restrict
> > nodemask], I mentioned the issue with regards to whether and when to
> > "contextualize" tmpfs/hugetlbfs policies--if/when we fold
> > mpol_check_policy() into mpol_new(), as you suggested.  Once we can
> > agree on the desired semantics, I had been thinking that an additional
> > mode flag could be added to policies obtained from the superblock, and
> > passed via mpol_shared_policy_init() [which calls mpol_new()] could be
> > used for this purpose.  Your change here seems to lay the foundation for
> > implementing that.
> > 
> 
> My patchset already supports contextualized tmpfs mempolicies with a 
> template for how to specify them (see patch 4 in this series for the 
> documentation update).  For example, mpol=interleave:1-3 is the equivalent 
> of MPOL_INTERLEAVE over nodes 1-3 while mpol=interleave=static:1-3 is the
> equivalent of MPOL_INTERLEAVE | MPOL_F_STATIC_NODES.

Hmmm, so 'static' means "don't contexutalize"--i.e., don't mask off
disallowed or memoryless nodes?  That means we'll need to skip them in
the interleave node calculation in the allocation path.  Perhaps your
patch already addresses this, but I haven't had time to look.  

Later,
Lee



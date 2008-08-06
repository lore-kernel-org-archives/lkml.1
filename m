Return-Path: <linux-kernel-owner+w=401wt.eu-S1760579AbYHFTvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760579AbYHFTvX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 15:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757961AbYHFTvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 15:51:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:44599 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbYHFTvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 15:51:13 -0400
Subject: Re: [RFC] [PATCH 0/5 V2] Huge page backed user-space stacks
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, ebmunson@us.ibm.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, libhugetlbfs-devel@lists.sourceforge.net,
       abh@cray.com
In-Reply-To: <20080806090222.GD21190@csn.ul.ie>
References: <20080730172317.GA14138@csn.ul.ie>
	 <20080730103407.b110afc2.akpm@linux-foundation.org>
	 <20080730193010.GB14138@csn.ul.ie>
	 <20080730130709.eb541475.akpm@linux-foundation.org>
	 <20080731103137.GD1704@csn.ul.ie> <1217884211.20260.144.camel@nimitz>
	 <20080805111147.GD20243@csn.ul.ie> <1217952748.10907.18.camel@nimitz>
	 <20080805162800.GJ20243@csn.ul.ie> <1217958805.10907.45.camel@nimitz>
	 <20080806090222.GD21190@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 12:50:49 -0700
Message-Id: <1218052249.10907.125.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 10:02 +0100, Mel Gorman wrote:
> > That said, this particular patch doesn't appear *too* bound to hugetlb
> > itself.  But, some of its limitations *do* come from the filesystem,
> > like its inability to handle VM_GROWS...  
> 
> The lack of VM_GROWSX is an issue, but on its own it does not justify
> the amount of churn necessary to support direct pagetable insertions for
> MAP_ANONYMOUS|MAP_PRIVATE. I think we'd need another case or two that would
> really benefit from direct insertions to pagetables instead of hugetlbfs so
> that the path would get adequately tested.

I'm jumping around here a bit, but I'm trying to get to the core of what
my problem with these patches is.  I'll see if I can close the loop
here.

The main thing this set of patches does that I care about is take an
anonymous VMA and replace it with a hugetlb VMA.  It does this on a
special cue, but does it nonetheless.

This patch has crossed a line in that it is really the first
*replacement* of a normal VMA with a hugetlb VMA instead of the creation
of the VMAs at the user's request.  I'm really curious what the plan is
to follow up on this.  Will this stack stuff turn out to be one-off
code, or is this *the* route for getting transparent large pages in the
future?

Because of the limitations like its inability to grow the VMA, I can't
imagine that this would be a generic mechanism that we can use
elsewhere.

-- Dave


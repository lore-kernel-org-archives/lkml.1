Return-Path: <linux-kernel-owner+w=401wt.eu-S965662AbYD1Ugl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965662AbYD1Ugl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936861AbYD1UgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:36:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55435 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935577AbYD1UgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:36:10 -0400
Date: Mon, 28 Apr 2008 15:36:09 -0500
From: Russ Anderson <rja@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Luck <tony.luck@intel.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 0/2] ia64: Migrate data off physical pages with correctable errors
Message-ID: <20080428203609.GB23847@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080428192252.GA14629@sgi.com> <20080428193323.GA14990@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428193323.GA14990@parisc-linux.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 01:33:23PM -0600, Matthew Wilcox wrote:
> On Mon, Apr 28, 2008 at 02:22:52PM -0500, Russ Anderson wrote:
> > 	There is always an issue of how agressive the code should be on
> > 	migrating pages.  Should it migrate on the first correctable error,
> > 	or wait for some threshold?  Reasonable people may disagree on the
> > 	threshold and the "right" answer may be hardware specific.  The 
> > 	decision making is confined to the cpe_migrate.c code.  It is
> > 	currently set to migrate on the first correctable error.
> 
> I think the kernel code should do the migration ASAP.  But I think we
> should have a list of 'bad' pages.  We could then have a badram driver
> that userspace can talk to to find out which pages are bad, map those
> pages into a badram process, do various tests on them, and return the
> pages to the pool if they're determined to be 'good'.

Sure.  The bad page list is badpagelist (defined in mca.c).
 
> I could also see badramd having a list of pages found to be bad
> in previous boots and asking the badram driver to take them out of
> circulation early in boot before they've been allocated.

That would be one alternative.  That type functionality would be
useful.  FWIW, some of my testing was on a system with a DIMM with
solid single bits.  It is a row/column problem so several meg of
addresses are effected.  Each boot it would migrate several meg worth
of pages without any problem.  It works surprisingly good.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbZF2JPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbZF2JPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 05:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZF2JP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 05:15:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48709 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbZF2JP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 05:15:27 -0400
Date: Mon, 29 Jun 2009 11:15:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       earl_chew@agilent.com, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when using pipes in core_pattern
Message-ID: <20090629091529.GD6760@one.firstfloor.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org> <20090625163050.d6a71a13.akpm@linux-foundation.org> <20090626104804.GA7337@hmsreliant.think-freely.org> <20090626092001.32e35e17.akpm@linux-foundation.org> <20090628193112.GA6760@one.firstfloor.org> <20090628135235.10f9b153.akpm@linux-foundation.org> <m163egt524.fsf@fess.ebiederm.org> <20090628214855.GC6760@one.firstfloor.org> <m1hby0qahq.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hby0qahq.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 03:06:25PM -0700, Eric W. Biederman wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> >> Andrew should I toss all 100 or so patches over the wall to you
> >> and your -mm tree?  Or should I maintain a public git tree based
> >> at 2.6.31-rc1?  Get it into linux-next and ask Linus to pull it when
> >> the merge window comes?
> >
> > What do these 100 odd patches do exactly? 
> 
> Mostly a fine grained killing of ctl_name, and strategy.

Ok.

The only issue is -- assuming we convert that over to DEFINE_SYSCTL
too (which I think would be much nicer) all tee maintainers would
need to process two patches. So perhaps it would be better to combine
this into a single update?

> > Then the binary sysctls could be handled by a global table
> > in a separate file like you described
> 
> Getting the binary sysctl crud out of the core path should
> happen first.  That is just a handful of patches.

Agreed. It should be just a separate table.

> > the current interfaces are not great, but could be probably kept.
> 
> Things like register_sysctl_path can be greatly improved.  Now
> that we don't have to worry about the binary paths.

With a module DEFINE_SYSCTL() only truly dynamic sysctls (like
the network per device sysctls) would need that anyways; the
far majority of callers wouldn't need to call any functions.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.

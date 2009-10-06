Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbZJFIyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbZJFIyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbZJFIyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:54:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59609 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbZJFIyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:54:19 -0400
Date: Tue, 6 Oct 2009 09:53:45 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Frans Pop <elendil@planet.nl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Message-ID: <20091006085345.GA18185@csn.ul.ie>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050851.02056.elendil@planet.nl> <20091005085739.GB5452@csn.ul.ie> <200910052334.23833.elendil@planet.nl> <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910051700440.31688@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 05, 2009 at 05:04:55PM -0700, David Rientjes wrote:
> On Mon, 5 Oct 2009, Frans Pop wrote:
> 
> > And the winner is:
> > 2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
> > commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
> > Author: David Rientjes <rientjes@google.com>
> > Date:   Tue Jun 16 15:32:56 2009 -0700
> > 
> >     oom: move oom_adj value from task_struct to mm_struct
> > 
> > I'm confident that the bisection is good. The test case was very reliable 
> > while zooming in on the merge from akpm.
> > 
> 
> I doubt it for two reasons: (i) this commit was reverted in 0753ba0 since 
> 2.6.31-rc7 and is no longer in the kernel, and (ii) these are GFP_ATOMIC 
> allocations which would be unaffected by oom killer scores.
> 

However, the problem was reported to start showing up in 2.6.31-rc1 so
while it might not be *the* patch, it might be making the type of change
that caused more fragmentation. This patch adjusted the size of
mm_struct and maybe it was enough to change the "order" required for the
slab. Maybe there are other slabs that have changed size as well in that
timeframe.

Frans, what is the size of mm_struct before and after this patch was
applied? Find it with either

grep mm_struct /proc/slabinfo

and if the information is not available there, try

cat /sys/kernel/slab/mm_struct/slab_size and
/sys/kernel/slab/mm_struct/order

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

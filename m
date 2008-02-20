Return-Path: <linux-kernel-owner+w=401wt.eu-S1757651AbYBTDTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651AbYBTDTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 22:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYBTDTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 22:19:43 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41094 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751112AbYBTDTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 22:19:42 -0500
Date: Tue, 19 Feb 2008 21:19:40 -0600
From: Robin Holt <holt@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Robin Holt <holt@sgi.com>, Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080220031940.GF11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <20080220010038.GQ7128@v2.random> <20080220030031.GC11364@sgi.com> <200802201411.42360.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802201411.42360.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 02:11:41PM +1100, Nick Piggin wrote:
> On Wednesday 20 February 2008 14:00, Robin Holt wrote:
> > On Wed, Feb 20, 2008 at 02:00:38AM +0100, Andrea Arcangeli wrote:
> > > On Wed, Feb 20, 2008 at 10:08:49AM +1100, Nick Piggin wrote:
> 
> > > > Also, how to you resolve the case where you are not allowed to sleep?
> > > > I would have thought either you have to handle it, in which case nobody
> > > > needs to sleep; or you can't handle it, in which case the code is
> > > > broken.
> > >
> > > I also asked exactly this, glad you reasked this too.
> >
> > Currently, we BUG_ON having a PFN in our tables and not being able
> > to sleep.  These are mappings which MPT has never supported in the past
> > and XPMEM was already not allowing page faults for VMAs which are not
> > anonymous so it should never happen.  If the file-backed operations can
> > ever get changed to allow for sleeping and a customer has a need for it,
> > we would need to change XPMEM to allow those types of faults to succeed.
> 
> Do you really want to be able to swap, or are you just interested
> in keeping track of unmaps / prot changes?

I would rather not swap, but we do have one customer that would like
swapout to work for certain circumstances.  Additionally, we have
many customers that would rather that their system not die under I/O
termination.

Thanks,
Robin

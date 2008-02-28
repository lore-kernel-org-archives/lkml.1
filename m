Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbYB1Kxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbYB1Kxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 05:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbYB1KxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 05:53:24 -0500
Received: from relay2.sgi.com ([192.48.171.30]:57737 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753363AbYB1KxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 05:53:23 -0500
Date: Thu, 28 Feb 2008 04:53:18 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080228105317.GS11391@sgi.com>
References: <20080215064859.384203497@sgi.com> <20080215064932.620773824@sgi.com> <200802201008.49933.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0802271424390.13186@schroedinger.engr.sgi.com> <20080228001104.GB8091@v2.random> <Pine.LNX.4.64.0802271613080.15791@schroedinger.engr.sgi.com> <20080228005249.GF8091@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228005249.GF8091@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 01:52:50AM +0100, Andrea Arcangeli wrote:
> On Wed, Feb 27, 2008 at 04:14:08PM -0800, Christoph Lameter wrote:
> > Erm. This would also be needed by RDMA etc.
> 
> The only RDMA I know is Quadrics, and Quadrics apparently doesn't need
> to schedule inside the invalidate methods AFIK, so I doubt the above
> is true. It'd be interesting to know if IB is like Quadrics and it
> also doesn't require blocking to invalidate certain remote mappings.

We got an answer from the IB guys already.  They do not track which of
their handles are being used by remote processes so neither approach
will work for their purposes with the exception of straight unmaps.  In
that case, they could use the callout to remove TLB information and rely
on the lack of page table information to kill the users process.
Without changes to their library spec, I don't believe anything further
is possible.  If they did change their library spec, I believe they
could get things to work the same way that XPMEM has gotten things to
work, where a message is sent to the remote side for TLB clearing and
that will require sleeping.

Thanks,
Robin

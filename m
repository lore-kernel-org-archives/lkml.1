Return-Path: <linux-kernel-owner+w=401wt.eu-S1755620AbYDVTmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbYDVTmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbYDVTm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:42:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37575 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755864AbYDVTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:42:25 -0400
Date: Tue, 22 Apr 2008 14:42:23 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Robin Holt <holt@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 00 of 12] mmu notifier #v13
Message-ID: <20080422194223.GT22493@sgi.com>
References: <patchbomb.1208872276@duo.random> <20080422182213.GS22493@sgi.com> <20080422184335.GN24536@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422184335.GN24536@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:43:35PM +0200, Andrea Arcangeli wrote:
> On Tue, Apr 22, 2008 at 01:22:13PM -0500, Robin Holt wrote:
> > 1) invalidate_page:  You retain an invalidate_page() callout.  I believe
> > we have progressed that discussion to the point that it requires some
> > direction for Andrew, Linus, or somebody in authority.  The basics
> > of the difference distill down to no expected significant performance
> > difference between the two.  The invalidate_page() callout potentially
> > can simplify GRU code.  It does provide a more complex api for the
> > users of mmu_notifier which, IIRC, Christoph had interpretted from one
> > of Andrew's earlier comments as being undesirable.  I vaguely recall
> > that sentiment as having been expressed.
> 
> invalidate_page as demonstrated in KVM pseudocode doesn't change the
> locking requirements, and it has the benefit of reducing the window of
> time the secondary page fault has to be masked and at the same time
> _halves_ the number of _hooks_ in the VM every time the VM deal with
> single pages (example: do_wp_page hot path). As long as we can't fully
> converge because of point 3, it'd rather keep invalidate_page to be
> better. But that's by far not a priority to keep.

Christoph, Jack and I just discussed invalidate_page().  I don't think
the point Andrew was making is that compelling in this circumstance.
The code has change fairly remarkably.  Would you have any objection to
putting it back into your patch/agreeing to it remaining in Andrea's
patch?  If not, I think we can put this issue aside until Andrew gets
out of the merge window and can decide it.  Either way, the patches
become much more similar with this in.

Thanks,
Robin

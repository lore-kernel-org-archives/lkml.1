Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbYDVSWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbYDVSWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761301AbYDVSWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:22:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33382 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760811AbYDVSWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:22:16 -0400
Date: Tue, 22 Apr 2008 13:22:13 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>,
       Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 00 of 12] mmu notifier #v13
Message-ID: <20080422182213.GS22493@sgi.com>
References: <patchbomb.1208872276@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patchbomb.1208872276@duo.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I believe the differences between your patch set and Christoph's need
to be understood and a compromise approach agreed upon.

Those differences, as I understand them, are:

1) invalidate_page:  You retain an invalidate_page() callout.  I believe
we have progressed that discussion to the point that it requires some
direction for Andrew, Linus, or somebody in authority.  The basics
of the difference distill down to no expected significant performance
difference between the two.  The invalidate_page() callout potentially
can simplify GRU code.  It does provide a more complex api for the
users of mmu_notifier which, IIRC, Christoph had interpretted from one
of Andrew's earlier comments as being undesirable.  I vaguely recall
that sentiment as having been expressed.

2) Range callout names: Your range callouts are invalidate_range_start
and invalidate_range_end whereas Christoph's are start and end.  I do not
believe this has been discussed in great detail.  I know I have expressed
a preference for your names.  I admit to having failed to follow up on
this issue.  I certainly believe we could come to an agreement quickly
if pressed.

3) The structure of the patch set:  Christoph's upcoming release orders
the patches so the prerequisite patches are seperately reviewable
and each file is only touched by a single patch.  Additionally, that
allows mmu_notifiers to be introduced as a single patch with sleeping
functionality from its inception and an API which remains unchanged.
Your patch set, however, introduces one API, then turns around and
changes that API.  Again, the desire to make it an unchanging API was
expressed by, IIRC, Andrew.  This does represent a risk to XPMEM as
the non-sleeping API may become entrenched and make acceptance of the
sleeping version less acceptable.

Can we agree upon this list of issues?

Thank you,
Robin Holt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbYDYTZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbYDYTZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 15:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYDYTZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 15:25:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42484 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbYDYTZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 15:25:35 -0400
Date: Fri, 25 Apr 2008 14:25:32 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
	operation to happen
Message-ID: <20080425192532.GA19717@sgi.com>
References: <ec6d8f91b299cf26cce5.1207669444@duo.random> <200804221506.26226.rusty@rustcorp.com.au> <20080425165639.GA23300@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425165639.GA23300@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 06:56:40PM +0200, Andrea Arcangeli wrote:
> Fortunately I figured out we don't really need mm_lock in unregister
> because it's ok to unregister in the middle of the range_begin/end
> critical section (that's definitely not ok for register that's why
> register needs mm_lock). And it's perfectly ok to fail in register().

I think you still need mm_lock (unless I miss something).  What happens
when one callout is scanning mmu_notifier_invalidate_range_start() and
you unlink.  That list next pointer with LIST_POISON1 which is a really
bad address for the processor to track.

Maybe I misunderstood your description.

Thanks,
Robin

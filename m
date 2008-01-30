Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYA3WSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYA3WSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYA3WSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:18:07 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57068 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753465AbYA3WSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:18:06 -0500
Date: Wed, 30 Jan 2008 16:18:02 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130221801.GW26420@sgi.com>
References: <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <20080130161123.GS26420@sgi.com> <20080130170451.GP7233@v2.random> <20080130173009.GT26420@sgi.com> <20080130182506.GQ7233@v2.random> <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301147330.30568@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:50:26AM -0800, Christoph Lameter wrote:
> On Wed, 30 Jan 2008, Andrea Arcangeli wrote:
> 
> > XPMEM requires with invalidate_range (sleepy) +
> > before_invalidate_range (sleepy). invalidate_all should also be called
> > before_release (both sleepy).
> > 
> > It sounds we need full overlap of information provided by
> > invalidate_page and invalidate_range to fit all three models (the
> > opposite of the zero objective that current V3 is taking). And the
> > swap will be handled only by invalidate_page either through linux rmap
> > or external rmap (with the latter that can sleep so it's ok for you,
> > the former not). GRU can safely use the either the linux rmap notifier
> > or the external rmap notifier equally well, because when try_to_unmap
> > is called the page is locked and obviously pinned by the VM itself.
> 
> So put the invalidate_page() callbacks in everywhere.

The way I am envisioning it, we essentially drop back to Andrea's original
patch.  We then introduce a invalidate_range_begin (I was really thinking
of it as invalidate_and_lock_range()) and an invalidate_range_end (again
I was thinking of unlock_range).

Thanks,
Robin

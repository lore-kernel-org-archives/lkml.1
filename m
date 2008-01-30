Return-Path: <linux-kernel-owner+w=401wt.eu-S932150AbYA3U3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbYA3U3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYA3U3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:29:21 -0500
Received: from relay1.sgi.com ([192.48.171.29]:43794 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754571AbYA3U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:29:20 -0500
Date: Wed, 30 Jan 2008 14:29:18 -0600
From: Jack Steiner <steiner@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, daniel.blueman@quadrics.com,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
Message-ID: <20080130202918.GB11324@sgi.com>
References: <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random> <Pine.LNX.4.64.0801291620170.28027@schroedinger.engr.sgi.com> <20080130002804.GA13840@sgi.com> <20080130133720.GM7233@v2.random> <20080130144305.GA25193@sgi.com> <Pine.LNX.4.64.0801301140320.30568@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801301140320.30568@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 11:41:29AM -0800, Christoph Lameter wrote:
> On Wed, 30 Jan 2008, Jack Steiner wrote:
> 
> > I see what you mean. I need to review to mail to see why this changed
> > but in the original discussions with Christoph, the invalidate_range
> > callouts were suppose to be made BEFORE the pages were put on the freelist.
> 
> Seems that we cannot rely on the invalidate_ranges for correctness at all?
> We need to have invalidate_page() always. invalidate_range() is only an 
> optimization.
> 

I don't understand your point "an optimization". How would invalidate_range
as currently defined be correctly used?

It _looks_ like it would work only if xpmem/gru/etc takes a refcnt on
the page & drops it when invalidate_range is called. That may work (not sure)
for xpmem but not for the GRU.

--- jack


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754713AbYBSL7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbYBSL7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYBSL7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:59:44 -0500
Received: from relay2.sgi.com ([192.48.171.30]:58599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751301AbYBSL7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:59:43 -0500
Date: Tue, 19 Feb 2008 05:59:38 -0600
From: Robin Holt <holt@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, Andrea Arcangeli <andrea@qumranet.com>,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080219115938.GD11391@sgi.com>
References: <20080219084357.GA22249@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219084357.GA22249@wotan.suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 09:43:57AM +0100, Nick Piggin wrote:
> So I implemented mmu notifiers slightly differently. Andrea's mmu notifiers
> are rather similar. However I have tried to make a point of minimising the
> impact the the core mm/. I don't see why we need to invalidate or flush
> anything when changing the pte to be _more_ permissive, and I don't
> understand the need for invalidate_begin/invalidate_end pairs at all.
> What I have done is basically create it so that the notifiers get called
> basically in the same place as the normal TLB flushing is done, and nowhere
> else.

Because XPMEM needs to be able to sleep during its callout.  For that,
we need to move this outside of the page table lock and suddenly we
need the begin/end pair again.  There was considerable discussion about
this exact point numerous times.  We tried to develop the most inclusive
design possible.  Our design would even be extendable to IB, assuming they
made some very disruptive changes to their MPI and communication libraries.
IB would suffer the same problems XPMEM does in that the TLB entries
need to be removed on a remote host which is operating completely
independently.

Thanks,
Robin

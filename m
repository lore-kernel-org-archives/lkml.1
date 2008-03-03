Return-Path: <linux-kernel-owner+w=401wt.eu-S1758584AbYCCSX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758584AbYCCSX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYCCSXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:23:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41711 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752870AbYCCSXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:23:12 -0500
Date: Mon, 3 Mar 2008 12:23:08 -0600
From: Jack Steiner <steiner@sgi.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@qumranet.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8
Message-ID: <20080303182308.GC3552@sgi.com>
References: <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random> <20080303032934.GA3301@wotan.suse.de> <20080303125152.GS8091@v2.random> <20080303131017.GC13138@wotan.suse.de> <20080303151859.GA19374@sgi.com> <20080303165910.GA23998@wotan.suse.de> <20080303180605.GA3552@sgi.com> <47CC3EED.7090507@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CC3EED.7090507@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 08:09:49PM +0200, Avi Kivity wrote:
> Jack Steiner wrote:
> >The range invalidates have a performance advantage for the GRU. TLB 
> >invalidates
> >on the GRU are relatively slow (usec) and interfere somewhat with the 
> >performance
> >of other active GRU instructions. Invalidating a large chunk of addresses 
> >with
> >a single GRU TLBINVAL operation is must faster than issuing a stream of 
> >single
> >page TLBINVALs.
> >
> >I expect this performance advantage will also apply to other users of 
> >mmuops.
> >  
> 
> In theory this would apply to kvm as well (coalesce tlb flush IPIs, 
> lookup shadow page table once), but is it really a fast path?  What 
> triggers range operations for your use cases?
 

Although not frequent, an unmap of a multiple TB object could be quite painful
if each page was invalidated individually instead of 1 invalidate for the entire range.
This is even worse if the application is threaded and the object has been reference by
many GRUs (there are 16 GRU ports per node - each potentially has to be invalidated).

Forks (again, not frequent) would be another case.




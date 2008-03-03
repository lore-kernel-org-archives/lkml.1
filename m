Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbYCCSLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbYCCSLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759704AbYCCSJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:09:57 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58261
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671AbYCCSJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:09:56 -0500
Message-ID: <47CC3EED.7090507@qumranet.com>
Date: Mon, 03 Mar 2008 20:09:49 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jack Steiner <steiner@sgi.com>
CC: Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <andrea@qumranet.com>,
       akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] mmu notifiers #v8
References: <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <20080302155457.GK8091@v2.random> <20080303032934.GA3301@wotan.suse.de> <20080303125152.GS8091@v2.random> <20080303131017.GC13138@wotan.suse.de> <20080303151859.GA19374@sgi.com> <20080303165910.GA23998@wotan.suse.de> <20080303180605.GA3552@sgi.com>
In-Reply-To: <20080303180605.GA3552@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Steiner wrote:
> The range invalidates have a performance advantage for the GRU. TLB invalidates
> on the GRU are relatively slow (usec) and interfere somewhat with the performance
> of other active GRU instructions. Invalidating a large chunk of addresses with
> a single GRU TLBINVAL operation is must faster than issuing a stream of single
> page TLBINVALs.
>
> I expect this performance advantage will also apply to other users of mmuops.
>   

In theory this would apply to kvm as well (coalesce tlb flush IPIs, 
lookup shadow page table once), but is it really a fast path?  What 
triggers range operations for your use cases?

-- 
error compiling committee.c: too many arguments to function


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbYHDPWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbYHDPWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755267AbYHDPVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:21:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:47044 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYHDPVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:21:52 -0400
Date: Mon, 4 Aug 2008 16:21:46 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Message-ID: <20080804152146.GG18868@shareable.org>
References: <20080801182324.572058187@lameter.com> <20080803015847.GD26461@parisc-linux.org> <48970779.80902@linux-foundation.org> <20080804144823.GE18868@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804144823.GE18868@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Vaguely on this topic, has anyone studied the effects of SLAB/SLUB
> etc. on MMUless systems?

The reason is that MMU-less systems are extremely sensitive to
fragmentation.  Every program started on those systems must allocate a
large contiguous block for the code and data, and every malloc >1 page
is the same.  If memory is too fragmented, starting new programs fails.

The high-order page-allocator defragmentation lately should help with
that.

The different behaviours of SLAB/SLUB might result in different levels
of fragmentation, so I wonder if anyone has compared them on MMU-less
systems or fragmentation-sensitive workloads on general systems.

Thanks,
-- Jamie

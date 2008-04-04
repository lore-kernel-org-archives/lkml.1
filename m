Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbYDDLt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbYDDLt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbYDDLtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:49:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22733 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393AbYDDLtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:49:00 -0400
Date: Fri, 4 Apr 2008 13:46:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: use mapping_gfp_mask
Message-ID: <20080404114609.GG29686@kernel.dk>
References: <Pine.LNX.4.64.0804032331190.27180@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804032331190.27180@blonde.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03 2008, Hugh Dickins wrote:
> The loop block driver is careful to mask __GFP_IO|__GFP_FS out of its
> mapping_gfp_mask, to avoid hangs under memory pressure.  But nowadays
> it uses splice, usually going through __generic_file_splice_read.  That
> must use mapping_gfp_mask instead of GFP_KERNEL to avoid those hangs.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---
> Ought to go into 2.6.25.  For 2.6.23 and 2.6.24 stable?  Well, I've
> not actually seen this hang on any of these, though presumably it's
> lurking there.  Where I did see it, and test the fix, was 2.6.25-rc5-mm1:
> whose SLUB had a disturbing predilection (since corrected) for order-4
> allocations, even when allocating radix tree nodes.

Thanks Hugh, definitely correct! I see it's already merged, so all is
well.

-- 
Jens Axboe


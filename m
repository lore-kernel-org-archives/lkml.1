Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbXGTAdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbXGTAdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbXGTAdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:33:38 -0400
Received: from holomorphy.com ([66.93.40.71]:53426 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755986AbXGTAdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:33:37 -0400
Date: Thu, 19 Jul 2007 17:34:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Adam Litke <agl@us.ibm.com>,
       David Gibson <david@gibson.dropbear.id.au>,
       Ken Chen <kenchen@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH] Check for compound pages in set_page_dirty()
Message-ID: <20070720003445.GN11781@holomorphy.com>
References: <20070718141533.GA11657@kernel.dk> <Pine.LNX.4.64.0707181619200.23261@blonde.wat.veritas.com> <20070718182456.GE11657@kernel.dk> <20070718184006.GF11657@kernel.dk> <Pine.LNX.4.64.0707182052220.18926@blonde.wat.veritas.com> <20070719062934.GT11657@kernel.dk> <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707191720300.10512@blonde.wat.veritas.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 06:35:17PM +0100, Hugh Dickins wrote:
> I started from your patch.  But it now seems to me a bugfix to remove
> those PageCompound tests, because they're preventing a hugetlb page
> from being marked dirty, when Ken needs it to be marked dirty so
> /proc/sys/vm/drop_caches doesn't drop the data read in by DIO.
> (His original patch went into -stable: would the patch fixing
> this all up need to go into -stable?)

This needs to be done some other way. The dirty bit should not be
significant for pseudofs's with no backing store. The consequences
of making it so are becoming apparent in the IO path, and it
caused performance regressions elsewhere as well. ramfs, for instance,
doesn't require anything of this sort to cope with drop_caches.


-- wli

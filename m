Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYCCURY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYCCURY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYCCURH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:17:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57783 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYCCURC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:17:02 -0500
Date: Mon, 3 Mar 2008 21:17:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Christoph Lameter <clameter@sgi.com>
Cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [rfc][patch 1/3] slub: fix small HWCACHE_ALIGN alignment
Message-ID: <20080303201701.GF8974@wotan.suse.de>
References: <20080303093449.GA15091@wotan.suse.de> <Pine.LNX.4.64.0803031107130.6917@schroedinger.engr.sgi.com> <20080303200613.GC8974@wotan.suse.de> <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0803031209570.16049@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 12:10:59PM -0800, Christoph Lameter wrote:
> On Mon, 3 Mar 2008, Nick Piggin wrote:
> 
> > > If they are already not cache line aligned then we can make them as 
> > > dense as possible. That is what SLUB does.
> > 
> > Because when you specify HWCACHE_ALIGN, it means that you want the object
> > not to cross cacheline boundaries for at least cache_line_size() bytes.
> > SLAB does this. SLUB does not without this patch.
> 
> HWCACHE_ALIGN means that you want the object to be aligned at 
> cacheline boundaries for optimization. Why does crossing cacheline 
> boundaries matter in this case?

No, HWCACHE_ALIGN means that you want the object not to cross cacheline
boundaries for at least cache_line_size() bytes. You invented new
semantics with SLUB, but all the callers were written expecting the
existing semantics, presumably. So we should retain that behaviour, and
if you disagree with the actual callers, then that is fine but you
should discuss each case with the relevant people.


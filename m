Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0BKLBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:01:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46343 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0BKLBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:01:39 -0500
Date: Thu, 11 Feb 2010 11:01:19 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-msm@vger.kernel.org, adharmap@codeaurora.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
Message-ID: <20100211110119.GC9480@n2100.arm.linux.org.uk>
References: <20100210212156.GB30854@n2100.arm.linux.org.uk> <1265885102.3389.34.camel@pc1117.cambridge.arm.com> <1265885585.3389.38.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265885585.3389.38.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 10:53:05AM +0000, Catalin Marinas wrote:
> Actually after L2 maintenance we don't even need the __dma_barrier(), we
> need an outer_cache.sync() function.
> 
> I can do the outer cache optimisations together with a few others for
> PL310 (which does not require the cache_wait() call for line
> operations).

I'm in half a mind to say "stop everything for the DMA API and wait
until the next merge window" - what we have at the moment is a big
shake up of how the API is implemented, which has had very little
attributable testing.

Let's get the current code (which missed the last merge window) tested,
acked and merged, and only then sort out these kinds of optimizations
after that.  As it is, these DMA patches have had very little in the
way of attributable feedback so far.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0BKLD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 06:03:57 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40285 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358Ab0BKLDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 06:03:55 -0500
Subject: Re: [RFC 0/2] fix dma_map_sg not to do barriers for each buffer
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-msm@vger.kernel.org, adharmap@codeaurora.org,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Abhijeet Dharmapurikar <adharmap@quicinc.com>
In-Reply-To: <20100211110119.GC9480@n2100.arm.linux.org.uk>
References: <20100210212156.GB30854@n2100.arm.linux.org.uk>
	 <1265885102.3389.34.camel@pc1117.cambridge.arm.com>
	 <1265885585.3389.38.camel@pc1117.cambridge.arm.com>
	 <20100211110119.GC9480@n2100.arm.linux.org.uk>
Content-Type: text/plain
Organization: ARM Ltd
Date: Thu, 11 Feb 2010 11:03:19 +0000
Message-Id: <1265886199.3389.47.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2010 11:03:21.0304 (UTC) FILETIME=[D2CAC580:01CAAB09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 11:01 +0000, Russell King - ARM Linux wrote:
> On Thu, Feb 11, 2010 at 10:53:05AM +0000, Catalin Marinas wrote:
> > Actually after L2 maintenance we don't even need the __dma_barrier(), we
> > need an outer_cache.sync() function.
> >
> > I can do the outer cache optimisations together with a few others for
> > PL310 (which does not require the cache_wait() call for line
> > operations).
> 
> I'm in half a mind to say "stop everything for the DMA API and wait
> until the next merge window" - what we have at the moment is a big
> shake up of how the API is implemented, which has had very little
> attributable testing.
> 
> Let's get the current code (which missed the last merge window) tested,
> acked and merged, and only then sort out these kinds of optimizations
> after that.  As it is, these DMA patches have had very little in the
> way of attributable feedback so far.

I agree, I wasn't planning to submit anything for 2.6.34. These
optimisations should probably get in 2.6.35.

-- 
Catalin


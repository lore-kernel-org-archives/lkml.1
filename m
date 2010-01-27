Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116Ab0A0GvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0A0GvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0A0GvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:51:11 -0500
Received: from gate.crashing.org ([63.228.1.57]:52985 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098Ab0A0GvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:51:10 -0500
Subject: Re: [RFC PATCH] dma: Add barrierless dma mapping/unmapping api
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: adharmap@codeaurora.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org, arnd@arndb.de,
       akpm@linux-foundation.org, mingo@elte.hu, joerg.roedel@amd.com,
       maciej.sosnowski@intel.com, dan.j.williams@intel.com,
       beckyb@kernel.crashing.org, yanghy@cn.fujitsu.com,
       linux-arch@vger.kernel.org, adharmap@quicinc.com
In-Reply-To: <20100127141901P.fujita.tomonori@lab.ntt.co.jp>
References: <1264480210.3601.118.camel@pasglop>
	 <20100126134207T.fujita.tomonori@lab.ntt.co.jp>
	 <4B5F4C76.4050100@codeaurora.org>
	 <20100127141901P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 17:49:47 +1100
Message-ID: <1264574987.3601.171.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 14:19 +0900, FUJITA Tomonori wrote:
> > I somehow missed your post, my apologies. Agreed that
> dma_map/unmap_sg 
> > would be the correct api to use here, however they still call the 
> > dmac_.*_range to map buffers.
> 
> Hmm, sounds like arm's implementation issue. dma_map_sg API doesn't
> require such. dma_map_sg API gives what you want, do a sync only after
> mapping the last buffer.

dmac_* appears to be ARM's low-level ops for cache flushing on
non-coherent DMA, so it's really down to arch stuff here and how ARM
implements dma_[un]map_sg() and we keep a sane global driver API.

Cheers,
Ben.



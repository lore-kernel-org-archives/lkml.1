Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546Ab0AZEn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0AZEn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 23:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317Ab0AZEnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 23:43:53 -0500
Received: from sh.osrg.net ([192.16.179.4]:51445 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab0AZEnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 23:43:52 -0500
Date: Tue, 26 Jan 2010 13:43:01 +0900
To: benh@kernel.crashing.org
Cc: adharmap@codeaurora.org, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org, dwalker@codeaurora.org, arnd@arndb.de,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu,
       joerg.roedel@amd.com, maciej.sosnowski@intel.com,
       dan.j.williams@intel.com, beckyb@kernel.crashing.org,
       yanghy@cn.fujitsu.com, linux-arch@vger.kernel.org, adharmap@quicinc.com
Subject: Re: [RFC PATCH] dma: Add barrierless dma mapping/unmapping api
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1264480210.3601.118.camel@pasglop>
References: <1264473346-32721-1-git-send-email-adharmap@codeaurora.org>
	<1264480210.3601.118.camel@pasglop>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100126134207T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 26 Jan 2010 13:43:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 15:30:10 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2010-01-25 at 18:35 -0800, adharmap@codeaurora.org wrote:
> > From: Abhijeet Dharmapurikar <adharmap@quicinc.com>
> > 
> > Tests have shown that there is a significant performance gain
> > when a driver uses mapping/unmapping functions without a barrier
> > multiple times and calls dsb() only after the last buffer. This
> > api adds support for barrierless dma operations on ARMv6
> > and ARMv7.
> 
> Gotta love when each architecture has subtely different barriers
> semantics ...
> 
> This is ARM stuff at this stage and as such not a huge deal to me but I
> don't like seeing new arch specific API extending generic ones for
> drivers, it's just going to make it harder when those drivers start
> using them and those devices are use on other archs.

Completely agreed. Adding architecture specific DMA API is a really
bad idea. We need to keep the DMA API that works for all the
architectures.


> There are people nowadays putting AXI bridges and the whole ARM
> paraphernalia of IP cores behind them on PowerPC cores for example and I
> can see that happening with x86 as well.
> 
> In your case, I believe your are fixing the wrong problem anyways. The
> right approach would be instead to put all your buffer into an sglist
> and use dma_map/unmap_sg().

Agreed again. That's exactly what I suggested before:

http://marc.info/?l=linux-kernel&m=126294076917753&w=2

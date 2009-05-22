Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbZEVKwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbZEVKwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 06:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZEVKwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 06:52:13 -0400
Received: from sh.osrg.net ([192.16.179.4]:35593 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbZEVKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 06:52:12 -0400
Date: Fri, 22 May 2009 19:51:44 +0900
To: Ian.Campbell@eu.citrix.com
Cc: beckyb@kernel.crashing.org, jeremy@goop.org, fujita.tomonori@lab.ntt.co.jp,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242932497.25553.230.camel@localhost.localdomain>
References: <4A1592CF.8000208@goop.org>
	<E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org>
	<1242932497.25553.230.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090522194810X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 22 May 2009 19:51:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009 20:01:37 +0100
Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:

> > It's not actually clear to me that we need that check, though.  Can 
> > someone explain what case that was designed to catch?
> 
> If map_single fails and returns NULL then we try to use
> io_tlb_overflow_buffer, if that is somehow not DMA-able (for the
> particular device) then the check will trigger. I would have thought we
> could arrange that the overflow buffer is always OK and really if
> map_page is failing we must be close the edge already.

And iotlb buffers are not guaranteed to be DMA-capable; it's possible
that some drivers (with poor dma address restrictions) can't handle
some part of iotlb buffers.

So after allocating some ioblb buffer, we need to check if the buffers
are DMA-capable for a driver. Well, it's unlikely though.

Well, it would be better to move the check to map_single().

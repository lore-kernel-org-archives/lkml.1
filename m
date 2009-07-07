Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZGGRgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZGGRgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbZGGRgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:36:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47879 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZGGRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:36:24 -0400
Date: Tue, 7 Jul 2009 18:36:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Joerg Roedel <joerg.roedel@amd.com>, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
	in dma_sync_*_for_cpu
Message-ID: <20090707173605.GB18504@n2100.arm.linux.org.uk>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <20090707074821.GB6995@n2100.arm.linux.org.uk> <d82e647a0907070643i198b9188q80203ab0408b4df8@mail.gmail.com> <200907071606.48933.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907071606.48933.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 04:06:48PM +0200, Arnd Bergmann wrote:
> Note that actually you need to do writeback+invalidate in DMA_TO_DEVICE

Rubbish.  DMA _to_ the device just needs any data held in the cache to
be pushed out into the hardware RAM.  There's absolutely no point in
invalidating it - that's a complete waste of time.

> and at least an invalidate in DMA_FROM_DEVICE during dma_map_*.
> For the unmap, I don't think you ever need to invalidate the cache.

As I've already explained, you do if you have speculative prefetching
which can bring in data into the cache from _any_ memory location at
_any_ time.  We _are_ going to have to do this, no questions asked.

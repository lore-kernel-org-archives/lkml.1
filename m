Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbZENAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbZENAVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 20:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761707AbZENAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 20:20:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:48552 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762034AbZENAUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 20:20:40 -0400
Date: Thu, 14 May 2009 09:18:50 +0900
To: hancockrwd@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, arnd@arndb.de,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4A0B5E5A.4090906@gmail.com>
References: <20090513043409.GA13577@cynthia.pants.nu>
	<20090513095127.308b00e7@lxorguk.ukuu.org.uk>
	<4A0B5E5A.4090906@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090514091928R.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 14 May 2009 09:18:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 May 2009 17:57:14 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> Alan Cox wrote:
> >>> If it doesn't interfere with plain PIO mode, fine. 
> >> I agree. There definitely needs to still be support for IDE ports that
> >> don't have DMA capability.
> > 
> > There is - it's just if the platform doesn't implement the dma_* APIs you
> > get a problem.
> 
> Wouldn't the easiest solution be to just dummy out the DMA API calls on 
> this platform to always fail? That would fix these compile problems..

Can libata call dma_supported() per device to decide DMA or PIO mode?
Then, we can solve this problem by add dummy DMA API (just calls BUG)
on such architectures, without Kconfig magic or adding ifdef (like the
old ide stack does), I think.

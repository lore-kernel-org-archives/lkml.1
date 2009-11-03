Return-Path: <linux-kernel-owner+w=401wt.eu-S1751097AbZKCJ6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097AbZKCJ6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZKCJ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:58:51 -0500
Received: from bar.sig21.net ([80.81.252.164]:60325 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbZKCJ6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:58:51 -0500
Date: Tue, 3 Nov 2009 11:00:18 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: m25p80: make command buffer DMA-safe
Message-ID: <20091103100018.GA20519@sig21.net>
References: <20091028132137.GA17813@sig21.net>
 <1257230165.21596.33.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257230165.21596.33.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.817,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:36:05AM +0200, Artem Bityutskiy wrote:
> On Wed, 2009-10-28 at 14:21 +0100, Johannes Stezenbach wrote:
> > spi_write() requires the buffer to be DMA-safe, kmalloc()
> > it seperately to ensure this.
> 
> Even though it is just 4 or 5 bytes it can do DMA? Does not sound too
> sane to use DMA in that case. Does this patch fix a real error?
> 
> I do not know much about SPI, but for me it sounds like there should be
> a method to ask SPI to avoid using DMA, and you should use that method.

It fixes a real error -- with an out-of-tree driver and ancient kernel.
For the flash read/write case it is used with list-DMA (e.g. write 4 bytes,
read 64KB).  There are extensive comments in include/linux/spi/spi.h
which document the DMA-safe requirement of the buffers.

Thanks
Johannes

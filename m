Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZKJOyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZKJOyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 09:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZKJOyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 09:54:53 -0500
Received: from smtp.nokia.com ([192.100.122.230]:21793 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZKJOyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 09:54:53 -0500
Subject: Re: [PATCH] mtd: m25p80: make command buffer DMA-safe
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Johannes Stezenbach <js@sig21.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091103100018.GA20519@sig21.net>
References: <20091028132137.GA17813@sig21.net>
	 <1257230165.21596.33.camel@localhost>  <20091103100018.GA20519@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Nov 2009 16:54:07 +0200
Message-Id: <1257864847.21596.769.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Nov 2009 14:54:21.0901 (UTC) FILETIME=[AFEF47D0:01CA6215]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-03 at 11:00 +0100, Johannes Stezenbach wrote:
> On Tue, Nov 03, 2009 at 08:36:05AM +0200, Artem Bityutskiy wrote:
> > On Wed, 2009-10-28 at 14:21 +0100, Johannes Stezenbach wrote:
> > > spi_write() requires the buffer to be DMA-safe, kmalloc()
> > > it seperately to ensure this.
> > 
> > Even though it is just 4 or 5 bytes it can do DMA? Does not sound too
> > sane to use DMA in that case. Does this patch fix a real error?
> > 
> > I do not know much about SPI, but for me it sounds like there should be
> > a method to ask SPI to avoid using DMA, and you should use that method.
> 
> It fixes a real error -- with an out-of-tree driver and ancient kernel.
> For the flash read/write case it is used with list-DMA (e.g. write 4 bytes,
> read 64KB).  There are extensive comments in include/linux/spi/spi.h
> which document the DMA-safe requirement of the buffers.

Pushed to my l2-mtd-2.6 tree, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


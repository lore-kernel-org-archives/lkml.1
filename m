Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZGVImn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZGVImn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZGVImn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:42:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46270 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751611AbZGVImm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:42:42 -0400
Date: Wed, 22 Jul 2009 09:43:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jiri Slaby <jirislaby@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       lethal@linux-sh.org, linux-sh@vger.kernel.org
Subject: Re: Do cpu-endian MMIO accessors exist?
Message-ID: <20090722094309.10b25290@lxorguk.ukuu.org.uk>
In-Reply-To: <200907221035.50025.arnd@arndb.de>
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
	<200907220005.27583.arnd@arndb.de>
	<4A66BEAD.3080404@gmail.com>
	<200907221035.50025.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009 10:35:49 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 22 July 2009, Jiri Slaby wrote:
> > No, I should have written this explicitly. I meant read* have a barrier,
> > whereas ioread* do not. Similarly for writes. Is this expected?
> > 
> > For example:
> > #define __raw_readl(a) (__chk_io_ptr(a), *(volatile u32 __force *)(a))
> > #define readl(a)       ({ u32 r_ = __raw_readl(a); mb(); r_; })
> > #define ioread32(a)    __raw_readl(a)
> 
> No, this looks like a bug. I would have expected
> 
> #define ioread32(a)    readl(a)
> 
> in this case. Also, ioread32 should actually multiplex between
> readl() and inl() based on the address token, as the code in
> lib/iomap.c does. It's probably easy enough to enable
> CONFIG_GENERIC_IOMAP on sh, and remove the ioread*/iowrite*
> macros from arch/sh/include/asm/io.h.

If your platform is purely MMIO based then ioread32 and readl can become
the same thing, which is much more efficient. Even if you have port based
devices that are mapped as MMIO surely its more efficient to do the
relevant address tweaking in the iomap not in the read ?

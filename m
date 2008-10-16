Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbYJPMTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbYJPMTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 08:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYJPMTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 08:19:12 -0400
Received: from elvis.franken.de ([193.175.24.41]:55668 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYJPMTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 08:19:11 -0400
Date: Thu, 16 Oct 2008 14:18:02 +0200
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: rtc-ds1286 and rtc-m48t35 need <linux/io.h>
Message-ID: <20081016121802.GA7248@alpha.franken.de>
References: <Pine.LNX.4.64.0810160927340.25608@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810160927340.25608@anakin>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 09:28:47AM +0200, Geert Uytterhoeven wrote:
> With m68k allmodconfig, I get:
> 
> | drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
> | drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw_readl'
> | drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
> | drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw_writel'
> | drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
> | drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'ioremap'
> | drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from integer without a cast
> | drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'iounmap'
> 
> and
> 
> | drivers/rtc/rtc-m48t35.c: In function 'm48t35_read_time':
> | drivers/rtc/rtc-m48t35.c:59: error: implicit declaration of function 'readb'
> | drivers/rtc/rtc-m48t35.c:60: error: implicit declaration of function 'writeb'
> | drivers/rtc/rtc-m48t35.c: In function 'm48t35_probe':
> | drivers/rtc/rtc-m48t35.c:168: error: implicit declaration of function 'ioremap'
> | drivers/rtc/rtc-m48t35.c:168: warning: assignment makes pointer from integer without a cast
> | drivers/rtc/rtc-m48t35.c:188: error: implicit declaration of function 'iounmap'
> 
> Include <linux/io.h> to get access to the I/O API.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thanks for fixing and sorry for that. I'll do more build tests in
the future to avoid that.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]

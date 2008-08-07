Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYHGHUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYHGHUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 03:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754490AbYHGHUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 03:20:18 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:38553 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbYHGHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 03:20:11 -0400
Date: Thu, 7 Aug 2008 09:20:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (8390 et al)
In-Reply-To: <20080806172148.7fac5999.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0808070918510.17614@anakin>
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
 <20080806172148.7fac5999.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2008, Randy Dunlap wrote:
> One randconfig ends with:
> 
> drivers/built-in.o: In function `wd_probe1':
> wd.c:(.init.text+0x6179): undefined reference to `NS8390p_init'
> make[1]: *** [.tmp_vmlinux1] Error 1

drivers/net/Makefile has:

obj-$(CONFIG_WD80x3) += wd.o 8390.o

So either wd_probe1() should call NS8390_init(), or obj-$(CONFIG_WD80x3)
should link with 8390p.o. Don't know which is the appropriate change
here (my gut feeling says the latter).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYHGM0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYHGM0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbYHGMYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:24:48 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53405 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754994AbYHGMYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:24:46 -0400
Date: Thu, 7 Aug 2008 10:29:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for August 6 (8390 et al)
Message-ID: <20080807102931.1bb0607d@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0808070918510.17614@anakin>
References: <20080806182828.6bfe0a16.sfr@canb.auug.org.au>
	<20080806172148.7fac5999.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0808070918510.17614@anakin>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 09:20:07 +0200 (CEST)
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Wed, 6 Aug 2008, Randy Dunlap wrote:
> > One randconfig ends with:
> > 
> > drivers/built-in.o: In function `wd_probe1':
> > wd.c:(.init.text+0x6179): undefined reference to `NS8390p_init'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> 
> drivers/net/Makefile has:
> 
> obj-$(CONFIG_WD80x3) += wd.o 8390.o
> 
> So either wd_probe1() should call NS8390_init(), or obj-$(CONFIG_WD80x3)
> should link with 8390p.o. Don't know which is the appropriate change
> here (my gut feeling says the latter).

Safest is the latter. The shared memory interface on the wd is full speed
8 or 16bit (depending on card/jumpers) but I'm not clear about the NIC.
Most of the performance hit is on the packet transfer which is private
methods on this device so using 8390p won't make a big difference on this
board anyway.

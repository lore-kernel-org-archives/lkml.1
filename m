Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbZERWpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbZERWpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 18:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZERWpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 18:45:41 -0400
Received: from sh.osrg.net ([192.16.179.4]:47251 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbZERWpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 18:45:40 -0400
Date: Tue, 19 May 2009 07:44:08 +0900
To: arnd@arndb.de
Cc: fujita.tomonori@lab.ntt.co.jp, jgarzik@pobox.com, hancockrwd@gmail.com,
       htejun@gmail.com, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200905181645.26305.arnd@arndb.de>
References: <200905172245.23774.arnd@arndb.de>
	<20090518194443R.fujita.tomonori@lab.ntt.co.jp>
	<200905181645.26305.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090519074355P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 19 May 2009 07:44:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009 16:45:24 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 18 May 2009, FUJITA Tomonori wrote:
> > 
> > NACK'ed, sorry.
> 
> I had no idea how hard it would get to fix a simple
> allyesconfig build error. This is the third time
> that a new approach to getting ATA to build on all
> platforms is gets a NAK...
> 
> > - these idndef tricks are really ugly and wrong.
> > - these functions are not generic at all.
> 
> I was trying to do two things at once:
> 
> - provide a default implementation for each function
>   that an architecture can override, therefore the
>   #ifdef magic.

I know what you tried with #ifdef but having something like '#define
dma_map_sg' in arch's dma-mapping.h is unacceptable.


> - Have a minimal working implementation of the API
>   that at least makes sense for architectures that
>   do not support DMA, but want to share some of the
>   code.

Well, it might make sense but we don't call architectures that don't
support DMA 'generic'.


> Ten of the existing architectures simply try do a
> linear mapping, and that should easily be possible
> in a generic way not too different from what I posted.

Your proposal doesn't work with arch/x86/kernel/pci-nommu.c, which
is trying a linear mapping, what you are talking about.


> Would you agree to a patch that works with the same
> code on e.g. arm, microblaze, mn10300 and sh and
> uses only a few #ifdefs?

Having such helper for a linear mapping might be helpful but your
approach is wrong.


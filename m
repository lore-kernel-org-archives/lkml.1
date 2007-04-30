Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbXD3O6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbXD3O6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXD3O6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:58:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43523 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755307AbXD3O6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:58:53 -0400
Date: Mon, 30 Apr 2007 16:02:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>, linux-kernel@vger.kernel.org
Subject: Re: Geode-GX1 processor in 2.6.21
Message-ID: <20070430160241.79efca76@the-village.bc.nu>
In-Reply-To: <20070430122022.GA9896@rhlx01.hs-esslingen.de>
References: <200704301251.05697.juergen127@kreuzholzen.de>
	<20070430122022.GA9896@rhlx01.hs-esslingen.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > In arch/i386/kernel/cpu/cyrix.c function geode_configure() tries to enable 
> > the "suspend on halt power saving feature". This is the line:
> > 
> > 	setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);

That will go wrong

> > #define setCx86(reg, data) do { \
> >          outb((reg), 0x22); \
> >          outb((data), 0x23); \
> > } while (0)
> > 
> > Maybe the compiler does the wrong thing if someone uses these macros in the 
> > same instruction?
> 
> Sounds quite likely.

The problem is the macro evaluates to

	outb(reg, 0x22);
	[Then the getCx86]
	outb(data, 0x23);

which isn't valid for 6x86 control. Looks like someone overoptimised it.

Either make it "inline" or split it up and it'll work

> Also, it would probably be good to convert these macros into inline functions
> in this header.

Agreed - they must be issued in order in the right way as they are CPU
level magic.

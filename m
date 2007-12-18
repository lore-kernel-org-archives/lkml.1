Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXLRKaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXLRKaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXLRK34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:29:56 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59016 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752479AbXLRK3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:29:55 -0500
Date: Tue, 18 Dec 2007 11:29:07 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Andrew Victor" <avictor.za@gmail.com>
Cc: "Remy Bohmer" <linux@bohmer.net>, linux-kernel@vger.kernel.org,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071218112907.609cc013@dhcp-252-066.norway.atmel.com>
In-Reply-To: <cd73a99e0712180208x73eb1095qbea96f1a9746298b@mail.gmail.com>
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	<3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com>
	<cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com>
	<3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	<3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	<3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
	<20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
	<3efb10970712171256v4230eb38q84d01f2d0d554935@mail.gmail.com>
	<20071217234932.GH23657@flint.arm.linux.org.uk>
	<20071218100724.3e79629e@dhcp-252-066.norway.atmel.com>
	<cd73a99e0712180208x73eb1095qbea96f1a9746298b@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 12:08:05 +0200
"Andrew Victor" <avictor.za@gmail.com> wrote:

> > #define at_readl(port, off)     __raw_readl((port)->membase + (off))
> > #define at_writel(v, port, off) __raw_writel(v, (port)->membase + (off))
> >
> > #define UART_PUT_CR(port, v)    at_writel(v, port, ATMEL_US_CR)
> > #define UART_PUT_MR(port, v)    at_writel(v, port, ATMEL_US_MR)  
> 
> I'd like to point out this relatively recent change to CodingStyle.
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dff4982f5cd4e30e2a140a3bca95d8814115bf5b
> 
> So I don't see a reason for complicating the code by adding additional
> macro's just to fit it in 80 column's.

Hmm...yes, I think that change to the CodingStyle makes sense. But I
guess the question is whether the old code "significantly increases
readability" and whether the new code "hides information".

I don't think so, but I don't feel all that strongly about it. I'd
actually prefer if we used at_writel() and at_readl() throughout the
code and killed those UART_PUT/UART_GET macros.

Haavard

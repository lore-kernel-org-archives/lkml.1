Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYGGVwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYGGVwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYGGVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:52:30 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48589 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755855AbYGGVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:52:29 -0400
Date: Mon, 7 Jul 2008 22:19:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: mchan@broadcom.com, dwmw2@infradead.org, bastian@waldi.eu.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
Message-ID: <20080707221950.3dfba435@the-village.bc.nu>
In-Reply-To: <20080707.143803.99767036.davem@davemloft.net>
References: <C27F8246C663564A84BB7AB34397724201E1494B50@IRVEXCHCCR01.corp.ad.broadcom.com>
	<1215421413.3189.199.camel@shinybook.infradead.org>
	<1215456981.5532.20.camel@dell>
	<20080707.143803.99767036.davem@davemloft.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Who in the world is going to actually want request_firmware() to find
> a firmware image other than the one which has been properly tested
> together with the driver by the driver maintainer?

That misses the point, intentionally I am sure. In the majority of cases
the firmware doesn't change between releases so shipping a billion copies
of is a pain in the butt.

> What "use case" is there other than the desire to seperate out the
> firmware in order to skirt the legal issues?

Not shipping lots of copies
Not leaving crap locked in kernel memory when it isn't needed
Letting vendors issue firmware updates (which especially in enterprise
space is a big issue and right now gets messy with compiled in firmware)

> I think it is, in fact, the driver maintainer's perogative of whether
> they want request_firmware() to be supported by their driver or not.
> It is they who have to deal with any possible fallout.

And their users and the distributors for whom it can cause enormous pain.

If the two are closely tied then it makes a lot of sense to keep them
tied, but that doesn't mean wasting a ton of kernel memory and bandwidth
and disk space in the process. Loading the firmware and insisting on a
specific version is quite civilised for a driver with such a tie.

(of course we had this argument over ten years ago about modules when
various authors couldn't be bothered to modularise their driver which
caused endless pain to the distributions and end users. Remember the
sound driver situation in early Red Hat. Mind you it got me a job there
fixing it ;))

Driver authors aren't God. There are other important considerations, but
for tg3 if that means 'wrong MD5sum, no load' then fine.


Alan

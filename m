Return-Path: <linux-kernel-owner+w=401wt.eu-S968950AbXFHLnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968950AbXFHLnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 07:43:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967393AbXFHLnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 07:43:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54772 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S966725AbXFHLnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 07:43:42 -0400
Date: Fri, 8 Jun 2007 12:48:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [SERIAL] Don't optimise away baud rate changes when BOTHER is
 used
Message-ID: <20070608124853.5fdfaee2@the-village.bc.nu>
In-Reply-To: <1181300467.2801.20.camel@pmac.infradead.org>
References: <20070523172739.1d3a918c@the-village.bc.nu>
	<1180012135.8303.89.camel@shinybook.infradead.org>
	<20070524144109.7bd0f4d0@the-village.bc.nu>
	<1180014338.8303.95.camel@shinybook.infradead.org>
	<20070524160559.54c2c639@the-village.bc.nu>
	<1181133010.4096.26.camel@pmac.infradead.org>
	<20070606160310.27d6d3b8@the-village.bc.nu>
	<1181150998.2785.13.camel@pmac.infradead.org>
	<20070607163808.19984208@the-village.bc.nu>
	<1181231421.2785.68.camel@pmac.infradead.org>
	<20070607225528.0d5e7b29@the-village.bc.nu>
	<1181254517.20322.6.camel@shinybook.infradead.org>
	<20070607235441.17dbd5cc@the-village.bc.nu>
	<1181300467.2801.20.camel@pmac.infradead.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It works fine. The only problem is that if I set a _standard_ baud rate
> with BOTHER and then read it back with something that doesn't grok
> BOTHER, I get it back just as I set it.

That seemed to me to be the right thing to do.

> It might be better if it was returning B38400, rather than BOTHER.
> Should we be using tty_termios_encode_baud_rate() for TCGETS()?

You can't really do that as you get weird behaviour then when people do

	tcgetattr
		|= BOTHER;
		speed = 19200;
	tcsetattr

later in the same app

	tcgetattr
		speed = 38400
	tcsetattr

knowing that they set BOTHER already.

I guess you could add both ioctl sets anyway but the plan longer term is
for glibc tcsetattr/getattr to do the right thing with the new ioctls in
all cases, as the glibc interface already provides speed fields.

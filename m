Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbYAQMGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbYAQMGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYAQMF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:05:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59515 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952AbYAQMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:05:58 -0500
Date: Thu, 17 Jan 2008 12:02:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: "David P. Reed" <dpreed@reed.com>, David Woodhouse <dwmw2@infradead.org>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080117120227.3d09baf5@lxorguk.ukuu.org.uk>
In-Reply-To: <478EF4C9.8030406@davidnewall.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<200801081810.58904.linux@rainbow-software.org>
	<4783B1B2.6070005@reed.com>
	<200801081838.16241.linux@rainbow-software.org>
	<4783C4A6.9060402@reed.com>
	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>
	<4783CBD9.7020709@reed.com>
	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>
	<47845972.9090803@zytor.com>
	<1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
	<47854916.4080703@reed.com>
	<1200015388.6192.22.camel@bodhitayantram.eng.vmware.com>
	<4786DD05.20804@keyaccess.nl>
	<47877ECD.9060408@reed.com>
	<1200347847.2647.97.camel@shinybook.infradead.org>
	<478BE08B.3090306@reed.com>
	<478E1668.9040404@davidnewall.com>
	<20080116145515.6d84dc7b@lxorguk.ukuu.org.uk>
	<478E57C8.2080403@davidnewall.com>
	<20080116200829.26040351@lxorguk.ukuu.org.uk>
	<478EF4C9.8030406@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is a timing issue, isn't it?  How are we synchronising, other than
> by delaying for a (bus-dependant) period?  The characteristics of each
> bus are known so a number can be assigned for "one bus cycle", without
> having to use the bus.

The characteristics of the bus are not known. It could be anything
between 6 and about 16MHz. The way you read the bus clock is system
dependant.

The underlying problem is really that over time some of the hardware has
moved from the ISA world into the chipsets. That is why I sent Ingo the
patches for inb_pit/inb_pic and to split ISA 8390 and non ISA 8390
support. Someone has to tackle the CMOS but we are then in a position to
relegant port 0x80 timing use to ISA systems where it is fine.

Alan

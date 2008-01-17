Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbYAQPyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbYAQPyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYAQPyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:54:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48515 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbYAQPyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:54:11 -0500
Date: Thu, 17 Jan 2008 15:51:07 +0000
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
Message-ID: <20080117155107.248e43e2@lxorguk.ukuu.org.uk>
In-Reply-To: <478F59CC.8050907@davidnewall.com>
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
	<20080117120227.3d09baf5@lxorguk.ukuu.org.uk>
	<478F59CC.8050907@davidnewall.com>
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

> In the early days of clone PCs, as you know but perhaps many on this
> list might not, the bus speed could be changed, but this was
> user-selectable.  For such a machine, delay values can be pre-calculated
> for each bus speed, and a kernel parameter set accordingly.  Or are you
> saying that the characteristics of the bus on a given machine vary for
> reasons other than user selection?

They vary based on the CPU clock, the dividers from PCI to ISA on PCI
based boxes, and on the ISA only ones often on the CPU speed.

Unfortunately the way you control that divider or read it is chipset
specific. Nor would it be reasonable to expect the end user to set it.

For PC/104 systems the same applies today.

> The question is, for a given machine, can we determine a delay value
> instead of using a junk I/O?

The question (for ISA peripherals) is "why bother", and with the 8390
patch there are one or two dubious PCI driver users of _p left but not
much else that isn't ISA or chipset logic. The question for chipset logic
where it has become integrated is "can we get rid of it for some devices,
if not what can we use instead"

Alan

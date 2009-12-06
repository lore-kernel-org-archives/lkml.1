Return-Path: <linux-kernel-owner+w=401wt.eu-S933186AbZLFJte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186AbZLFJte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 04:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbZLFJta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 04:49:30 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:33309 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756156AbZLFJt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 04:49:29 -0500
Date: Sun, 6 Dec 2009 10:49:25 +0100
From: Marc Zyngier <maz@misterjones.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Eric Miao <eric.y.miao@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the pcmcia tree with the pxa tree
Message-ID: <20091206104925.5f9107b4@taxman.wild-wind.fr.eu.org>
In-Reply-To: <20091130094813.GC1638@n2100.arm.linux.org.uk>
References: <20091130131627.8ccc6033.sfr@canb.auug.org.au>
	<f17812d70911291917y2aeebbberbf31775491f0df4f@mail.gmail.com>
	<20091130091007.7a5fd554@hina.wild-wind.fr.eu.org>
	<f17812d70911300016q1e729569k8c72deb704e3a658@mail.gmail.com>
	<20091130102444.4ebc0a45@life-in-the-fast-lane>
	<20091130094813.GC1638@n2100.arm.linux.org.uk>
Organization: Metropolis -- Nowhere
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 77.200.100.194
X-SA-Exim-Rcpt-To: linux@arm.linux.org.uk, eric.y.miao@gmail.com, sfr@canb.auug.org.au, linux@dominikbrodowski.net, linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 09:48:13 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

Hi Russell,

> What would be a better idea is to rework the driver once my changes
> have hit.  If you need to pass additional data around, you can do it
> like this:

Now that your changes are in Linus' tree, I started looking at
restructuring my code. I sense a small problem though:

[...]
> 	for (i = 0; i < nr; i++) {
> 		skts[i].skt.nr = i;
> 		skts[i].skt.ops = &my_ops;
> 		skts[i].skt.socket.owner = THIS_MODULE;
> 		skts[i].skt.socket.parent = &dev->dev;
> 		skts[i].skt.socket.pci_irq = the_socket_irq;
> 		ret = pxa2xx_drv_pcmcia_add_one(&skts[i].skt);

Unless I'm mistaken, it seems that pxa2xx_drv_pcmcia_add_one() doesn't
call pxa2xx_configure_sockets(), leaving the sockets disabled.

There is several ways to solve this one:
- Add the call to pxa2xx_configure_sockets() to _add_one()
- Do the MECR access in the pxa2xx_viper driver,
- export pxa2xx_configure_sockets() and do the call locally.

What would be your preferred solution?

	M.
-- 
I'm the slime oozin' out from your TV set...

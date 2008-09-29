Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbYI2JUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbYI2JUs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYI2JUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:20:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40892 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751594AbYI2JUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:20:40 -0400
Date: Mon, 29 Sep 2008 10:20:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: introduce users of ioremap_pcibar()
Message-ID: <20080929102018.65bbaa40@lxorguk.ukuu.org.uk>
In-Reply-To: <20080929072643.GA28871@colo.lackof.org>
References: <20080926163641.288bf868@infradead.org>
	<20080926163718.32f0867e@infradead.org>
	<20080929072643.GA28871@colo.lackof.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FTR, I like this interface better since most drivers use ioremap() instead
> of ioremap_nocache(). They generally should be using the latter.

And pci_iomap is cleaner still. Plus pcim_iomap does resource tracking so
all the masses of special case error code/cleanup can get cut down.

> Is there any easy way to tell if the device driver should be using
> uncached mappings vs cacheable mappings?
> (Just from looking at the source code)

There isn't one.

> For storage/networking/audio cards I'm comfortable with the generalization
> that they all should use uncacheable mappings (I'm sure there are some
> exceptions.) I'm not with video devices.

There are exceptions - I2O for example and there are other cards that use
write merging when possible beyond video. Also btw vidoe depends on the
chip - if you cache/write merge the framebuffer on a Voodoo 1/2 card you
must be in 24/32bit video modes for example.

Generally though PCI = controlled by hardware = uncached

Alan

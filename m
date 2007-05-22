Return-Path: <linux-kernel-owner+w=401wt.eu-S934446AbXEVOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446AbXEVOu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbXEVOuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 10:50:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50160 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754958AbXEVOuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 10:50:19 -0400
Date: Tue, 22 May 2007 15:54:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Jeff Garzik" <jeff@garzik.org>,
       "Jesse Barnes" <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [RFC] enhancing the kernel's graphics subsystem
Message-ID: <20070522155439.20bf509f@the-village.bc.nu>
In-Reply-To: <9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
References: <200705171423.46748.jesse.barnes@intel.com>
	<465228E2.1030405@garzik.org>
	<9e4733910705211726q38be6843ndac49f8adc25aad0@mail.gmail.com>
	<200705211856.56228.jbarnes@virtuousgeek.org>
	<9e4733910705220727t605f2522tc4eb97257735c0fb@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> you display text in graphics mode entirely in kernel context. The
> driver should also attempt to stop the GPU to try and make sure it
> doesn't erase the OOPS display.

If we know how yes. Probably the X server needs to provide us with a
simple list of operations to perform or failing that write 128K of null
to the display then print the characters (the 128K should ensure any
running FIFO for commands is stuffed and we get back to the framebuffer)

> Another simple thing that needs to be built is a mechanism to run the
> VBIOS in x86 mode when the driver is first loaded. This can be

We don't want to touch the video bios for most cards, its not as good as
the X mode switcher code, nor for that matter does it work in a lot of
cases as they use IRQ and DMA functions sometimes.

Alan

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753956AbYL3PFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbYL3PFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYL3PFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:05:36 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:32987 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbYL3PFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:05:35 -0500
Date: Tue, 30 Dec 2008 16:05:32 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Per Andreas Gulbrandsen <theperan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Question about several drivers for one physical device
In-Reply-To: <164c42ea0812300443m6d034108h56ca71c86e52a641@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0812301604170.14380@anakin>
References: <164c42ea0812300443m6d034108h56ca71c86e52a641@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Per Andreas Gulbrandsen wrote:
> I have two drivers that both use the same device, an FPGA connected
> via pci. These two pci drivers represent different functionality in
> the FPGA, and they each have it's own BAR. My problem is that I can't
> get these two drivers to correctly initialize. Only the first one
> loaded actually finds the device (which one of the two doesn't
> matter). The second driver I load never has it's probe method run, and
> so it doesn't initialize correctly. I am aware that integrating these
> two drivers in one module is a possiblity, but since these two drivers
> aren't really related (except that they both drive an FPGA) I would
> like to keep them as two separate modules. My question is really: Is
> there another way to do this, or will I have to integrate the two so
> they share init/exit/probe methods?

You can create a third driver that binds to the PCI device and creates a new
bus type with two devices. Then the two other drivers can bind to the latter
two devices.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

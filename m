Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbYDNMoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbYDNMoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbYDNMoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:44:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57322 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752267AbYDNMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:44:12 -0400
Date: Mon, 14 Apr 2008 13:39:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kathy Frazier" <kfrazier@daetwyler-rd.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Talking to parallel port in 2.6 kernel without using parport
Message-ID: <20080414133937.7080d30d@core>
In-Reply-To: <009501c89e28$3d7530f0$b85f92d0$@com>
References: <009501c89e28$3d7530f0$b85f92d0$@com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ***** However, I am still unable to open my device.  Can someone tell me
> what I am missing?  
> What do I need to do to talk to the parallel port myself and NOT go through
> parport?

You should go through parport. The parport layer is there for a reason.
You drive on the road not through fields (even if shorter distances)
please show the same respect for the kernel and your users (plus it'll
make your job easier).

If you need to hog the device because it doesn't follow 1284 or other
sharing standards the parport_register_device can be called with
PARPORT_DEV_EXCL in flags, which means you want to sit on it.

So for something like a standard PC built in port (for the little time
they have left before they go away in hardware..)

	struct parport *p = parport_find_base(0x378 /* etc */);
	
	parport_register_device(p, "mywidget", NULL,
		my_irq_handler, PARPORT_DEV_EXCL, &mystruct)
	parport_enable_irq(p);

where mystruct is a private object that will be passed back to you in the
callbacks. If you don't use the IRQ then don't call parport_enable_irq
and my_irq_handler can also be NULL.

Alan


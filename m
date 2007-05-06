Return-Path: <linux-kernel-owner+w=401wt.eu-S932184AbXEFMYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184AbXEFMYz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 08:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbXEFMYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 08:24:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57315 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbXEFMYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 08:24:54 -0400
Date: Sun, 6 May 2007 13:28:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Antonino Ingargiola" <tritemio@gmail.com>
Cc: "Oliver Neukum" <oliver@neukum.org>, "Paul Fulghum" <paulkf@microgate.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
 possible bug]
Message-ID: <20070506132849.62e1e218@the-village.bc.nu>
In-Reply-To: <5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	<1178381287.3379.8.camel@x2>
	<20070505173647.544f6707@the-village.bc.nu>
	<200705052007.16742.oliver@neukum.org>
	<20070505225241.54a5d01d@the-village.bc.nu>
	<5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> However, whatever policy the buffer uses, the fundamental point it's that
> when I flush the input buffer I should be sure that each byte read
> after the flush is *new* (current) data and not old one. This because

Define "new" and "old" in this case. I don't believe you can give a
precise definition or that such a thing is physically possible.

> when the input stream can be stopped I can check that there are 0 byte
> in the buffer, but when the stream can't be stopped I must use a
> flush-and-sleep (multiple times) heuristic before I can read a single
> *reliable* byte.

The hardware itself has buffers at both ends of the link, there may be
buffers in modems, muxes and the like as well. We can certainly flush
input buffers in the kernel but it isn't clear we can always do so at the
hardware level, let alone at the remote end or buffers on devices on the
link.

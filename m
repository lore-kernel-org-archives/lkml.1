Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbXHHIkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbXHHIkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbXHHIkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:40:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55896 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751436AbXHHIk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:40:29 -0400
Date: Wed, 8 Aug 2007 09:47:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Chapman <hchapman-linux-kernel@3gfp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial inter-character timeout usage with async io
Message-ID: <20070808094748.72c4ff22@the-village.bc.nu>
In-Reply-To: <46B92869.4000400@3gfp.com>
References: <46B8F7FE.3090904@3gfp.com>
	<20070808021147.10d0e752@the-village.bc.nu>
	<46B92869.4000400@3gfp.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A Linux program is connected via serial port to some other serial device
> using asynchronous I/O and the other serial device sends a 150 byte
> sequence to the Linux program. The Linux program will receive 18
> intermediate SIGIOs (one for each 8-byte threshold interrupt generated
> by the UART) followed by 1 final inter-character timeout (when the UART
> FIFO contains the last 6 bytes). The program upon each SIGIO would
> read() 8 bytes and do some parsing of the data buffer and realize that
> the whole sequence had not yet been received. Repeat 17 more times in
> this example.

That seems a particularly odd way to implement block I/O. Just use a
thread for this and the VMIN/VTIME functionality in the n_tty layer -
that is why it is there.

> I agree. However, the inter-character timeout is present (to the best of
> my knowledge and google's) in all serial UARTs from the 16550A onward
> (starting around 1994 and Windows 3.1). Before that, the IIR timeout

Almost all our drivers are not 16550A. A large part of the serial world
is now USB and current PCs (especially laptops) often don't include any
16550A devices at all.

Your changes seem to be - hardware specific, not supportable by many
devices, and designed to improve a particularly crazy way of handling the
I/O in the first place. That doesn't make a good candidate for the
upstream kernel.

Alan

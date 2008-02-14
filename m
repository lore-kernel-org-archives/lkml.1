Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbYBNToj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbYBNToj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbYBNToa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:44:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45183 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757118AbYBNTo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:44:29 -0500
Date: Thu, 14 Feb 2008 19:36:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214193637.5df1c205@core>
In-Reply-To: <47B482B4.9010208@davidnewall.com>
References: <47B30291.2040905@davidnewall.com>
	<20080214050211.GB1432@kroah.com>
	<47B40918.20206@davidnewall.com>
	<20080214121026.16a9c510@core>
	<47B482B4.9010208@davidnewall.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's a very good point.  Even so: on the 2.4 driver, write_room isn't
> implemented (refer to a previous message by Alan); and in 2.6, a 1k
> buffer is built into the driver, with nothing to prevent it being sent
> when the hardware buffer fills.  These could be bugs in the two versions

Which isn't a bug if the hardware handles it internally as most does.

> of pl2303, if you like; in fact I suppose they are; but there's a wider
> problem: The same weakness can be found in aircable.c, airprime.c,
> cyberjack.c, cypress_m8.c (I think), empeg.c, ftdi_sio (I think),
> io_ti.c, and that's where I stop checking, and declare it's widespread.

Careful - a lot of hardware handles this properly itself, you simply
don't get the URB completing until its all done.

> now that you've mentioned it, I can't see that anything to stop the
> driver from overflowing the internal buffer, which is very perplexing. 
> Would that be right?  That seems a pretty dramatic weakness; how do you
> write a large report to a slow printer without losing data?

pl2303 implements write room in 2.6 (and 2.4 I don't care about at all)
so the driver appears entirely correct in respect of its internal buffer
management. Someone with docs will have to comment on whether it handles
flow control in firmware or needs pl2303_send to do further checks as you
propose.

Alan

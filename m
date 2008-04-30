Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbYD3QiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbYD3QiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYD3QiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:38:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50003 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755342AbYD3QiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:38:02 -0400
Date: Wed, 30 Apr 2008 17:28:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 5/7] PPS: serial clients support.
Message-ID: <20080430172855.6d2e81a6@core>
In-Reply-To: <20080430114107.GE3002@enneenne.com>
References: <1207851751-25703-2-git-send-email-giometti@linux.it>
	<1207851751-25703-3-git-send-email-giometti@linux.it>
	<1207851751-25703-4-git-send-email-giometti@linux.it>
	<1207851751-25703-5-git-send-email-giometti@linux.it>
	<1207851751-25703-6-git-send-email-giometti@linux.it>
	<20080410210918.3be98868@core>
	<20080411075515.GH26777@enneenne.com>
	<20080411092840.3cc4de67@core>
	<20080411134724.GF2160@csclub.uwaterloo.ca>
	<20080411154652.4852b6d4@core>
	<20080430114107.GE3002@enneenne.com>
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

> if I add a dedicated line discipline to register/unregister the PPS
> source and I leave the pps_event management into
> uart_handle_dcd_change() function, it can be acceptable?

Keep the two things apart.

uart_handle_dcd_change looks a good basis for the UART layer support for
drivers serial
an LDISC looks right for the top layer

We just need the bits in the middle right. I've added the serial layer
pass through for the set_ldisc() interface so that bit is done. Probably
the main thing we need is to add  tty->ldisc.dcd_change() for reporting
DCD change back to the line discipline. We could queue it as a TTY_ event
but I assume you need it immediately not queued ?

> The uart_handle_dcd_change() is generic and I need the DCD status to
> correctly manage the pps_event. The USB layer is not useful for PPS
> stuff

Not every character driver uses drivers/serial or USB. That is fine. What
I care about is that you *could* add PPS support to another serial driver
cleanly, not that it is done immediately. What matters is the interface,
the rest will follow.

Alan

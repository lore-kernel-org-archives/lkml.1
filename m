Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbXFTXMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbXFTXMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 19:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXFTXMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 19:12:10 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51171 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751751AbXFTXMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 19:12:09 -0400
Date: Thu, 21 Jun 2007 00:17:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: oops with USB serial irda adapter
Message-ID: <20070621001750.283f48ac@the-village.bc.nu>
In-Reply-To: <4679A74F.4010901@redhat.com>
References: <4679A74F.4010901@redhat.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 18:16:47 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> [https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=241598]
> 
> Oops happens here in kernel 2.6.20.11:
> drivers/usb/serial/ir-usb.c, line 557:
> 
>                 /* Notify the tty driver that the termios have changed. */
>                 port->tty->ldisc.set_termios(port->tty, NULL);
> 
> (ldisc.set_termios is NULL)

Yeah the driver is full of bugs - its also broken for the way its
set_termios tries to play 'guess it the properties have changed' and gets
speed checks wrong, how it snoops the baud bits and some other stuff it
does.

If you make it look like a real serial driver it ought to work fine. If
you've got hardware I can send you test patches ?

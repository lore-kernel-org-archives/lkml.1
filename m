Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbYBNMDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbYBNMDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbYBNMDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:03:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60382 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756416AbYBNMDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:03:43 -0500
Date: Thu, 14 Feb 2008 11:55:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: David Newall <davidn@davidnewall.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Handshaking on USB serial devices
Message-ID: <20080214115550.7aa7c98b@core>
In-Reply-To: <20080214050211.GB1432@kroah.com>
References: <47B30291.2040905@davidnewall.com>
	<20080214050211.GB1432@kroah.com>
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

On Wed, 13 Feb 2008 21:02:11 -0800
Greg KH <greg@kroah.com> wrote:

> On Thu, Feb 14, 2008 at 01:15:37AM +1030, David Newall wrote:
> > Consider a USB-attached serial port that is set to do RTS/CTS (or
> > DSR/DTR) handshaking: What stops the kernel sending more data to it when
> > the remote end lowers CTS (or DTR)?
> 
> The tty layer should look at the proper flags and not send data on to
> the driver in this kind of instance.

For outgoing data the tty ldisc will check the available room indicators
the driver provides and stop when they fill. We don't want to be directly
involved in flow control if possible as most decent hardware does RTS/CTS
handshaking in hardware (except in the PC world).

If your hardware is dumb (ie you do RTS/CTS in software) then you need to
track the CTS state and termios bits (in your set_termios method) and
transmit according to flow control rules, letting the buffer fill up
otherwise.

Alan

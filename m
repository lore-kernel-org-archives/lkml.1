Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZHMTte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZHMTte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755596AbZHMTtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:49:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57289 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755701AbZHMTtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:49:10 -0400
Date: Thu, 13 Aug 2009 20:50:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David VomLehn <dvomlehn@cisco.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Combine two one-character CR-LF writes into one
 two-character write for O_ONLCR
Message-ID: <20090813205018.4d781c74@lxorguk.ukuu.org.uk>
In-Reply-To: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
References: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> do_output_char() function uses the struct tty_operations function write_room()
> to determine whether it is possible to write two characters. It uses
> tty_put_char() for each character which, for the USB generic serial driver,
> translates into a write() for each character. For the USB generic serial
> driver the value returned by write_room() only applies to the next write().

The USB serial driver is broken, fix it instead. It's not even hard to
fix.

> +			tty->ops->write(tty, crlf, ARRAY_SIZE(crlf));
> +			return ARRAY_SIZE(crlf);

Emphatic NAK. Someone needs to actually fix the broken USB drivers for
once. This is just one example of where the device will go kersplat if its
broken, others include things like losing flow control.
 

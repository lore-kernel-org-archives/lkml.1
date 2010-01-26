Return-Path: <linux-kernel-owner+w=401wt.eu-S1753787Ab0AZNij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab0AZNij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816Ab0AZNii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:38:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43509 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590Ab0AZNih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:38:37 -0500
Date: Tue, 26 Jan 2010 13:39:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, gregkh@suse.de,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: Re: request for assistance:  accessing ttys from kernel space
Message-ID: <20100126133958.49e660a5@lxorguk.ukuu.org.uk>
In-Reply-To: <20100126024049.GQ21492@const.famille.thibault.fr>
References: <20100126020203.GA23551@linux1>
	<20100126021306.16809e71@lxorguk.ukuu.org.uk>
	<20100126024049.GQ21492@const.famille.thibault.fr>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is there another way to set up a line discipline from the kernel itself
> without the need from userland intervention, even before any / is
> mounted?

There is no fundamental reason you can't do that once the tty object
itself exists. Currently there is no path for doing it in the kernel.

> Maybe the early serial console support layer could be extended a bit so
> speakup can use it first during the boot?  For now it's quite tied to
> just printing the printk logs. drivers/accessibility/braille_console.c
> does manage do make something else, but it happens that the
> serial_core.c's uart_console_write puts additional \rs before \ns, which
> can be a problem.
> 
> Also, for proper speech flow, speakup would need to be able to read
> characters from the device.

Some debugger folk want that too.

I've been trying to get to the point where each tty consists of a
tty_struct which is the instance of an opened tty device, and a tty_port
which is a common struct instance for each physical port. That then has
some operations attached to it.

However at the moment most of the operation paths are not pushed into
tty_port, not every device yet has a tty_port and many of the paths that
need pushing into tty_port reference material that is in struct tty but
probably also needs moving.

So there is an awful lot of work to be done.

I guess the quick 'get it working' hack for the moment would be to add a
'raw' flag to the console output routines and use those (where raw=1
would mean 'don't tamper with the formatting')

Alan

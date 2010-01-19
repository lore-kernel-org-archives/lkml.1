Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838Ab0ASOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab0ASOZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697Ab0ASOZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:25:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44320 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753277Ab0ASOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:25:31 -0500
Date: Tue, 19 Jan 2010 14:26:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial
 writes" causes gobi_loader to hang
Message-ID: <20100119142657.02856d15@lxorguk.ukuu.org.uk>
In-Reply-To: <201001191457.00504.oliver@neukum.org>
References: <20100117025535.GB7045@srcf.ucam.org>
	<201001191420.29652.oliver@neukum.org>
	<20100119132934.0c1688f7@lxorguk.ukuu.org.uk>
	<201001191457.00504.oliver@neukum.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The log shows no call to usb_serial_generic_write_room()
> Do you consider this a bug in the tty layer?

Actually this all makes sense because of where it was hanging. A reply of
0 to the tty->ops->write will cause it to either return (O_NONBLOCK) or
sleep in the n_tty write code waiting for a write_wait wakeup
(tty_wakeup(tty))

So the fix does indeed look correct.

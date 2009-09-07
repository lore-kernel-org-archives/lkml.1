Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbZIGPIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbZIGPIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZIGPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:08:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45444 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753511AbZIGPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:08:22 -0400
Date: Mon, 7 Sep 2009 11:08:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Miklos Szeredi <miklos@szeredi.hu>
cc: alan@linux.intel.com, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: WARNINGs in usb-serial.c
In-Reply-To: <E1MkcAx-0000Mx-Be@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.44L0.0909071101010.7175-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Sep 2009, Miklos Szeredi wrote:

> Here's a reproducible Oops on that kernel when trying to connect with
> wvdial.  This is a regression compared to -linus, where wvdial works
> (most of the time anyway).
> 
> I can bisect it if it's not immediately obvious what is happening...

I don't think bisecting will help (or is even possible).

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
> IP: [<ffffffffa020709c>] serial_chars_in_buffer+0x47/0x5f [usbserial]

It's difficult to say without an assembly listing, but I gather that
serial_chars_in_buffer() is seeing port->serial == NULL.  Can you
verify this?

This is unexpected, because port->serial is initialized in
usb_serial_probe() and is not set to NULL until destroy_serial(), after
which port should not be used at all.  Can you add a

#define DEBUG

line at the start of usb-serial.c (before the #include lines) so that
we can tell if destroy_serial() is getting called too early?  When you
do, post the dmesg log showing everything from the time you start
running your test.

Alan Stern


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760738AbZBMP1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738AbZBMP1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760291AbZBMP07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:26:59 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44187 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759835AbZBMP05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:26:57 -0500
Date: Fri, 13 Feb 2009 10:26:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       <mm-commits@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       USB list <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: dead USB devices after resume [mmotm 2009-02-10-16-35]
In-Reply-To: <49954E04.6090008@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0902131014320.3343-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Feb 2009, Jiri Slaby wrote:

> > You might want to build a kernel with CONFIG_USB_DEBUG enabled.  The 
> > extra debugging information should help find the problem.
> 
> Here comes the resume part (including unplug, replug). I suspect auto-suspend?

I don't think autosuspend is the issue, because normally neither
keyboards nor mice get autosuspended.  In fact the log appears to be
perfectly correct; I don't see any errors in it.

So the problem must be lower down, such as in the usbhid driver.  The 
best way to track this is to use usbmon.  Here's what I'd like you to 
do:

	After booting, unplug the mouse/keyboard.  Then do
	"dmesg -c >/dev/null" to clear the kernel log buffer.

	Start up usbmon, looking at bus 6 (or whichever bus the
	mouse/keyboard was plugged into).  If you don't have any
	other keyboard to use for this then do it via a network
	login.

	Plug in the mouse/keyboard.  Press a key to verify that
	the keyboard is working, but otherwise don't use either
	device.

	Go through a suspend/resume cycle (again using the network
	link if you don't have another keyboard).

	Type another key to verify that the keyboard isn't working.

	Unplug the keyboard/mouse and plug them back in.

	Type a third key to verify that now the keyboard is
	working again.

	Stop the usbmon trace and post the resulting file along
	with the dmesg log.

Alan Stern


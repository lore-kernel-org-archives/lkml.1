Return-Path: <linux-kernel-owner+w=401wt.eu-S1760811AbXEYJwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760811AbXEYJwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXEYJwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:52:22 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56674 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbXEYJwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:52:21 -0400
Date: Fri, 25 May 2007 11:52:09 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Zan Lynx <zlynx@acm.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] USB input death then system freeze
In-Reply-To: <Pine.LNX.4.64.0705251143480.8531@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0705251151000.8531@twin.jikos.cz>
References: <1180031903.4309.6.camel@rousalka.dyndns.org>
 <Pine.LNX.4.64.0705251143480.8531@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007, Jiri Kosina wrote:

> This is now handled in bugzilla [1]. Zan Lynx also reported this problem, 
> and from the HID_DEBUG output he provided is evident that it is caused by 
> HID layer receiving a report of size 4294967284 (which corresponds to 
> urb->actual_length of the URB received from USB core).

For completness, this is a snippet of HID_DEBUG output that Zan sent me in 
a private mail, which demonstrates the urb->actual_length badness:

...
drivers/hid/hid-core.c: report (size 3) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 3) =  00 00 00
hid-debug: input Keyboard.00e0 = 0
hid-debug: input Keyboard.00e1 = 0
hid-debug: input Keyboard.00e2 = 0
hid-debug: input Keyboard.00e3 = 0
hid-debug: input Keyboard.00e4 = 0
hid-debug: input Keyboard.00e5 = 0
hid-debug: input Keyboard.00e6 = 0
hid-debug: input Keyboard.00e7 = 0
drivers/hid/hid-core.c: report (size 4294967284) (unnumbered)
drivers/hid/hid-core.c: report 0 (size 4294967284) =
hid-debug: input Keyboard.00e0 = 0
hid-debug: input Keyboard.00e1 = 0
hid-debug: input Keyboard.00e2 = 0
hid-debug: input Keyboard.00e3 = 0
hid-debug: input Keyboard.00e4 = 0
hid-debug: input Keyboard.00e5 = 0
hid-debug: input Keyboard.00e6 = 0
hid-debug: input Keyboard.00e7 = 0
drivers/hid/hid-core.c: report (size 6) (numbered)
drivers/hid/hid-core.c: report 2 (size 5) =  00 00 00 00 00
hid-debug: input Button.0001 = 0
hid-debug: input Button.0002 = 0
hid-debug: input Button.0003 = 0
hid-debug: input Button.0004 = 0
hid-debug: input Button.0005 = 0
hid-debug: input Button.0006 = 0
hid-debug: input Button.0007 = 0
hid-debug: input Button.0008 = 0
hid-debug: input GenericDesktop.X = 0
hid-debug: input GenericDesktop.Y = 0
hid-debug: input GenericDesktop.Wheel = 0
Hangcheck: hangcheck value past margin!
drivers/hid/usbhid/hid-core.c: input irq status -75 received

...

-- 
Jiri Kosina

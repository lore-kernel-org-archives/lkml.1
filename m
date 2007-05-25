Return-Path: <linux-kernel-owner+w=401wt.eu-S1761143AbXEYJuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761143AbXEYJuj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 05:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760722AbXEYJub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 05:50:31 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56537 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760677AbXEYJua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 05:50:30 -0400
Date: Fri, 25 May 2007 11:50:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net, Zan Lynx <zlynx@acm.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [BUG] USB input death then system freeze
In-Reply-To: <1180031903.4309.6.camel@rousalka.dyndns.org>
Message-ID: <Pine.LNX.4.64.0705251143480.8531@twin.jikos.cz>
References: <1180031903.4309.6.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Nicolas Mailhot wrote:

> Most recent kernel where this bug did *NOT* occur: pre 2.6.21 mm
> kernels, non-mm 2.6.22-rc2
> Distribution: Fedora Devel
> Hardware Environment: EHCI input on external powered hub with CK804 mainboard
> Software Environment: Nothing specific
> Problem Description:
> After a few hours of activity 2.6.22-rc1-mm1 and 2.6.22-rc2-mm1 will lose USB
> HID INPUT (keyboard or mice with no priority), then the system will freeze
> drivers/hid/usbhid/hid-core.c: input irq status -75 received

This is now handled in bugzilla [1]. Zan Lynx also reported this problem, 
and from the HID_DEBUG output he provided is evident that it is caused by 
HID layer receiving a report of size 4294967284 (which corresponds to 
urb->actual_length of the URB received from USB core).

Alan Stern suggested to reproduce the bug with CONFIG_USB_DEBUG and also 
collect the usbmon trace, so that we can clearly understand what happens.

I am now inclined to think that this is caused by USB core messing up the 
URB somehow, HID core seems to receive the URB with already bogus values.

[1] http://bugzilla.kernel.org/show_bug.cgi?id=8535

Thanks,

-- 
Jiri Kosina

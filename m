Return-Path: <linux-kernel-owner+w=401wt.eu-S1760211AbYBNXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211AbYBNXK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755712AbYBNXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:10:10 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:63358 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbYBNXKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:10:08 -0500
Date: Thu, 14 Feb 2008 18:09:57 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Handshaking on USB serial devices
In-reply-to: <m3k5l7uprm.fsf@maximus.localdomain>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802141809.57544.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <47B30291.2040905@davidnewall.com>
 <200802141116.14722.gene.heskett@gmail.com>
 <m3k5l7uprm.fsf@maximus.localdomain>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008, Krzysztof Halasa wrote:
>Gene Heskett <gene.heskett@gmail.com> writes:
>> Apparently they do not Alan, the pl2303 in particular is a problem child,
>> throwing several lost com errors a day when doing nothing more strenuous
>> than talking to my belkin UPS from apcupsd, very small packets there, 20
>> bytes I believe at several second intervals.
>
>Is your UPS using "modern" hardware handshaking (CTS = PC can send,
>with RTS practically always asserted)? Or perhaps the "old",
>"half-duplex" V.24-style (RTS asserted before TX and then waiting for
>CTS)?
>
>Are you sure it uses hw handshaking at all? Most (all?) UPSes I used
>had only TxD and RxD (for RS-232).

ATM, its plugged into a USB port, but for some reason was not recognized at 
the last bootup.  And I just installed the rpm for a newer version of apcupsd 
when I found apcupsd was logging an error and exiting about 2 seconds after 
being started by the 'service' utility.  So I'm a bit puzzled.  From the 
dmesg at boot time there is no mention of it being found, from the current 
dmesg, after unplugging the USB cable from the back of it and replugging it 
about a second later, and got this:

[180077.652645] usb 1-1.1: USB disconnect, address 6
[180080.387154] usb 1-1.1: new low speed USB device using ehci_hcd and address 
11
[180080.586706] usb 1-1.1: configuration #1 chosen from 1 choice
[180081.339062] hiddev97hidraw3: USB HID v1.11 Device [Belkin  Belkin UPS] on 
usb-0000:00:02.2-1.1

As to why it wasn't found at bootup, call me bumfuzzled.  Uptime is about 2d 
3h and I wasn't aware it wasn't running until I wanted to see if anything was 
different about how it handled my belkin, which is not well, but it does take 
care of the graceful shutdown.

I just found this:
[root@coyote ~]# dmesg |grep -A2 'address 6'
[   30.990194] usb 1-1.1: new low speed USB device using ehci_hcd and address 
6
[   31.183832] usb 1-1.1: configuration #1 chosen from 1 choice
[   31.190504] usb 1-1.1: can't set config #1, error -32
--
[180077.652645] usb 1-1.1: USB disconnect, address 6
[180080.387154] usb 1-1.1: new low speed USB device using ehci_hcd and address 
11
[180080.586706] usb 1-1.1: configuration #1 chosen from 1 choice

So something wasn't available at bootup.   And I'm still puzzled...

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
The most important early product on the way to developing a good product
is an imperfect version.

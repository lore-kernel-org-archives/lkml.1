Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbXCOVt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbXCOVt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbXCOVt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:49:59 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:3861 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbXCOVt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:49:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 15 Mar 2007 21:49:56.0273 (UTC) FILETIME=[DEDF4210:01C7674B]
Content-class: urn:content-classes:message
Subject: Re: [linux-usb-devel] USB Keyboard
Date: Thu, 15 Mar 2007 17:49:56 -0400
Message-ID: <Pine.LNX.4.61.0703151745360.5799@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0703152236390.12394@twin.jikos.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-usb-devel] USB Keyboard
Thread-Index: AcdnS97wWGbN3ImKQC+fZdAj5w/CRA==
References: <Pine.LNX.4.44L0.0703151506010.2482-100000@iolanthe.rowland.org> <Pine.LNX.4.61.0703151541430.4459@chaos.analogic.com> <Pine.LNX.4.64.0703152236390.12394@twin.jikos.cz>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Jiri Kosina" <jikos@jikos.cz>
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 15 Mar 2007, Jiri Kosina wrote:

> On Thu, 15 Mar 2007, linux-os (Dick Johnson) wrote:
>
> [...]
>> The initrd "linuxrc" file that loads the modules is here. One can see
>> the order in which the modules are loaded. We had to make our own shell
>> to replace 'nash' because the SCSI drivers spawned "children" that
>> confused nash with SIGCHLD when they executed.
> [...]
>> echo "Loading uhci-hcd.ko module"
>> insmod /lib/uhci-hcd.ko
>> echo "Loading ehci-hcd.ko module"
>> insmod /lib/ehci-hcd.ko
>> echo "Loading usbhid.ko module"
>> insmod /lib/usbhid.ko
>> echo "Loading usbkbd.ko module"
>> insmod /lib/usbkbd.ko
>
> Could you please try to *not* insmod usbkbd module? Or is there any
> special particular reason for you doing so?
>
> This module is not what should be used in a normal situation on production
> and fully working systems. Everything for USB keyboard to work is normally
> handled by the usbhid module. Please see the description of what usbkbd
> is:
>
> config USB_KBD
>        tristate "USB HIDBP Keyboard (simple Boot) support"
>        depends on USB && INPUT
>        ---help---
>          Say Y here only if you are absolutely sure that you don't want
>          to use the generic HID driver for your USB keyboard and prefer
>          to use the keyboard in its limited Boot Protocol mode instead.
>
>          This is almost certainly not what you want.  This is mostly
>          useful for embedded applications or simple keyboards.
>
>          To compile this driver as a module, choose M here: the
>          module will be called usbkbd.
>
>          If even remotely unsure, say N.
>
> The module could be buggy, your keyboard might be hidbp incompatible, or
> whatever. usbkbd is very rarely used and is there only for really special
> ocasions, as the Kconfig help text clearly states.
>
> So could you please try without this module loaded and let me know the
> result?
>
> -- 
> Jiri Kosina

Yes! I will try it in the morning. It's now past quitting time and,
following this thread, you will note that the ohci module needed to
be loaded for this AMD unit so the keyboard now works! I will
remove the unused modules tomorrow morning and post hopefully
good news. I used the usbkbd module in a blind attempt to get
things working (I have been following a lot of suggestions).

Cheers,
Dick Johnson
Penguin : Linux version 2.6.16.24 on an i686 machine (5615.29 BogoMips).
New book: http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.

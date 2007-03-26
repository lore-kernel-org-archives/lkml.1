Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXCZI2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXCZI2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbXCZI2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:28:42 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:34050 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXCZI2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:28:41 -0400
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
From: Marcel Holtmann <marcel@holtmann.org>
To: Li Yu <raise.sail@gmail.com>
Cc: linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       ??? <hongzhiyi@ccoss.com.cn>, Jiri Kosina <jkosina@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, ?? <yanghong@ccoss.com.cn>
In-Reply-To: <45FE6971.6090503@gmail.com>
References: <200703051532096508636@gmail.com>  <45FE6971.6090503@gmail.com>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 10:27:56 +0200
Message-Id: <1174897676.5815.6.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

> --------------------------------------
>     HID bus design overview.
> --------------------------------------
> 
> A. Terms.
> 
>     The device of an driver: this mean the device that this driver matched.
> 
> B. Design.
> 
>     As we discussed before, The entire HID subsystem is divided into
> three layers:
>     
>     1. HID Driver Layer (HIDDL).
>         
>         This layer is composite of all HID drivers, however, these
> drivers are not equal each other, there are divided into three kinds:
>         
>         1.1 Fundamental driver.
>                 
>         This is the most natural driver for us, they control hardware or
> other something that can effect hardware directly. In most cases, each
> of this kind driver is one standard and extendible implementation of HID
> specification for specific HID transport layer. For example, usbhid.ko
> for HID/USB or hidp.ko for Bluetooth/HID. This should alway input-able
> driver, i.e, it is able to allow HIDAL register input device for its device.
>                     
>         1.2 Shadow driver.
>         
>         These driver is created for those buggy/strange/extended HID
> device which fundamental driver can't handle rightly/completely. this
> driver does not share HID information with related fundamental driver,
> but the HID information of their devices is derived from other device of
> fundamental driver. These may not be input-able driver. The shadow
> driver does not share the input device with the related fundamental
> driver, even shadow driver is input-able, it have new input device in
> such case.
>         
>         1.3 HIDDEV drvier.
>         
>         In fact, This isn't one public kind of driver. it just is one
> optionally flag parameter while register driver (also include shadow
> driver). When turn on this feature, the HIDAL will create one hiddev for
> each device of driver, so the every such device also have one hiddev buddy.
>     
>     2. HID Abstract Layer (HIDAL).        
>     
>         This layer maintain HID bus, HID driver, HID device, HID hiddev
> such logical feature, and interact with input subsystem.
> 
>     3. HID Transport Layer (HIDTL).
> 
>         This layer may be rather thin. Up to now, we should have two
> implementation of transport layer, one for USB, one for Bluetooth.
> 
> C. Progress.
> 
> Status: USB Fundamental driver works for new HID API now.
> Working: Shadow driver support.
> TODO:
>     1. Shadow driver support.
>     2. Port some drivers to new HID API, includes:
>         1) All HID ff drivers.
>         2) iBook/PowerBook special keys driver.
>     3. Bluetooth fundamental driver.
>     4. Bluetooth transport layer.
>     5. Port Other drivers.
>     6. HIDDEV/USB driver support.
>     7. HIDDEV/Bluetooth driver support.
> 
> I think that post this text earlier is better decision, well, I guess
> the new controversy about HID may begin ...

please don't take the transport layers into account when designing the
HID bus. They have nothing to do with the upper layer. Especially the
upper layer shouldn't care at all if the actual HID reports are sent
over USB or Bluetooth.

The transport drivers (usbhid and hidp) will only communicate with the
HID core and for the bus it makes no difference. The current abstraction
for HID transports works pretty fine and there is no need to change
this.

I think that a HID bus driver should be able register to a specific HID
report for a specific device. This would allow to have a generic driver
that can handle all common keyboard and mouse functionality and then in
addition a specific driver that handles vendor specific reports. It
might also make sense to let the driver match on specific HUT codes.

Regards

Marcel



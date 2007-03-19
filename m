Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXCSKos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXCSKos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 06:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbXCSKoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 06:44:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:26705 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbXCSKop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 06:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=sDYJZT4OQ40YAZXE1QtAv3gg97QKUb3CRi/zKYgvtHhDLL2vVlNKb0UTh+ZdsuZYvc7ibj/NJ8I/2bDuvlTdOQlendOGV6fWIdLayBblJavmY2Opaa1CmLrNTJZ8vhYMD7i1rSJnuEMJuDpjjnYenIBsZmHHTh/sQjopPLNvmzc=
Message-ID: <45FE6971.6090503@gmail.com>
Date: Mon, 19 Mar 2007 18:44:01 +0800
From: Li Yu <raise.sail@gmail.com>
User-Agent: Thunderbird 1.5 (X11/20051201)
MIME-Version: 1.0
To: linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       =?ISO-8859-1?Q?=3F=3F?= <yanghong@ccoss.com.cn>,
       =?ISO-8859-1?Q?=3F=3F=3F?= <hongzhiyi@ccoss.com.cn>
Subject: [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com>
In-Reply-To: <200703051532096508636@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--------------------------------------
    HID bus design overview.
--------------------------------------

A. Terms.

    The device of an driver: this mean the device that this driver matched.

B. Design.

    As we discussed before, The entire HID subsystem is divided into
three layers:
    
    1. HID Driver Layer (HIDDL).
        
        This layer is composite of all HID drivers, however, these
drivers are not equal each other, there are divided into three kinds:
        
        1.1 Fundamental driver.
                
        This is the most natural driver for us, they control hardware or
other something that can effect hardware directly. In most cases, each
of this kind driver is one standard and extendible implementation of HID
specification for specific HID transport layer. For example, usbhid.ko
for HID/USB or hidp.ko for Bluetooth/HID. This should alway input-able
driver, i.e, it is able to allow HIDAL register input device for its device.
                    
        1.2 Shadow driver.
        
        These driver is created for those buggy/strange/extended HID
device which fundamental driver can't handle rightly/completely. this
driver does not share HID information with related fundamental driver,
but the HID information of their devices is derived from other device of
fundamental driver. These may not be input-able driver. The shadow
driver does not share the input device with the related fundamental
driver, even shadow driver is input-able, it have new input device in
such case.
        
        1.3 HIDDEV drvier.
        
        In fact, This isn't one public kind of driver. it just is one
optionally flag parameter while register driver (also include shadow
driver). When turn on this feature, the HIDAL will create one hiddev for
each device of driver, so the every such device also have one hiddev buddy.
    
    2. HID Abstract Layer (HIDAL).        
    
        This layer maintain HID bus, HID driver, HID device, HID hiddev
such logical feature, and interact with input subsystem.

    3. HID Transport Layer (HIDTL).

        This layer may be rather thin. Up to now, we should have two
implementation of transport layer, one for USB, one for Bluetooth.

C. Progress.

Status: USB Fundamental driver works for new HID API now.
Working: Shadow driver support.
TODO:
    1. Shadow driver support.
    2. Port some drivers to new HID API, includes:
        1) All HID ff drivers.
        2) iBook/PowerBook special keys driver.
    3. Bluetooth fundamental driver.
    4. Bluetooth transport layer.
    5. Port Other drivers.
    6. HIDDEV/USB driver support.
    7. HIDDEV/Bluetooth driver support.

I think that post this text earlier is better decision, well, I guess
the new controversy about HID may begin ...
  
PS: In my words, the hiddev is same with rawdev, is it right in your words?
    I cann't acquire the support for this from my corporation, :( So, I
must complete this in my spare time, it may take longer time.

Goodluck.

-Li Yu

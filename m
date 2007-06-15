Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbXFORzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbXFORzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 13:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbXFORzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 13:55:45 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:48974 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751133AbXFORzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 13:55:45 -0400
Message-ID: <4672D2A8.6030407@cfl.rr.com>
Date: Fri, 15 Jun 2007 13:55:52 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: pharon@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
References: <20070611101319.GA14284@DervishD>  <466D2DF7.9020709@aladin.ro> <1181563063.19258.11.camel@iamer-laptop>
In-Reply-To: <1181563063.19258.11.camel@iamer-laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jun 2007 17:55:56.0668 (UTC) FILETIME=[6C9E8BC0:01C7AF76]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15240.000
X-TM-AS-Result: No--15.033000-5.000000-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please do not hit reply and change the subject when you really want to 
create a new message.  You apparently replied to to a message in the 
thread "ext2 on flash memory".  This causes your message to show up 
under that thread, which is confusing to people reading that thread, and 
will cause those ignoring that thread to never see your message.

Islam Amer wrote:
> Hello all.
> 
> I have a remote control device, with an IR transciever that plugs into a
> USB port and registers as an input device. 
> 
> All the buttons on the remote work fine except for the back , text , and
> three grey buttons at the top.
> 
> Here is the relevant /proc/bus/input/devices entry :
> 
> 
> I: Bus=0003 Vendor=18b1 Product=0037 Version=0100
> N: Name="ELMAK.pl irMAKbd pl"
> P: Phys=usb-0000:00:03.1-2/input0
> S: Sysfs=/class/input/input4
> H: Handlers=kbd mouse1 event4 ts1 
> B: EV=12000f
> B: KEY=f 42c53b7 bf0d4400 0 0 70001 10004 3c007 ff8763fa c140dfff
> febeffdf ffefffff ffffffff fffffffe
> B: REL=103
> B: ABS=7ff01 0
> B: LED=1f
> 
> I did a little investigation using evbug and inputlircd and it seems
> that these buttons generate codes that get dropped somewhere in the
> input layer. They work fine on windows.
> 
> I used a modified inputlircd to get all the raw keycodes using irw :
> 
> Here's what I get for the down key :
> 
> 6c 0 KEY_DOWN event4
> 0 0 KEY_RESERVED event4
> 29 0 KEY_GRAVE event4
> 0 0 KEY_RESERVED event4
> 6c 0 KEY_DOWN event4
> 0 0 KEY_RESERVED event4
> 
> and volume+
> 
> 73 0 KEY_VOLUMEUP event4 
> 0 0 KEY_RESERVED event4 
> 29 0 KEY_GRAVE event4 
> 0 0 KEY_RESERVED event4 
> 73 0 KEY_VOLUMEUP event4 
> 0 0 KEY_RESERVED event4
> 
> As compared to the non-functional keys like back :
> 
> 29 0 KEY_GRAVE event4
> 0 0 KEY_RESERVED event4
> 
> As you can see it is sending only the reserved and GRAVE codes, and no
> special codes.
> 
> Next point of debugging is inside the kernel, using the evbug module :
> 
> sudo modprobe evbug
> 
> pressed the Volume+ key
> 
> look in dmesg :
> 
> [ 2815.891865] evbug.c: Connected device: "Macintosh mouse button emulation", <NULL>
> [ 2815.891874] evbug.c: Connected device: "AT Translated Set 2 keyboard", isa0060/serio0/input0
> [ 2815.891878] evbug.c: Connected device: "cx88 IR (Hauppauge Nova-S-Plus ", pci-0000:00:05.0/ir0
> [ 2815.891883] evbug.c: Connected device: "PC Speaker", isa0061/input0
> [ 2815.891887] evbug.c: Connected device: "ELMAK.pl irMAKbd pl", usb-0000:00:03.1-2/input0
> [ 2815.891892] evbug.c: Connected device: "Power Button (FF)", ACPI_FPB/button/input0
> [ 2815.891896] evbug.c: Connected device: "Power Button (CM)", PNP0C0C/button/input0
> [ 2820.988865] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 1, Code: 115, Value: 1
> [ 2820.988875] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 0, Code: 0, Value: 0
> [ 2820.996844] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 3, Code: 41, Value: 144
> [ 2820.996854] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 0, Code: 0, Value: 0
> [ 2821.212577] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 1, Code: 115, Value: 0
> [ 2821.212587] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 0, Code: 0, Value: 0
> 
> pressed the Back button the extra lines are :
> 
> [ 2856.041526] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 3, Code: 41, Value: 35
> [ 2856.041537] evbug.c: Event. Dev: usb-0000:00:03.1-2/input0, Type: 0, Code: 0, Value: 0
> 
> 
> I just need a pointer to where to start looking at the problem.
> 
> Here's the website for the remote
> http://www.elmak.pl/index.php?option=com_phpshop&page=shop.browse&category_id=14&ext=opis&lang=en
> 
> I am running ubuntu fiesty 
> Linux ubuntu 2.6.20-15-generic #2 SMP
> 
> Thanks in advance.


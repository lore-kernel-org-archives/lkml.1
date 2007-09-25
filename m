Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXIYSNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXIYSNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 14:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750786AbXIYSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 14:13:09 -0400
Received: from lvps87-230-0-242.dedicated.hosteurope.de ([87.230.0.242]:33853
	"EHLO lvps87-230-0-242.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbXIYSNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 14:13:08 -0400
In-Reply-To: <d120d5000709251051n45e415e6gbdd87a98f0b8cdd4@mail.gmail.com>
References: <6D36DFB9-B26D-4CEA-B7AD-0216F7124FC5@it-loops.com> <d120d5000709251051n45e415e6gbdd87a98f0b8cdd4@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B5B5C841-6068-413B-A765-73A34E988FAA@it-loops.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Michael Guntsche <mike@it-loops.com>
Subject: Re: 2.6.23 /proc/bus/input/devices content question
Date: Tue, 25 Sep 2007 20:13:02 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25, 2007, at 19:51, Dmitry Torokhov wrote:

> Hi Michael,
>
>> ...
>> I this a "wanted" change or should I still see the same with 2.6.23?
>>
>
> Is this with CONFIG_SYSFS_DEPRECATED=y?

No, CONFIG_SYSFS_DEPRECATED is not set with both kernels. I had a  
closer look and noticed that I for some reason usbhid AND usbkbd were  
loaded.
I removed them both and loaded usbhid again. Now I had two entries  
for my keyboard.

I: Bus=0003 Vendor=08d4 Product=0006 Version=0110
N: Name="Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/ 
PS2 Keyboard v1.1"
P: Phys=usb-0000:00:1d.0-2/input0
S: Sysfs=/class/input/input4
U: Uniq=
H: Handlers=kbd event0
B: EV=120003
B: KEY=e080ffdf 1cfffff ffffffff fffffffe
B: LED=1f

I: Bus=0003 Vendor=08d4 Product=0006 Version=0110
N: Name="Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/ 
PS2 Keyboard v1.1"
P: Phys=usb-0000:00:1d.0-2/input1
S: Sysfs=/class/input/input5
U: Uniq=
H: Handlers=kbd event1
B: EV=3
B: KEY=1078 800c000 1e0000 0 0 0

Notice that Sysfs still shows /class/input...

With 2.6.23-rc7 ONLY usbhid got loaded and I got

I: Bus=0003 Vendor=08d4 Product=0006 Version=0110
N: Name="Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/ 
PS2 Keyboard v1.1"
P: Phys=usb-0000:00:1d.0-2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.0/input/input4
U: Uniq=
H: Handlers=kbd event2
B: EV=120003
B: KEY=e080ffdf 1cfffff ffffffff fffffffe
B: LED=1f

I: Bus=0003 Vendor=08d4 Product=0006 Version=0110
N: Name="Fujitsu Siemens Computers Fujitsu Siemens Computers GmbH USB/ 
PS2 Keyboard v1.1"
P: Phys=usb-0000:00:1d.0-2/input1
S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb1/1-2/1-2:1.1/input/input5
U: Uniq=
H: Handlers=kbd event3
B: EV=3
B: KEY=1078 800c000 1e0000 0 0 0

So actually Phys is the same, just Sysfs got changed.


Hope that helps,
Michael


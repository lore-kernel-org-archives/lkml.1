Return-Path: <linux-kernel-owner+w=401wt.eu-S1752114AbZAZLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbZAZLVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 06:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751139AbZAZLVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 06:21:22 -0500
Received: from mail.mailasail.com ([212.227.250.41]:47381 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbZAZLVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 06:21:22 -0500
Message-ID: <497D9CAE.3010503@wildgooses.com>
Date: Mon, 26 Jan 2009 11:21:18 +0000
From: Ed W <lists@wildgooses.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: How to add new CDC-ACM usb modem device to supported list?
References: <497D94C0.3070308@wildgooses.com>
In-Reply-To: <497D94C0.3070308@wildgooses.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ed W wrote:
> Hi, I have a wireless modem device which I believe to be a normal usb
> ACM modem type device (works this way in windows where there is just a
> .inf file supplied which connects the device with usbser.sys).
...
> I also read the cdc-acm kernel readme and
> have a rough idea on what should be happening
>
>   

After fixing an embarrassingly trivial configuration error, the acm
driver *is* in fact loading correctly...

However, I'm not getting any response using either minicom or "cu".  I
suspect something fairly simple - can someone perhaps point me towards
how to get some more detailed debugging info from this kind of USB
device please?

Relevant bits from /proc/bus/usb/devices



T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22.19-grsec2.1.11-vs2.2.0.7 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=06 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  8 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=e0(unk. ) Sub=01 Prot=01 MxPS=32 #Cfgs=  1
P:  Vendor=1edd ProdID=9555 Rev= 0.00
S:  Manufacturer=Iridium
S:  Product=Iridium 9555 Handset
C:* #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=250mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=02(comm.) Sub=02 Prot=01 Driver=cdc_acm
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=1ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_acm
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms


dmesg
[5075781.727325] usb 6-2: new full speed USB device using uhci_hcd and
address 8
[5075781.911917] usb 6-2: configuration #1 chosen from 1 choice
[5075781.915864] hci_usb: probe of 6-2:1.0 failed with error -5
[5075781.915879] cdc_acm 6-2:1.0: ttyACM0: USB ACM device


Presumably this error -5 is relevant??

Thanks

Ed W



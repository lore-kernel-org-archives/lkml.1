Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXKAGll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXKAGll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 02:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbXKAGlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 02:41:32 -0400
Received: from smtp104.biz.mail.re2.yahoo.com ([206.190.52.173]:32937 "HELO
	smtp104.biz.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752343AbXKAGlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 02:41:31 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 02:41:30 EDT
X-YMail-OSG: gszOA3YVM1mE1nZ2_XEEUDBHIPKI_11.GVVk4hNbt_Ct.VFbHmVQNXGHqpNioS9SmrEZdpp3PQzqSzT9nGgfHRPZ7ojz2Ove4i44Rti_8qpcyKhQrF4lF7q0e9tYBKirnpT3CLQ3TAQiFlU-
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: Re: ti_usb_3410_5052 breakage in 2.6.24-rc1
Date: Wed, 31 Oct 2007 23:34:46 -0700
User-Agent: KMail/1.9.7
Cc: Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net
References: <200710312225.44210.sfking@fdwdc.com> <20071101061954.GA11303@kroah.com>
In-Reply-To: <20071101061954.GA11303@kroah.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_GOXKHWclNL4PkEi"
Message-Id: <200710312334.46889.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_GOXKHWclNL4PkEi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 31 October 2007 11:19:54 Greg KH wrote:
> On Wed, Oct 31, 2007 at 10:25:43PM -0700, Steven King wrote:
> >   My TI eZ430 (MSP-FET430UIF JTAG Tool) usb dongle works fine with
> > 2.6.23.1 and earlier, but doesn't work with 2.6.24-rc1; the
> > ti_usb_3410_5052 module is loaded but the device descriptor is bogus,
> > reporting only a single configuration, whereas in 2.6.23.1 it reports 2
> > configurations, allowing one to select the second configuration to get a
> > serial port.
> >
> > git bisect fingered this commit:
> >
> > 063a2da8f01806906f7d7b1a1424b9afddebc443 "USB: serial core should respect
> > driver requirements"
>
> Can you send me a copy of /proc/bus/usb/devices with this device plugged
> in?

Sure,

for 2.6.23.1:

T:  Bus=07 Lev=02 Prnt=02 Port=03 Cnt=01 Dev#= 18 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  2
P:  Vendor=0451 ProdID=f430 Rev= 1.01
S:  Manufacturer=Texas Instruments
S:  Product=MSP-FET430UIF JTAG Tool
S:  SerialNumber=TUSB341010398282E658FFD7
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
C:* #Ifs= 1 Cfg#= 2 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=ti_usb_3410_5052
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   2 Ivl=1ms

and 2.6.24-rc1:

T:  Bus=07 Lev=02 Prnt=13 Port=03 Cnt=01 Dev#= 14 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0451 ProdID=f430 Rev= 1.01
S:  Manufacturer=Texas Instruments
S:  Product=MSP-FET430UIF JTAG Tool
S:  SerialNumber=TUSB341010398282E658FFD7
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

full /proc/bus/usb/devices for both versions are attached

-- 
Steven King -- sfking at fdwdc dot com

--Boundary-00=_GOXKHWclNL4PkEi
Content-Type: text/plain;
  charset="iso-8859-1";
  name="proc.bus.usb.devices-2.6.23.1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.bus.usb.devices-2.6.23.1"


T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=08 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  4 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=13b1 ProdID=0020 Rev= 0.01
S:  Manufacturer=Cisco-Linksys
S:  Product=Compact Wireless-G USB Adapter
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=300mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  3/800 us ( 0%), #Int=  4, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1a.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#=  2 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=02 Port=03 Cnt=01 Dev#= 18 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  2
P:  Vendor=0451 ProdID=f430 Rev= 1.01
S:  Manufacturer=Texas Instruments
S:  Product=MSP-FET430UIF JTAG Tool
S:  SerialNumber=TUSB341010398282E658FFD7
C:  #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
C:* #Ifs= 1 Cfg#= 2 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=ti_usb_3410_5052
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   2 Ivl=1ms

T:  Bus=07 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  7 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=07 Port=00 Cnt=01 Dev#=  8 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1649 ProdID=0102 Rev= 1.00
S:  Manufacturer=SofTec Microsystems
S:  Product=uDART In-Circuit Debugger
S:  SerialNumber=PKS08-10
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=02 Prnt=07 Port=03 Cnt=02 Dev#= 10 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1649 ProdID=0200 Rev= 1.00
S:  Manufacturer=SofTec Microsystems
S:  Product=USBSPYDER08
S:  SerialNumber=0
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=02 Prnt=07 Port=04 Cnt=03 Dev#= 11 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=15ba ProdID=0003 Rev= 5.00
S:  Manufacturer=Olimex
S:  Product=Olimex OpenOCD JTAG
S:  SerialNumber=FTP7QXG6
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=300mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=ftdi_sio
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=07 Lev=02 Prnt=07 Port=05 Cnt=04 Dev#= 12 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=15a2 ProdID=0017 Rev= 1.00
S:  Manufacturer=Freescale Semiconductor
S:  Product=USB to SPI Interface
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 64mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=01 Prnt=01 Port=04 Cnt=03 Dev#= 13 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=13 Port=01 Cnt=01 Dev#= 16 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1307 ProdID=0163 Rev= 1.00
S:  Manufacturer=USBest Technology
S:  Product=USB Mass Storage Device
S:  SerialNumber=b74138c700759a
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr= 80mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=16ms

T:  Bus=07 Lev=02 Prnt=13 Port=04 Cnt=02 Dev#= 14 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1357 ProdID=0504 Rev= 2.00
S:  Manufacturer=P&E Microcomputer Systems, Inc.
S:  Product=DEMOQE
S:  SerialNumber=PE5021192
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=448mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 256 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 256 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=07 Lev=02 Prnt=13 Port=05 Cnt=03 Dev#= 15 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1357 ProdID=0503 Rev= 2.00
S:  Manufacturer=P&E Microcomputer Systems, Inc.
S:  Product=USB-ML-12 MCUSLK
S:  SerialNumber=PEMICRO-SHARED
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=448mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 256 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 256 Ivl=0ms

T:  Bus=07 Lev=01 Prnt=01 Port=05 Cnt=04 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=058f ProdID=6377 Rev= 1.00
S:  Manufacturer=Generic
S:  Product=Mass Storage Device
S:  SerialNumber=920321111113
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 29/900 us ( 3%), #Int=  2, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c313 Rev= 1.00
S:  Manufacturer=BTC
S:  Product=USB Multimedia Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 12/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c040 Rev=24.30
S:  Manufacturer=Logitech
S:  Product=USB-PS/2 Optical Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 98mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   5 Ivl=10ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.23.1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

--Boundary-00=_GOXKHWclNL4PkEi
Content-Type: text/plain;
  charset="iso-8859-1";
  name="proc.bus.usb.devices-2.6.24-rc1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="proc.bus.usb.devices-2.6.24-rc1"


T:  Bus=08 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=08 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  4 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=13b1 ProdID=0020 Rev= 0.01
S:  Manufacturer=Cisco-Linksys
S:  Product=Compact Wireless-G USB Adapter
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=300mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=07 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 6
B:  Alloc=  0/800 us ( 0%), #Int=  3, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1a.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=07 Lev=01 Prnt=01 Port=01 Cnt=01 Dev#= 13 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=13 Port=03 Cnt=01 Dev#= 14 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0451 ProdID=f430 Rev= 1.01
S:  Manufacturer=Texas Instruments
S:  Product=MSP-FET430UIF JTAG Tool
S:  SerialNumber=TUSB341010398282E658FFD7
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=07 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  3 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=03 Port=00 Cnt=01 Dev#=  4 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1649 ProdID=0102 Rev= 1.00
S:  Manufacturer=SofTec Microsystems
S:  Product=uDART In-Circuit Debugger
S:  SerialNumber=PKS08-10
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=02 Prnt=03 Port=03 Cnt=02 Dev#=  6 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=1649 ProdID=0200 Rev= 1.00
S:  Manufacturer=SofTec Microsystems
S:  Product=USBSPYDER08
S:  SerialNumber=0
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=02 Prnt=03 Port=04 Cnt=03 Dev#=  7 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=15ba ProdID=0003 Rev= 5.00
S:  Manufacturer=Olimex
S:  Product=Olimex OpenOCD JTAG
S:  SerialNumber=FTP7QXG6
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=300mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=ftdi_sio
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=07 Lev=02 Prnt=03 Port=05 Cnt=04 Dev#=  8 Spd=12  MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=15a2 ProdID=0017 Rev= 1.00
S:  Manufacturer=Freescale Semiconductor
S:  Product=USB to SPI Interface
C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 64mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=01 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
E:  Ad=02(O) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=07 Lev=01 Prnt=01 Port=04 Cnt=03 Dev#=  9 Spd=480 MxCh= 7
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=2001 ProdID=f103 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   1 Ivl=256ms

T:  Bus=07 Lev=02 Prnt=09 Port=01 Cnt=01 Dev#= 12 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1307 ProdID=0163 Rev= 1.00
S:  Manufacturer=USBest Technology
S:  Product=USB Mass Storage Device
S:  SerialNumber=b74138c700759a
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr= 80mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=  64 Ivl=16ms

T:  Bus=07 Lev=02 Prnt=09 Port=04 Cnt=02 Dev#= 10 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1357 ProdID=0504 Rev= 2.00
S:  Manufacturer=P&E Microcomputer Systems, Inc.
S:  Product=DEMOQE
S:  SerialNumber=PE5021192
C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=448mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 256 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 256 Ivl=0ms
I:* If#= 1 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=83(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=01(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms

T:  Bus=07 Lev=02 Prnt=09 Port=05 Cnt=03 Dev#= 11 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1357 ProdID=0503 Rev= 2.00
S:  Manufacturer=P&E Microcomputer Systems, Inc.
S:  Product=USB-ML-12 MCUSLK
S:  SerialNumber=PEMICRO-SHARED
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=448mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=ff Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS= 256 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS= 256 Ivl=0ms

T:  Bus=07 Lev=01 Prnt=01 Port=05 Cnt=04 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=058f ProdID=6377 Rev= 1.00
S:  Manufacturer=Generic
S:  Product=Mass Storage Device
S:  SerialNumber=920321111113
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=06 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 29/900 us ( 3%), #Int=  2, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 1.10 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c313 Rev= 1.00
S:  Manufacturer=BTC
S:  Product=USB Multimedia Keyboard
C:* #Ifs= 2 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=01 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms
I:* If#= 1 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=00 Prot=00 Driver=usbhid
E:  Ad=82(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 12/900 us ( 1%), #Int=  1, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=046d ProdID=c040 Rev=24.30
S:  Manufacturer=Logitech
S:  Product=USB-PS/2 Optical Mouse
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr= 98mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=03(HID  ) Sub=01 Prot=02 Driver=usbhid
E:  Ad=81(I) Atr=03(Int.) MxPS=   5 Ivl=10ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.24-rc1 uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1a.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

--Boundary-00=_GOXKHWclNL4PkEi--

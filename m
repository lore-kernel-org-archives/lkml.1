Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbXEUAob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbXEUAob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 20:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbXEUAoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 20:44:22 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:52093 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbXEUAoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 20:44:21 -0400
Date: Mon, 21 May 2007 09:41:19 +0900
From: Mattia Dongili <malattia@linux.it>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: [2.6.22-rc1-mm1] vaio laptop (SZ72B) immediately resumes after STR
Message-ID: <20070521004119.GA3103@inferi.kami.home>
References: <20070518071523.GA3195@inferi.kami.home> <20070519000413.75badb6f.akpm@linux-foundation.org> <20070520061408.GA3325@inferi.kami.home> <200705201138.05146.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705201138.05146.david-b@pacbell.net>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.22-rc1-mm1-bisect i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 11:38:04AM -0700, David Brownell wrote:
> On Saturday 19 May 2007, Mattia Dongili wrote:
> > On Sat, May 19, 2007 at 12:04:13AM -0700, Andrew Morton wrote:
> > > On Sat, 19 May 2007 15:48:29 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > 
> > > > On Fri, May 18, 2007 at 12:22:40AM -0700, Andrew Morton wrote:
> > > > > On Fri, 18 May 2007 16:15:24 +0900 Mattia Dongili <malattia@linux.it> wrote:
> > > > > 
> > > > > > Hello,
> > > > > > 
> > > > > > After finally catching fw-{ohci,core} to be problematic during resume,
> > > > > > I'm now experiencing an immediate resume after suspending.
> > > > > > 
> > > > > > 2.6.21-rc7-mm* didn't even suspend, my last known suspend-and-resuming
> > > > > > kernel was 2.6.21-rc5-mm3 (I know one other vaio SZ user could STR with
> > > > > > 2.6.21-rc6-mm* after the cpuidle fixes).
> > > > > > 
> > > > > > my .config is: http://oioio.altervista.org/linux/config-2.6.22-rc1-mm1-1
> > > > > > and a str cycle with PM_DEBUG=y:
> > > > > > http://oioio.altervista.org/linux/dmesg-SRT-immediately-resumes.txt
> 
> Can you also provide /proc/acpi/wakeup and /proc/bus/usb/devices?
> Plus "ethool eth0" and "ethtool -i eth0"?

here we go:

$ cat /proc/acpi/wakeup
Device	S-state	  Status   Sysfs node
PWRB	  S4	*enabled   
S1F0	  S4	 disabled  
S1F1	  S4	 disabled  
S1F2	  S4	 disabled  
S1F3	  S4	 disabled  
S1F4	  S4	 disabled  
S1F5	  S4	 disabled  
S1F6	  S4	 disabled  
S1F7	  S4	 disabled  
TLAN	  S3	 disabled  pci:0000:07:00.0
DLAN	  S3	 disabled  
S6F0	  S4	 disabled  
S6F1	  S4	 disabled  
S6F2	  S4	 disabled  
S6F3	  S4	 disabled  
S6F4	  S4	 disabled  
S6F5	  S4	 disabled  
S6F6	  S4	 disabled  
S6F7	  S4	 disabled  
USB1	  S3	 disabled  pci:0000:00:1d.0
USB2	  S3	 disabled  pci:0000:00:1d.1
USB3	  S3	 disabled  pci:0000:00:1d.2
USB4	  S3	 disabled  pci:0000:00:1d.3
USB7	  S3	 disabled  pci:0000:00:1d.7
SLT0	  S4	 disabled  
LANC	  S3	 disabled  
EC0	  S5	 disabled  

$ cat /proc/bus/usb/devices

T:  Bus=05 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc= 45/900 us ( 5%), #Int=  1, #Iso=  1
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.3
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=05 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=1.5 MxCh= 0
D:  Ver= 2.00 Cls=ff(vend.) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=054c ProdID=01bb Rev= 1.28
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=   8 Ivl=10ms

T:  Bus=05 Lev=01 Prnt=01 Port=01 Cnt=02 Dev#=  3 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=e0(unk. ) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=044e ProdID=300c Rev=19.15
S:  Manufacturer=ALPS
S:  Product=UGX
C:* #Ifs= 3 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=81(I) Atr=03(Int.) MxPS=  16 Ivl=1ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:  If#= 1 Alt= 0 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
I:  If#= 1 Alt= 1 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=   9 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=   9 Ivl=1ms
I:* If#= 1 Alt= 2 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  17 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  17 Ivl=1ms
I:  If#= 1 Alt= 3 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  25 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  25 Ivl=1ms
I:  If#= 1 Alt= 4 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  33 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  33 Ivl=1ms
I:  If#= 1 Alt= 5 #EPs= 2 Cls=e0(unk. ) Sub=01 Prot=01 Driver=hci_usb
E:  Ad=03(O) Atr=01(Isoc) MxPS=  49 Ivl=1ms
E:  Ad=83(I) Atr=01(Isoc) MxPS=  49 Ivl=1ms
I:* If#= 2 Alt= 0 #EPs= 0 Cls=fe(app. ) Sub=01 Prot=00 Driver=(none)

T:  Bus=04 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.2
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 1.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=0483 ProdID=2016 Rev= 0.01
S:  Manufacturer=STMicroelectronics
S:  Product=Biometric Coprocessor
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=02(O) Atr=02(Bulk) MxPS=  64 Ivl=0ms
E:  Ad=83(I) Atr=03(Int.) MxPS=   4 Ivl=20ms

T:  Bus=03 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 2
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect uhci_hcd
S:  Product=UHCI Host Controller
S:  SerialNumber=0000:00:1d.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=480 MxCh= 8
B:  Alloc=  0/800 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=0000 ProdID=0000 Rev= 2.06
S:  Manufacturer=Linux 2.6.22-rc1-mm1-bisect ehci_hcd
S:  Product=EHCI Host Controller
S:  SerialNumber=0000:00:1d.7
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   4 Ivl=256ms

T:  Bus=01 Lev=01 Prnt=01 Port=03 Cnt=01 Dev#=  2 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=054c ProdID=0281 Rev= 4.52
S:  Manufacturer=Sony
S:  Product=UMH-U09
S:  SerialNumber=F000001C9B3A
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=08(stor.) Sub=06 Prot=50 Driver=usb-storage
E:  Ad=02(O) Atr=02(Bulk) MxPS= 512 Ivl=125us
E:  Ad=82(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms

T:  Bus=01 Lev=01 Prnt=01 Port=05 Cnt=02 Dev#=  4 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=05ca ProdID=1830 Rev= 1.00
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=100mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=06(still) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=86(I) Atr=01(Isoc) MxPS=   0 Ivl=125us
I:  If#= 0 Alt= 1 #EPs= 2 Cls=06(still) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=86(I) Atr=01(Isoc) MxPS=2048 Ivl=125us
I:  If#= 0 Alt= 2 #EPs= 2 Cls=06(still) Sub=00 Prot=00 Driver=(none)
E:  Ad=81(I) Atr=03(Int.) MxPS=  64 Ivl=125us
E:  Ad=86(I) Atr=01(Isoc) MxPS=3072 Ivl=125us

$ sudo ethtool eth0
Settings for eth0:
	Supported ports: [ TP ]
	Supported link modes:   10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	                        1000baseT/Half 1000baseT/Full 
	Supports auto-negotiation: Yes
	Advertised link modes:  10baseT/Half 10baseT/Full 
	                        100baseT/Half 100baseT/Full 
	Advertised auto-negotiation: Yes
	Speed: 100Mb/s
	Duplex: Full
	Port: Twisted Pair
	PHYAD: 0
	Transceiver: internal
	Auto-negotiation: on
	Supports Wake-on: pg
	Wake-on: d
	Current message level: 0x000000ff (255)
	Link detected: yes

$ sudo ethtool -i eth0
driver: sky2
version: 1.14
firmware-version: N/A
bus-info: 0000:07:00.0

> And, for a bit more info, the output of the appended script.

           on  acpi_system:00/device:00/PNP0C0C:00
           on  pci0000:00/0000:00:1d.7/usb1
           on  pci0000:00/0000:00:1d.7
           on  pci0000:00/0000:00:1d.3/usb5
           on  pci0000:00/0000:00:1d.3
           on  pci0000:00/0000:00:1d.2/usb4/4-1
           on  pci0000:00/0000:00:1d.2/usb4
           on  pci0000:00/0000:00:1d.2
           on  pci0000:00/0000:00:1d.1/usb3
           on  pci0000:00/0000:00:1d.1
           on  pci0000:00/0000:00:1d.0/usb2
           on  pci0000:00/0000:00:1d.0
           on  pci0000:00/0000:00:1c.2/0000:07:00.0

> (That's all *with* the patch listed below -- not reverted.)

sure :)

...
> > but very very close:
> > acpi-driver-model-flags-and-platform_enable_wake.patch
> 
> Which only affects PCI devices at this time, FWIW ...
> 
> This is a symptom of a device or driver misbehaving.  You can
> work around that; update the relevant /sys/devices/.../power/wakeup
> value(s) to "disabled", pending a driver bugfix (or workaround).
> 
> In fact, you could turn them all off (see appended diagnostic
> script) then turn them on one at a time to highlight problems
> 
> Reverting that patch just papers over the problem...
> 
> 
> My suspicion, based on the dmesg and seeing what drivers actually
> try to enable wakeup, would be the 'sky2' driver.  The other two

FWIW the sky2 is never functional upon resume, I need to ifdown, rmmod,
modprobe and ifup again to get some networking...

> obvious candidates are EHCI (which behaves for me on non-Intel
> hardware) and UHCI ... but USB has had a fair amount of testing
> in terms of wakeup mechanisms, so that seems a bit less likely
> to me (assuming no hardware bugs).
> 
> However, since after reverting the patch above you still saw
> other problems (immediate re-suspend) I'm suspecting this isn't
> a single simple problem you're finding.

eheheh, bisecting this one too, let's see...

Thanks
-- 
mattia
:wq!

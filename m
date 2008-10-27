Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYJ0IeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYJ0IeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYJ0IeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:34:02 -0400
Received: from smtp2.ono.com ([62.42.230.20]:16478 "EHLO resmaa03.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbYJ0IeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:34:00 -0400
Date: Mon, 27 Oct 2008 09:33:52 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081027093352.55eace33@werewolf.home>
In-Reply-To: <200810250034.59797.rjw@sisk.pl>
References: <20081014025453.617f2ef8@werewolf.home>
	<20081014174536.1353d17e@mjolnir.drzeus.cx>
	<20081014232759.08f5d212@werewolf.home>
	<200810250034.59797.rjw@sisk.pl>
X-Mailer: Claws Mail 3.6.1cvs12 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 00:34:59 +0200, "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Tuesday, 14 of October 2008, J.A. Magallón wrote:
> > On Tue, 14 Oct 2008 17:45:36 +0200, Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > 
> > > On Tue, 14 Oct 2008 02:54:53 +0200
> > > "J.A. Magallón" <jamagallon@ono.com> wrote:
> > > 
> > > > Hi...
> > > > 
> > > > More problems with git3. The left SD card reader is not detected on the One.
> > > > With a working kernel (distro 2.6.27):
> > > > 
> > > > Oct 14 02:44:27 one kernel: mmc0: error -84 whilst initialising SD card
> > > > 
> > > > Any ideas ?
> > > > 
> > > 
> > > -84 is -EILSEQ, which is some kind of bit error. Since you're running a
> > > JMicron controller, I'm guessing that something in your system isn't
> > > handling the higher speed (we forcefully enable highspeed on the
> > > Jmicron controll now).
> > > 
> > 
> > Err, sorry if this is stupid. I can see the card reader even if I don't
> > load the jmb38x_ms.ko module,just sdhci_pci. I understand that it is needed only if
> > I want to read memstick type cards. Or not ?
> > I suppose you refer to 'settings for JMicron hardware in sdhci_pci module'.
> > 
> > > Have you tested more than one card?
> > > 
> > 
> > I have two (both unknown brands for me, but I write full names fwiw):
> > - One "MBA Executive HiSpeed SD", 2Gb
> > - One "takeMS SDHC card Class6",  8Gb
> > 
> > Both give about 10Mb/s on read with hdparm under 2.6.27.
> > 
> > > What machine is this? 
> > 
> > It's an Acer Aspire One. From what I have seen, there are two SD devices.
> > Both are capable to read SDHC cards, I have switched cards and they work
> > (or at the moment both are working as backwards-compatible in plain SD
> > mode, if that even exists...).
> > 
> > From a half-working 2.6.27 kernel (half will be explained below):
> > 
> > sdhci: Secure Digital Host Controller Interface driver
> > sdhci: Copyright(c) Pierre Ossman
> > sdhci-pci 0000:01:00.0: SDHCI controller found [197b:2382] (rev 0)
> > sdhci-pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > sdhci-pci 0000:01:00.0: setting latency timer to 64
> > mmc0: SDHCI controller on PCI [0000:01:00.0] using ADMA
> > sdhci-pci 0000:01:00.2: SDHCI controller found [197b:2381] (rev 0)
> > sdhci-pci 0000:01:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > sdhci-pci 0000:01:00.2: Refusing to bind to secondary interface.
> > sdhci-pci 0000:01:00.2: PCI INT A disabled
> > 
> > (this is the right reader, the multi-format one)
> > 
> > sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 0)
> > sdhci-pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > sdhci-pci 0000:04:00.0: setting latency timer to 64
> > mmc1: SDHCI controller on PCI [0000:04:00.0] using ADMA
> > sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 0)
> > sdhci-pci 0000:04:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
> > sdhci-pci 0000:04:00.2: PCI INT A disabled
> > 
> > (and this is the left one, the SD-only)
> > 
> > ...
> > mmc0: new SD card at address 0002
> > ...
> > mmc1: new SDHC card at address 0002
> > ...
> > mmcblk0: mmc0:0002 00000 1974272KiB
> >  mmcblk0: p1
> > mmcblk1: mmc1:0002       7917568KiB
> >  mmcblk1: p1
> > 
> > one:~# lspci -t
> > -[0000:00]-+-00.0
> >            +-02.0
> >            +-02.1
> >            +-1b.0
> >            +-1c.0-[0000:01]--+-00.0
> >            |                 +-00.2
> >            |                 +-00.3
> >            |                 \-00.4
> >            +-1c.1-[0000:02]----00.0
> >            +-1c.2-[0000:03]----00.0
> >            +-1c.3-[0000:04]--+-00.0
> >            |                 +-00.2
> >            |                 +-00.3
> >            |                 \-00.4
> >            +-1d.0
> >            +-1d.1
> >            +-1d.2
> >            +-1d.3
> >            +-1d.7
> >            +-1e.0-[0000:05]--
> >            +-1f.0
> >            +-1f.2
> >            \-1f.3
> > 
> > one:~# lspci
> > 00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
> > 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
> > 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
> > 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
> > 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
> > 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
> > 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
> > 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
> > 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
> > 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
> > 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
> > 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> > 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
> > 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
> > 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
> > 01:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> > 01:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> > 01:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> > 01:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
> > 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
> > 03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> > 04:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> > 04:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> > 04:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> > 04:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
> > 
> > 
> > 
> > I call this half-working because I have to boot with a card inside a slot
> > to have it detected. If i boot without the card-in, it even dissapears from
> > lspci. This is just with the left SD inserted:
> > 
> > one:~# lspci
> > 00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
> > 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
> > 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
> > 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 02)
> > 00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 02)
> > 00:1c.2 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 (rev 02)
> > 00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 (rev 02)
> > 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
> > 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
> > 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
> > 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
> > 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
> > 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> > 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge (rev 02)
> > 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
> > 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
> > 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
> > 03:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg Wireless PCI Express Adapter (rev 01)
> > 04:00.0 System peripheral: JMicron Technologies, Inc. Device 2382
> > 04:00.2 SD Host controller: JMicron Technologies, Inc. Device 2381
> > 04:00.3 System peripheral: JMicron Technologies, Inc. Device 2383
> > 04:00.4 System peripheral: JMicron Technologies, Inc. Device 2384
> > 
> > If I insert a card on the right slot now it has no effect, it does not appear.
> > I suppose it is PCI hot-plunggin that is not hot nor plugs anything ;).:
> > 
> > one:~# lspci -t
> > -[0000:00]-+-00.0
> >            +-02.0
> >            +-02.1
> >            +-1b.0
> >            +-1c.0-[0000:01]--
> >            +-1c.1-[0000:02]----00.0
> >            +-1c.2-[0000:03]----00.0
> >            +-1c.3-[0000:04]--+-00.0
> >            |                 +-00.2
> >            |                 +-00.3
> >            |                 \-00.4
> >            +-1d.0
> >            +-1d.1
> >            +-1d.2
> >            +-1d.3
> >            +-1d.7
> >            +-1e.0-[0000:05]--
> >            +-1f.0
> >            +-1f.2
> >            \-1f.3
> > 
> > The tree after the bridge in 00:1c.0 is gone !!.
> > I googled about it and someone talked about pciehp_force, but last time
> > I tried some other devices (ether, could be?) dissapeared.
> > 
> > And now with -git4:
> > 
> > sdhci: Secure Digital Host Controller Interface driver
> > sdhci: Copyright(c) Pierre Ossman
> > sdhci-pci 0000:01:00.0: SDHCI controller found [197b:2382] (rev 0)
> > sdhci-pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > sdhci-pci 0000:01:00.0: setting latency timer to 64
> > mmc0: SDHCI controller on PCI [0000:01:00.0] using ADMA
> > sdhci-pci 0000:01:00.2: SDHCI controller found [197b:2381] (rev 0)
> > sdhci-pci 0000:01:00.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> > sdhci-pci 0000:01:00.2: Refusing to bind to secondary interface.
> > sdhci-pci 0000:01:00.2: PCI INT A disabled
> > sdhci-pci 0000:04:00.0: SDHCI controller found [197b:2382] (rev 0)
> > sdhci-pci 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > sdhci-pci 0000:04:00.0: setting latency timer to 64
> > mmc1: SDHCI controller on PCI [0000:04:00.0] using ADMA
> > sdhci-pci 0000:04:00.2: SDHCI controller found [197b:2381] (rev 0)
> > sdhci-pci 0000:04:00.2: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> > sdhci-pci 0000:04:00.2: Refusing to bind to secondary interface.
> > sdhci-pci 0000:04:00.2: PCI INT A disabled
> > ...
> > mmc0: error -84 whilst initialising SD card
> > ...
> > mmc1: error -84 whilst initialising SD card
> > 
> > 
> > Mmm, looking at the logs I have seen that in 2.6.27 shpchp is loaded
> > way before sdhci, and in -git4 it loads after it. Can this have
> > any effect ?
> > 
> > > Rgds
> > 
> > TIA, hope all this gives some light.
> > If you need full dmesg's, just ask.
> 
> Is this still a problem in mainline?
> 
> I understand from your postings that 2.6.27 is OK, correct?
> 

I solved this in modprobe.conf:

options sdhci debug_quirks=1

If I uderstood the source, that touches the controller clock on each reset for
the operation to work.

2.6.28-rc2 still doesn't see the card without that option.

And there is another problem, -rc2 doesn't reboot on the One, but that's for
another thread (don't know if it can be related).

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2009.0 (Cooker) for i586
Linux 2.6.25-jam18 (gcc 4.3.1 20080626 (GCC) #1 SMP

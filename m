Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289Ab0AEWVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab0AEWVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 17:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183Ab0AEWVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 17:21:17 -0500
Received: from pc-249.acfr.usyd.edu.au ([129.78.210.249]:56974 "EHLO
	rosaceae.acfr.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab0AEWVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 17:21:16 -0500
From: Alex Brooks <a.brooks@marathon-robotics.com>
Organization: Marathon Robotics
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: BAR 0: can't allocate resource
Date: Wed, 6 Jan 2010 09:19:47 +1100
User-Agent: KMail/1.9.9
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001052018.02607.a.brooks@marathon-robotics.com> <201001051033.19486.bjorn.helgaas@hp.com>
In-Reply-To: <201001051033.19486.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Es7QLQVb4Q48UtH"
Message-Id: <201001060919.48453.a.brooks@marathon-robotics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Es7QLQVb4Q48UtH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> > I have a problem getting a couple of PCI cards to play nicely together.
> > ...
> >
> > And (for both kernels) the output of lspci has the following line:
> >   01:04.0 Unclassified device [0080]: Device 0002:0080
>
> When you have only the 8-port serial card installed, it appears at
> 01:04.0.  When you have both cards installed, we don't see a new device,
> and whatever is at 01:04.0 no longer looks like the octal UART.

I'm pretty sure that it is the octal UART, but it isn't being recognised 
properly.  To test this theory, I tried with (a) no cards at all, and (b) 
just the MiniPCI adapter (no serial card) -- nothing else appears at 01:04.0 
(output of lspci attached).

> > Hardware Details:
> >  - My motherboard is a DigitalLogic MSM945.  It has a PC104 bus.
> >  - I have two PC104 cards:
> >    i)  8-port serial card (DiamondSystems Emerald-MM-8Plus)
> >    ii) PC/104+ to MiniPCI Adapter (ConnectTech) (no MiniPCI cards
> > installed).
>
> Do you have these two cards?
>
>   http://www.diamondsystems.com/products/emeraldmm8plus,
>   http://www.connecttech.com/sub/Products/PC104plus_MiniPCI.asp

Yes that's right.

> If so, both of those web pages mention jumpers that set the card's
> PCI device ("slot") number.  My guess is that both of your cards
> are set to the same number.

I'd already looked for this, I'm certain I have the jumpers right (I tried 
intentionally setting them incorrectly, the failure mode is different).


Alex

--Boundary-00=_Es7QLQVb4Q48UtH
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_noserial.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_noserial.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)

--Boundary-00=_Es7QLQVb4Q48UtH
Content-Type: text/plain;
  charset="iso 8859-15";
  name="lspci_nocards.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="lspci_nocards.txt"

00:00.0 Host bridge: Intel Corporation Mobile 945GME Express Memory Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile 945GME Express Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
00:1f.0 ISA bridge: Intel Corporation 82801GHM (ICH7-M DH) LPC Interface Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
01:08.0 Ethernet controller: Intel Corporation PRO/100 VM Network Connection (rev 01)

--Boundary-00=_Es7QLQVb4Q48UtH--

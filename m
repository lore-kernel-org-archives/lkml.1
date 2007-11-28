Return-Path: <linux-kernel-owner+w=401wt.eu-S1760822AbXK1Wnv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbXK1Wnv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:43:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbXK1Wno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:43:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50834 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbXK1Wnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:43:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Frederik Himpe <fhimpe@telenet.be>
Subject: Re: 2.6.24-rc3-git3: usb hardware interrupts using 25% of CPU time
Date: Thu, 29 Nov 2007 00:02:01 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
References: <pan.2007.11.28.22.33.18@telenet.be>
In-Reply-To: <pan.2007.11.28.22.33.18@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711290002.01850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 of November 2007, Frederik Himpe wrote:
> I installed Linux 2.6.24-rc3-git3 on a PPC based Apple Powerbook G4 
> system. Now with top I see that over 20% of CPU time is used by hardware 
> interrupts. Looking at /proc/interrupts, the number in the row 
> ohci_hcd:usb1 is rising very quickly:

What's the last kernel that worked correctly?


> $ cat /proc/interrupts 
>            CPU0       
>  21:          1   MPIC 1    Edge      i2sbus: i2s-a (tx)
>  24:      11008   MPIC 1    Level     ide1
>  25:      33608   MPIC 1    Level     VIA-PMU
>  26:         56   MPIC 1    Level     keywest i2c
>  27:          1   MPIC 1    Edge      i2sbus: i2s-a (rx)
>  29:     281578   MPIC 1    Level     ohci_hcd:usb1
>  30:          0   MPIC 1    Level     i2sbus: i2s-a (control)
>  31:          0   MPIC 1    Level     i2sbus: i2s-b (control)
>  33:          1   MPIC 1    Edge      i2sbus: i2s-b (tx)
>  34:          1   MPIC 1    Edge      i2sbus: i2s-b (rx)
>  39:      41611   MPIC 1    Level     ide0
>  40:          2   MPIC 1    Level     ohci1394
>  41:          0   MPIC 1    Level     eth0
>  42:          0   MPIC 1    Level     keywest i2c
>  47:       2826   MPIC 1    Level     GPIO1 ADB
>  48:      58633   MPIC 1    Level     radeon@pci:0000:00:10.0
>  52:      18961   MPIC 1    Level     b43
>  53:          1   MPIC 1    Level     yenta
>  61:          1   MPIC 1    Edge      headphone-detect
>  63:          0   MPIC 1    Level     ohci_hcd:usb2, ohci_hcd:usb3, 
> ehci_hcd:usb4
> BAD:     187917
> 
> $ lspci -nn
> 0000:00:0b.0 Host bridge [0600]: Apple Computer Inc. UniNorth 2 AGP 
> [106b:0034]
> 0000:00:10.0 VGA compatible controller [0300]: ATI Technologies Inc RV350 
> [Mobility Radeon 9600 M10] [1002:4e50]
> 0001:10:0b.0 Host bridge [0600]: Apple Computer Inc. UniNorth 2 PCI 
> [106b:0035]
> 0001:10:12.0 Network controller [0280]: Broadcom Corporation BCM4306 
> 802.11b/g Wireless LAN Controller [14e4:4320] (rev 03)
> 0001:10:13.0 CardBus bridge [0607]: Texas Instruments PCI1510 PC card 
> Cardbus Controller [104c:ac56]
> 0001:10:17.0 Unknown class [ff00]: Apple Computer Inc. KeyLargo/Intrepid 
> Mac I/O [106b:003e]
> 0001:10:19.0 USB Controller [0c03]: Apple Computer Inc. KeyLargo/Intrepid 
> USB [106b:003f]
> 0001:10:1a.0 USB Controller [0c03]: Apple Computer Inc. KeyLargo/Intrepid 
> USB [106b:003f]
> 0001:10:1b.0 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 
> 43)
> 0001:10:1b.1 USB Controller [0c03]: NEC Corporation USB [1033:0035] (rev 
> 43)
> 0001:10:1b.2 USB Controller [0c03]: NEC Corporation USB 2.0 [1033:00e0] 
> (rev 04)
> 0002:24:0b.0 Host bridge [0600]: Apple Computer Inc. UniNorth 2 Internal 
> PCI [106b:0036]
> 0002:24:0d.0 Unknown class [ff00]: Apple Computer Inc. UniNorth/Intrepid 
> ATA/100 [106b:003b]
> 0002:24:0e.0 FireWire (IEEE 1394) [0c00]: Apple Computer Inc. UniNorth 2 
> FireWire [106b:0031] (rev 81)
> 0002:24:0f.0 Ethernet controller [0200]: Apple Computer Inc. UniNorth 2 
> GMAC (Sun GEM) [106b:0032] (rev 80)
> 
> 
> Full dmesg, .config and lsmod output can be found on 
> http://artipc10.vub.ac.be/linux-2.6.24-rc3-git3/

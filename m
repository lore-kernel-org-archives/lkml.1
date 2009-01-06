Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbZAFHfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbZAFHfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 02:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750796AbZAFHey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 02:34:54 -0500
Received: from nn7.de ([85.214.94.156]:38623 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbZAFHex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 02:34:53 -0500
Subject: Re: Intel e1000e: eth0: Detected Tx Unit Hang
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <4807377b0901051638r7b31ac62r2165bbe589c04a50@mail.gmail.com>
References: <1230839773.8319.12.camel@localhost>
	 <4807377b0901051638r7b31ac62r2165bbe589c04a50@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 08:34:43 +0100
Message-Id: <1231227283.7107.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 16:38 -0800, Jesse Brandeburg wrote:
> On Thu, Jan 1, 2009 at 11:56 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > Dear list,

Dear Jesse,

> > I just recently observed a strange problem with an onboard 82567LF-2
> > Intel ethernet controller. It completely stopped working and this
> > desktop machine required a powerdown to get it to work again. This
> > happened with 2.6.27.10. However, the machine was working for weeks
> > before using an older kernel version (2.6.27.*, no binary modules, intel
> > skyburg mainboard, e8400 c2d cpu).
> >
> > Relevant details follow, can someone make sense of this?
> 
> what does cat /proc/interrupts say?

$ uptime
08:10:46 up 4 days, 11:34,  6 users,  load average: 0.83, 0.87, 0.89

$ cat /proc/interrupts 
           CPU0       CPU1       
  0:        659        653   IO-APIC-edge      timer
  1:          1          1   IO-APIC-edge      i8042
  8:          0          1   IO-APIC-edge      rtc0
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          2          1   IO-APIC-edge      i8042
 16:    5058866    5065629   IO-APIC-fasteoi   uhci_hcd:usb3
 17:         14         14   IO-APIC-fasteoi   HDA Intel
 18:        372        390   IO-APIC-fasteoi   ehci_hcd:usb1,
uhci_hcd:usb5, uhci_hcd:usb8
 19:          0          0   IO-APIC-fasteoi   uhci_hcd:usb7
 20:    7922691    7927065   IO-APIC-fasteoi   saa7146 (0)
 21:   33168354   33168257   IO-APIC-fasteoi   uhci_hcd:usb4, saa7146
(1)
 22:  244360273  244341840   IO-APIC-fasteoi   HDA Intel, saa7146 (2)
 23:          0          0   IO-APIC-fasteoi   ehci_hcd:usb2,
uhci_hcd:usb6
509:   23282093   23290682   PCI-MSI-edge      eth0
510:   23874175   23873081   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:  147852851  146009672   Local timer interrupts
RES:     758105     701724   Rescheduling interrupts
CAL:    1181574    1176862   function call interrupts
TLB:     230633     153469   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

> please also include at least ethtool -e eth0 length 256,

# ethtool -e eth0 length 256

Offset		Values
------		------
0x0000		XX XX XX XX XX XX 00 08 ff ff 85 10 ff ff ff ff 
0x0010		ff ff ff ff c3 10 01 50 86 80 cd 10 86 80 00 00 
0x0020		01 0d 00 00 00 00 05 86 20 30 00 0a 00 00 07 8d 
0x0030		84 06 40 2b 43 00 00 00 cc 10 ad ba cc 10 cd 10 
0x0040		ad ba ce 10 ad ba ad ba 00 00 00 00 00 00 00 00 
0x0050		00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
0x0060		00 01 00 40 16 13 07 40 ff ff ff ff ff ff ff ff 
0x0070		ff ff ff ff ff ff ff ff ff ff 00 01 ff ff 8b 2c 
0x0080		20 60 1f 00 02 00 13 00 00 80 1d 00 ff 00 16 00 
0x0090		22 99 18 00 11 20 17 00 dd dd 18 00 12 20 17 00 
0x00a0		00 80 1d 00 00 00 1f 00 ff ff ff ff ff ff ff ff 
0x00b0		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
0x00c0		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
0x00d0		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
0x00e0		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 
0x00f0		ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff 

>  do you have
> the IOMMU enabled?  your full dmesg would let me know.

$ zgrep -i iommu /proc/config.gz 
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_DEBUG is not set

> also, please double check you're running the latest BIOS for your motherboard.

indeed there seems to be an update to version 1.06 for this mainboard
(DP45SG), so hopefully this goes away

$ dmesg | grep -i calg

Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!

$ dmesg | grep -i bug
pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001

even though I don't find any insight in the changelog:

http://downloadmirror.intel.com/17218/eng/SG_0106_ReleaseNotes.pdf

> > 00:19.0 Ethernet controller: Intel Corporation 82567LF-2 Gigabit Network Connection
> >
> > $ dmesg | grep relevant parts
> >
> > Intel(R) PRO/1000 Network Driver - version 7.3.20-k3-NAPI
> > e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
> > 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> > Intel(R) Gigabit Ethernet Network Driver - version 1.2.45-k2
> >
> > 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) XX:XX:XX:XX:XX:XX
> > 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
> > 0000:00:19.0: eth0: MAC: 5, PHY: 8, PBA No: ffffff-0ff
> > ADDRCONF(NETDEV_UP): eth0: link is not ready
> > 0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
> > ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> > [...]
> > [uptime of a couple of days, with lots of network i/o]
> > [...]
> > saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> > saa7146 (1) saa7146_i2c_writeout [irq]: timed out waiting for end of xfer
> > 0000:00:19.0: eth0: Detected Tx Unit Hang:
> >  TDH                  <ff>
> >  TDT                  <1>
> >  next_to_use          <1>
> >  next_to_clean        <ff>
> > buffer_info[next_to_clean]:
> >  time_stamp           <1104ec2c3>
> >  next_to_watch        <ff>
> >  jiffies              <1104ec8f0>
> >  next_to_watch.status <0>
> 
> <snip> lots of hangs...
> 
> what is the frequency of the hangs?  What kind of traffic are you using?

Very low frequency (I posted all there was after about 4hrs), traffic
with about 10MBit/s downloading data from the net. 

As I said, this so far only happened once and the machine is up since
the middle/late of October (IIRC with 2.6.27.3 at that time and recently
since end of december .10).

Soeren

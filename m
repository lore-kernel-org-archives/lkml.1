Return-Path: <linux-kernel-owner+w=401wt.eu-S935167AbXLTSEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167AbXLTSEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762569AbXLTSEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:04:14 -0500
Received: from mx1.redhat.com ([66.187.233.31]:48075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbXLTSEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:04:13 -0500
Message-ID: <476AAE99.7090301@redhat.com>
Date: Thu, 20 Dec 2007 13:04:09 -0500
From: Tony Camuso <tcamuso@redhat.com>
Reply-To: tcamuso@redhat.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [Fwd: Re: [PATCH 0/5]PCI: x86 MMCONFIG]
References: <476A5FD0.4010804@redhat.com> <20071220172205.GB5636@suse.de> <20071220173528.GE29690@parisc-linux.org>
In-Reply-To: <20071220173528.GE29690@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Dec 20, 2007 at 09:22:05AM -0800, Greg KH wrote:
> 
> I can't imagine there are too many machines with MMCONFIG and an i830
> chipset.  The laptop I'm currently typing on is an i830 ... and its
> BIOS is from 2002, well predating the specification of MMCONFIG. If I
> didn't know better, I'd accuse Tony of lying about the existance of
> such a machine ;-)
> 
Sorry, that was the 82Q963/Q965 graphics controller, PCI ID 2992.

I can't remember why I thought PCI ID 2992 maps to 830M/MG. I think
it was in some intel doc about the ICH8 or ICH9.

Nevertheless, I have an hp dc5700 microtower right here on the floor
next to me, and it hangs when the bus sizing code does an mmconfig
write to the BAR at offset 0x18 in this device (id 2992).

It hangs in exactly the same place every time.

I am surmising that the write to that BAR is causing a MCE.

Here is the lspci output of the dc5700. The misbehaving device is
00:02.0

[root@localhost ~]# lspci
00:00.0 Host bridge: Intel Corporation 82Q963/Q965 Memory Controller Hub
(rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82Q963/Q965
Integrated Graphics Controller (rev 02)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
#4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
#5 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
#2 (rev 02)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 02)
00:1c.1 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 2 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
#1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI
#2 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI
#1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface
Controller (rev 02)
00:1f.2 IDE interface: Intel Corporation 82801H (ICH8 Family) 4 port
SATA IDE Controller (rev 02)
00:1f.5 IDE interface: Intel Corporation 82801H (ICH8 Family) 2 port
SATA IDE Controller (rev 02)
3f:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5755
Gigabit Ethernet PCI Express (rev 02)

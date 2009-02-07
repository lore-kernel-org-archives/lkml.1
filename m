Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZBGIfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZBGIfA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 03:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbZBGIev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 03:34:51 -0500
Received: from serv04.lahn.de ([213.239.197.57]:40526 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbZBGIeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 03:34:50 -0500
Date: Sat, 7 Feb 2009 09:34:48 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: WOL with forcedeth broken since
	f55c21fd9a92a444e55ad1ca4e4732d56661bf2e
Message-ID: <20090207083448.GB5204@pmhahn.de>
Mail-Followup-To: Yinghai Lu <yinghai@kernel.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20090205232343.GA9455@pmhahn.de> <200902060113.31651.rjw@sisk.pl> <a47yn9c9JrF.A.hz.L5YiJB@chimera> <20090129063118.GA3586@pmhahn.de> <CGyEB0S4BpO.A.MFB.R5YiJB@chimera> <86802c440901292253ie9e2a9dmb4580a3da1480c81@mail.gmail.com> <20090205232343.GA9455@pmhahn.de> <86802c440902051535n118339bes88ae48a54ce4711a@mail.gmail.com> <20090206053320.GA4369@pmhahn.de> <20090206065912.GA3614@pmhahn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090206065912.GA3614@pmhahn.de>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HellO!

On Fri, Feb 06, 2009 at 07:59:12AM +0100, Philipp Matthias Hahn wrote:
> I did some structured tesing:

Here are my captured console logs:
scout=Desktop with nVidia Corporation MCP51 Ethernet Controller (rev a3)
euro=Laptop used for capturing and wakeup

(initramfs) modprobe forcedeth
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
forcedeth 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:14.0: setting latency timer to 64
nv_probe: MAC_ADDR_REV ELSE
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:db:f2:e1:35
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
(initramfs) ethtool -s eth0 wol g
(initramfs) poweroff
...
forcedeth 0000:00:14.0: PCI INT A disabled
forcedeth 0000:00:14.0: PME# enabled
forcedeth 0000:00:14.0: wake-up capability enabled by ACPI
ACPI: Preparing to enter system sleep state S5
...
Power down.
acpi_power_off called

euro:~# etherwake -i eth0 00:19:db:f2:e1:35 # FAIL
euro:~# etherwake -i eth0 35:e1:f2:db:19:00 # FAIL


(initramfs) modprobe forcedeth
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
forcedeth 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:14.0: setting latency timer to 64
nv_probe: MAC_ADDR_REV ELSE
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:db:f2:e1:35
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
(initramfs) ethtool -s eth0 wol g
(initramfs) echo o > /proc/sysrq-trigger
SysRq : Power Off
...
forcedeth 0000:00:14.0: PCI INT A disabled
forcedeth 0000:00:14.0: PME# enabled
forcedeth 0000:00:14.0: wake-up capability enabled by ACPI
ACPI: Preparing to enter system sleep state S5
...
Power down.
acpi_power_off called

euro:~# etherwake -i eth0 00:19:db:f2:e1:35 # FAIL
euro:~# etherwake -i eth0 35:e1:f2:db:19:00 # FAIL


(initramfs) modprobe forcedeth
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
forcedeth 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:14.0: setting latency timer to 64
nv_probe: MAC_ADDR_REV ELSE
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:db:f2:e1:35
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
(initramfs) ethtool -s eth0 wol g
(initramfs) echo b > /proc/sysrq-trigger
SysRq : Resetting
(grub) halt

euro:~# etherwake -i eth0 35:e1:f2:db:19:00 # FAIL
euro:~# etherwake -i eth0 00:19:db:f2:e1:35 # SUCCESS


(initramfs) modprobe forcedeth
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 23
forcedeth 0000:00:14.0: PCI INT A -> Link[LMAC] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:14.0: setting latency timer to 64
nv_probe: MAC_ADDR_REV ELSE
nv_probe: set workaround bit for reversed mac addr
forcedeth 0000:00:14.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:19:db:f2:e1:35
forcedeth 0000:00:14.0: highdma pwrctl timirq gbit lnktim desc-v3
(initramfs) ethtool -s eth0 wol g
(initramfs) exit
...
scout:~# poweroff
...
forcedeth 0000:00:14.0: PCI INT A disabled
forcedeth 0000:00:14.0: PME# enabled
forcedeth 0000:00:14.0: wake-up capability enabled by ACPI
ACPI: Preparing to enter system sleep state S5
...
Power down.
acpi_power_off called

euro:~# etherwake -i eth0 00:19:db:f2:e1:35 # FAIL
euro:~# etherwake -i eth0 35:e1:f2:db:19:00 # SUCCESS

BYtE
Philipp Hahn
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de

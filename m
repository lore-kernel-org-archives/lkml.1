Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXJUNeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXJUNeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 09:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbXJUNeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 09:34:16 -0400
Received: from hpsmtp-eml13.KPNXCHANGE.COM ([213.75.38.113]:16253 "EHLO
	hpsmtp-eml13.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbXJUNeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 09:34:15 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Why are ipmi modules being loaded?
Date: Sun, 21 Oct 2007 15:34:11 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TV1GHlE5blZ2ffO"
Message-Id: <200710211534.11817.elendil@planet.nl>
X-OriginalArrivalTime: 21 Oct 2007 13:34:12.0028 (UTC) FILETIME=[10CCA7C0:01C813E7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TV1GHlE5blZ2ffO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Last week I sent this same question to the openipmi-developer list on 
sourceforge, but did not get any replies.
Does anyone here know the answer?

========
AFAICT my system does not support ipmi, but despite that fact something is 
loading the ipmi_msghandler module and trying to load the ipmi_si module.

The second fails, but the first stays loaded. From dmesg:
ipmi message handler version 39.1
[...]
ipmi_si: Trying PCI-specified kcs state machine at mem address 0x90220000, 
slave address 0x0, irq 19
ipmi_si: There appears to be no BMC at this location
ipmi_si: Unable to find any System Interface(s)

This results in powertop showing:
   Top causes for wakeups:
   [...]
      2.1% ( 10.0)   <kernel module> : ipmi_init_msghandler (ipmi_timeout)

AFAICT from modules.pcimap, ipmi_si should only be loaded for PCI ID 
[103c:121a] (which I don't have), or for devices with class c0700 (which I 
also don't have).
I also cannot find anything in /etc that could be responsible.

So I wonder what _is_ responsible for trying to load the ipmi modules on my 
system and if that shouldn't be avoided.

My system is Debian testing running 2.6.23.

Cheers,
Frans Pop

--Boundary-00=_TV1GHlE5blZ2ffO
Content-Type: text/plain;
  charset="utf-8";
  name="lspci.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="lspci.txt"

00:00.0 Host bridge [0600]: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub [8086:2770] (rev 02)
00:02.0 VGA compatible controller [0300]: Intel Corporation 82945G/GZ Integrated Graphics Controller [8086:2772] (rev 02)
00:1b.0 Audio device [0403]: Intel Corporation 82801G (ICH7 Family) High Definition Audio Controller [8086:27d8] (rev 01)
00:1c.0 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 [8086:27d0] (rev 01)
00:1c.2 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 3 [8086:27d4] (rev 01)
00:1c.3 PCI bridge [0604]: Intel Corporation 82801G (ICH7 Family) PCI Express Port 4 [8086:27d6] (rev 01)
00:1c.4 PCI bridge [0604]: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 5 [8086:27e0] (rev 01)
00:1c.5 PCI bridge [0604]: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI Express Port 6 [8086:27e2] (rev 01)
00:1d.0 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #1 [8086:27c8] (rev 01)
00:1d.1 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #2 [8086:27c9] (rev 01)
00:1d.2 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #3 [8086:27ca] (rev 01)
00:1d.3 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB UHCI #4 [8086:27cb] (rev 01)
00:1d.7 USB Controller [0c03]: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller [8086:27cc] (rev 01)
00:1e.0 PCI bridge [0604]: Intel Corporation 82801 PCI Bridge [8086:244e] (rev e1)
00:1f.0 ISA bridge [0601]: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge [8086:27b8] (rev 01)
00:1f.1 IDE interface [0101]: Intel Corporation 82801G (ICH7 Family) IDE Controller [8086:27df] (rev 01)
00:1f.2 SATA controller [0106]: Intel Corporation 82801GR/GH (ICH7 Family) Serial ATA Storage Controller AHCI [8086:27c1] (rev 01)
00:1f.3 SMBus [0c05]: Intel Corporation 82801G (ICH7 Family) SMBus Controller [8086:27da] (rev 01)
01:00.0 Ethernet controller [0200]: Intel Corporation 82573E Gigabit Ethernet Controller (Copper) [8086:108c] (rev 03)
01:00.3 Serial controller [0700]: Intel Corporation Active Management Technology - SOL [8086:108f] (rev 03)
01:00.4 Serial bus controller [0c07]: Intel Corporation 82573E KCS (Active Management) [8086:108e] (rev 03)
06:05.0 FireWire (IEEE 1394) [0c00]: Texas Instruments TSB43AB23 IEEE-1394a-2000 Controller (PHY/Link) [104c:8024]

--Boundary-00=_TV1GHlE5blZ2ffO--

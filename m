Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbYHXObm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbYHXObm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 10:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbYHXObe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 10:31:34 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:9189 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYHXObd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 10:31:33 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org
Subject: Re: resume from ram hangs on 2.6.26+ kernels on thinkpad z60m
Date: Sun, 24 Aug 2008 16:31:14 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200808201602.26848.arekm@maven.pl> <200808211443.43690.rjw@sisk.pl>
In-Reply-To: <200808211443.43690.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808241631.14746.arekm@maven.pl>
X-Agnat-Warning: Use smtp.agnat.eu as SMTP server
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Rafael J. Wysocki wrote:
> On Wednesday, 20 of August 2008, Arkadiusz Miskiewicz wrote:
> > I'm seeing problems with resume (using s2ram) on thinkpad z60m notebook
> > with very fresh git kernel (built yesterday). It looks like this - I get
> > screen resumed with X window running on it, I see mouse pointer but
> > pointer doesn't react to movement and sysrq keys also don't respond
> > (tried to
> > umount+sync+reboot via sysrq).
> >
> > The hangs doesn't always happen but it happens quite often (often enough
> > to get kmail trashed several times).
> >
> > The problem is also happening on 2.6.26 kernels (I wasn't testing .26 too
> > much).
> >
> > Now I'm back on 2.6.25 where the problem doesn't occur.
> >
> > I didn't see any reports related  to that on lkml which is bad thing 8)
> >
> > Any ideas?
>
> Not really.  We must have broken something in 2.6.26, but there were not
> too many suspend-specific patches in there vs .25.

Ok, will get back to the problem when I get/notice something that can get us a 
clue.

> What s2ram options are used?

None.

>
> What hardware is there in the box (chipset, graphics)?

[arekm@tarm ~]$ lspci
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express 
Processor to DRAM Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation Mobile 915GM/PM Express PCI Express Root 
Port (rev 03)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
High Definition Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI 
Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI 
Express Port 2 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI 
Express Port 3 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI 
Express Port 4 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) 
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge 
(rev 03)
00:1f.2 IDE interface: Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 
03)
00:1f.3 SMBus: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus 
Controller (rev 03)
01:00.0 VGA compatible controller: ATI Technologies Inc M24 1P [Radeon 
Mobility X600]
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5751M Gigabit 
Ethernet PCI Express (rev 11)
14:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b3)
14:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C552 IEEE 1394 Controller (rev 
08)
14:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host 
Adapter (rev 17)
14:00.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter 
(rev 08)
14:02.0 Network controller: Intel Corporation PRO/Wireless 2915ABG Network 
Connection (rev 05)

[arekm@tarm ~]$ lsusb
Bus 005 Device 001: ID 1d6b:0001
Bus 004 Device 002: ID 0483:2016 SGS Thomson Microelectronics Fingerprint 
Reader
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 002: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Bus 003 Device 001: ID 1d6b:0001
Bus 002 Device 001: ID 1d6b:0001
Bus 001 Device 001: ID 1d6b:0002


> Thanks,
> Rafael

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

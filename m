Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbXFDPCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbXFDPCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXFDPCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:02:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:28973 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbXFDPCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:02:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=rlrxFMLSez+SJPyM3zltOzbcNfAYvrwpUYPMbqO2exWGCoRdYWPxQ0H4Rv7L9nfsQxbmYLCWeSXnMYw0iRxe+Fb2ok7D8VXnDLtLtyhjT+XBX57Q6T+vuJvvrN2v1eQs9gXBJNG0oKaJgqagy3ujPBhrQZfmdwtP9DPwxzP6YaE=
Message-ID: <46642977.6020704@gmail.com>
Date: Mon, 04 Jun 2007 17:02:15 +0200
From: Trifon Trifonov <triffon@gmail.com>
User-Agent: Mozilla Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: uhci_hcd: host system error
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am using kernel 2.6.20-16 (Ubuntu Feisty). Occasionally I am getting 
USB host controller halts. If I manually remove and reinsert the 
uhci_hcd module, everything is back to normal. I recompiled the kernel 
with the CONFIG_USB_DEBUG option on and waited until a halt occurred. 
The devices I had connected were:

Bus 005 Device 002: ID eb1a:2750 eMPIA Technology, Inc.
Bus 005 Device 001: ID 0000:0000 
Bus 004 Device 003: ID 045e:008c Microsoft Corp. Wireless Intellimouse 
Explorer 2.0
Bus 004 Device 001: ID 0000:0000 
Bus 003 Device 001: ID 0000:0000 
Bus 002 Device 001: ID 0000:0000 
Bus 001 Device 001: ID 0000:0000 

The entry in the syslog indicating the halt are the following:

Jun  4 16:00:53 localhost kernel: [  355.820000] uhci_hcd 0000:00:1d.3: 
host system error, PCI problems?
Jun  4 16:00:53 localhost kernel: [  355.820000] uhci_hcd 0000:00:1d.3: 
host controller halted, very bad!
Jun  4 16:00:53 localhost kernel: [  355.820000] uhci_hcd 0000:00:1d.3: 
HC died; cleaning up
Jun  4 16:00:53 localhost kernel: [  355.820000] hub 4-0:1.0: state 0 
ports 2 chg 0000 evt 0000
Jun  4 16:00:53 localhost kernel: [  355.820000] usb 4-1: USB 
disconnect, address 2
Jun  4 16:00:53 localhost kernel: [  355.820000] usb 4-1: unregistering 
device
Jun  4 16:00:53 localhost kernel: [  355.820000] usb 4-1: 
usb_disable_device nuking all URBs
Jun  4 16:00:53 localhost kernel: [  355.820000] uhci_hcd 0000:00:1d.3: 
shutdown urb dfc4a840 pipe 40408280 ep1in-intr
Jun  4 16:00:53 localhost kernel: [  355.824000] usb 4-1: unregistering 
interface 4-1:1.0
Jun  4 16:00:53 localhost kernel: [  355.824000]  usbdev4.2_ep81: 
ep_device_release called for usbdev4.2_ep81
Jun  4 16:00:53 localhost kernel: [  355.824000] usb 4-1:1.0: uevent
Jun  4 16:00:53 localhost kernel: [  355.824000]  usbdev4.2_ep00: 
ep_device_release called for usbdev4.2_ep00
Jun  4 16:00:53 localhost kernel: [  355.824000] usb 4-1: uevent

I also used debugfs to monitor to status of the hubs. After the halt, 
the 0000:00:1d.3 had the following content:

Root-hub state: reset   FSBR: 0
HC status
  usbcmd    =     0000   Maxp32
  usbstat   =     0020   HCHalted
  usbint    =     0000
  usbfrnum  =   (0)000
  flbaseadd = 1fd04000
  sof       =       40
  stat1     =     01a3   LowSpeed ConnectChange Connected
  stat2     =     0080 
Most recent frame: 54cb9 (185)   Last ISO frame: 54cb9 (185)

After the manual reset of the host controllers, the file contained

Root-hub state: running   FSBR: 0
HC status
  usbcmd    =     00c1   Maxp64 CF RS
  usbstat   =     0000  
  usbint    =     000f
  usbfrnum  =   (1)ef0
  flbaseadd = 1acf4ef0
  sof       =       40
  stat1     =     01a5   LowSpeed Enabled Connected
  stat2     =     0080 
Most recent frame: 2b76f (879)   Last ISO frame: 2b76f (879)

I don't think that the device connected actually matters, because I have 
had the same halts with different devices. Here is the relevant output 
from lspci -vv:

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#1 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Elitegroup Computer Systems Unknown device 0f69
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin A routed to IRQ 19
    Region 4: I/O ports at ec00 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#2 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Elitegroup Computer Systems Unknown device 0f69
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin B routed to IRQ 20
    Region 4: I/O ports at e880 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#3 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Elitegroup Computer Systems Unknown device 0f69
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin C routed to IRQ 21
    Region 4: I/O ports at e800 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
#4 (rev 02) (prog-if 00 [UHCI])
    Subsystem: Elitegroup Computer Systems Unknown device 0f69
    Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin D routed to IRQ 22
    Region 4: I/O ports at e480 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
    Subsystem: Elitegroup Computer Systems Unknown device 0f69
    Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
    Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
    Latency: 0
    Interrupt: pin C routed to IRQ 21
    Region 0: Memory at ffefbc00 (32-bit, non-prefetchable) [size=1K]
    Capabilities: [50] Power Management version 2
        Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
        Status: D0 PME-Enable- DSel=0 DScale=0 PME-
    Capabilities: [58] Debug port

Can anyone suggest what the problem could be? Could I hope for any fix 
(or a quirk), which could overcome the crashes?

When replying, please CC: my email. Thank you.

Trifon Trifonov

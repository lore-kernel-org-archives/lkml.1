Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXAWQm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXAWQm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 11:42:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932943AbXAWQm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 11:42:29 -0500
Received: from dearchitettura.housing.tomato.it ([213.92.90.87]:52765 "EHLO
	mail.dearchitettura.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932950AbXAWQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 11:42:27 -0500
X-Greylist: delayed 1461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jan 2007 11:42:27 EST
From: "Emiliano Gabrielli (aka AlberT)" <AlberT@superalbert.it>
Organization: SuperAlberT.it
To: linux-kernel@vger.kernel.org
Subject: LSISAS1068 controller reset (mptsas driver)
Date: Tue, 23 Jan 2007 17:16:58 +0100
User-Agent: KMail/1.9.5
X-Face: #NQ<a)X@9[~+Z+ZJLTxV(#'AIYGKIVASGP^Zx#fJv^,T?3VoNP~|~4y][1BTmQwCzH:(=?iso-8859-15?q?XL=0A=09u7q6+i=601ig4K/W/=23?=)9CTT94{b!@cRW+Uc^~\|:cC6{wMrFT$`T.~_n)=?iso-8859-15?q?a6=3FsjRN=23t=3Dvg1=23Y=0A=097dR?=)9YW=]6Z]G%2:h5|>uAoVQip.R/@[cVEGhZ^Eym88P(*70$R.#W:-w#y\Q3L$[#*R)=?iso-8859-15?q?t=0A=09=3BcU?=>IAPT&pb=cBn'T^!df3pjHBd>^"h@SP@grIPp@53Fg`{JXu~(=?iso-8859-15?q?=5EN5jh=7B4a8I=25m=239=7E=3Dkq=0A=09=7CuMq?=>2F
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701231716.58852.AlberT@superalbert.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
  I'm not subscribed to the list .. so plz CC: to me on answer

I'm having some problems with the LSISAS1068 controller (on a Dell PowerEdge 
860 havind 2 SAS HD in HW raid 1)...

dmesg gives a number of the following errors:

sd 0:8:0:0:
        command: cdb[0]=0x2a: 2a 00 04 29 49 14 00 00 02 00
mptscsih: ioc0: task abort: SUCCESS (sc=cf5cf080)
mptscsih: ioc0: attempting task abort! (sc=cf5cf080)
sd 0:8:0:0:
        command: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=cf5cf080)
mptscsih: ioc0: attempting target reset! (sc=cf5cf080)
sd 0:8:0:0:
        command: cdb[0]=0x2a: 2a 00 04 29 49 14 00 00 02 00
mptscsih: ioc0: target reset: SUCCESS (sc=cf5cf080)
mptscsih: ioc0: attempting task abort! (sc=cf5cf080)
sd 0:8:0:0:
        command: cdb[0]=0x0: 00 00 00 00 00 00
mptscsih: ioc0: task abort: SUCCESS (sc=cf5cf080)
mptscsih: ioc0: Attempting host reset! (sc=cf5cf080)
mptbase: Initiating ioc0 recovery


The machine hangs during the problem, but after the host reset everithing 
comes back to normality untill the next time the problem arise..

Dell seems not to know nothing about a bug, and they think about a driver 
problem (the firmware revision is the last one available)..

Anybody knows something about the problem and a possible solution?

Additional info:

vp1:~# uname -a
Linux vp1 2.6.16.29-xen0 #15 SMP Tue Oct 31 19:10:50 CET 2006 i686 GNU/Linux

vp1:~# hwinfo --storage
24: PCI 208.0: 0100 SCSI storage controller
  [Created at pci.244]
  Unique ID: oxTw.YyU0P+giqs5
  Parent ID: VCu0.YXdx3wZz9v9
  SysFS ID: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/0000:02:08.0
  SysFS BusID: 0000:02:08.0
  Hardware Class: storage
  Model: "ATI SCSI storage controller"
  Vendor: pci 0x1000 "LSI Logic / Symbios Logic"
  Device: pci 0x0054
  SubVendor: pci 0x1028 "ATI Technologies Inc"
  SubDevice: pci 0x1f09
  Revision: 0x01
  Driver: "mptsas"
  I/O Ports: 0xec00-0xecff (rw,disabled)
  Memory Range: 0xfe9fc000-0xfe9fffff (rw,non-prefetchable)
  Memory Range: 0xfe9e0000-0xfe9effff (rw,non-prefetchable)
  Memory Range: 0xfea00000-0xfeafffff (ro,prefetchable,disabled)
  IRQ: 16 (692766 events)
  Config Status: cfg=new, avail=yes, need=no, active=unknown
  Attached to: #22 (PCI bridge)

vp1:~# lspci -vv -s 02:08.0
0000:02:08.0 SCSI storage controller: LSI Logic / Symbios Logic: Unknown 
device 0054 (rev 01)
        Subsystem: Dell: Unknown device 1f09
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (16000ns min, 2500ns max), Cache Line Size: 0x10 (64 
bytes)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at ec00 [disabled] [size=256]
        Region 1: Memory at fe9fc000 (64-bit, non-prefetchable) [size=16K]
        Region 3: Memory at fe9e0000 (64-bit, non-prefetchable) [size=64K]
        Expansion ROM at fea00000 [disabled] [size=1M]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [98] Message Signalled Interrupts: 64bit+ Queue=0/0 
Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [68] PCI-X non-bridge device.
                Command: DPERE- ERO- RBC=0 OST=6
                Status: Bus=2 Dev=8 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=2, DMOST=6, DMCRS=4, RSCEM-
        Capabilities: [b0] #11 [0000]


Thank you in advance for any tip

PS:
I'm not subscribed to the list .. plz CC: to me on answer


-- 
<?php echo '     Emiliano Gabrielli (aka AlberT)     ',"\n",
'              socio fondatore del GrUSP             ',"\n",
' AlberT_at_SuperAlberT_it   -   www.SuperAlberT.it  ',"\n",
'  IRC:    #php,#AES azzurra.com ',"\n",'ICQ: 158591185'; ?>


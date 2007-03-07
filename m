Return-Path: <linux-kernel-owner+w=401wt.eu-S2992500AbXCGTsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992500AbXCGTsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992517AbXCGTsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:48:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:39251 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992500AbXCGTsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:48:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id:sender;
        b=UCqqlfy9f941ju/7ErDLBIbHDa7qaPvp4MV2noPSoOT8+RawHqqgdWoC1oLsNELjSAuwXiArTWy/6v7FCKw9KJzzOQ9GYSuVT81kjRQuWWq2z3elW/JIU1Xytp3jzwHAn2BxGHfvBfzBml0AOwsNP1nA91mzPuZbsOSddUOYL5o=
From: Eric Lacombe <tuxiko@free.fr>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: Linux 2.6.19.2: maybe a bug inside the r8169 network driver (was Re: Linux 2.6.19.2: Freeze with CIFS mount)
Date: Wed, 7 Mar 2007 20:48:29 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steve French <sfrench@us.ibm.com>, Eric Lacombe <tuxiko@free.fr>
References: <OFC7B98576.0C582E30-ON87257274.0014583D-86257274.00153815@us.ibm.com> <20070305221640.GA25369@electric-eye.fr.zoreil.com> <200703061742.36467.tuxiko@free.fr>
In-Reply-To: <200703061742.36467.tuxiko@free.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Ncx7FatjmoRA6Uj"
Message-Id: <200703072048.29398.tuxiko@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Ncx7FatjmoRA6Uj
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

On Tuesday 06 March 2007 17:42:36 Eric Lacombe wrote:
> Hello,
>
> I've just triggered the bug again but _now_ without the nvidia proprietary
> module. Unfortunately, I hadn't enable the DEBUG options yet.
>
> Nevertheless, It seems that the bug was triggered when the NAS was going to
> awake and that 2 user applications wanted to access it during his
> awakening.
>
> Maybe it could give you some clues about where the problem could be (it
> seems to be a deadlock that occur when (maybe) the r8169 driver is waiting
> to serve one application and that an other one reclaim the same type of
> service, dunno...).
>
> I will give you more information and a trace if I can obtain it.

I have some new results.

I can now trigger the bug relatively easily. I can crash the system using the 
assumption that I made previously :

-----------
1. I wait for the NAS to sleep.

2. I access the NAS with the Amarok application to read a mp3 file. This 
action triggers the awakening of the NAS (~3 secs).

3. Before the NAS awakes, I access the NAS from another application : a file 
manager (Konqueror).
I click on the directory that contains the mp3 (which is the same directory 
that is accessed by amarok - this directory contains the mounted cifs volume 
of the NAS).

4. The system freezes.
-------------

Note that I've enabled the following debug options inside the kernel (as you 
suggest) :
CONFIG_DETECT_SOFTLOCKUP, CONFIG_DEBUG_STACK_USAGE, CONFIG_DEBUG_SPINLOCK, 
CONFIG_DEBUG_SPINLOCK_SLEEP, CONFIG_DEBUG_STACKOVERFLOW.

I've also disabled the preemption.

When I proceed to the step 3, I have on the screen a console application that 
display what syslog-ng provide. I tested the console by using the magic sysrq 
(via alt-sysrq-cmd_key), and it prints well.

Unfortunately, when the system crash no trace appear on the console :/

So, I'm stuck with those information. But I hope that they could give you some 
insights.
Also, feel free to give me other stuff that you want I try (however, I could 
not do it before the next week).

Also, I have setup a cron to monitor an ethtool dump of the registers of the 
8169 at regular intervals : each 5 minutes. I join the last part of the file.

Best regards,

	Eric Lacombe

>
> Thanks
>
> 	Eric Lacombe
>
> On Monday 05 March 2007 23:16:40 Francois Romieu wrote:
> > Eric Lacombe <tuxiko@free.fr> :
> > [...]
> >
> > > Also, if you have some new ideas about the problem or what I could try
> > > to trigger it more frequently (I already wake up the NAS as more as I
> > > can, but maybe I could write a script to do that), I would be thankful.
> >
> > You can add more DEBUG options for spinlock and stack usage, disable
> > preempt and pray for a trace before the crash. If you do not have a
> > second host to add more traffic (wrt to bandwidth and/or pps), try to
> > dd your disk and/or your remote storage to /dev/null while watching TV.
> >
> > You are out of luck if it does not crash more easily.



--Boundary-00=_Ncx7FatjmoRA6Uj
Content-Type: text/plain;
  charset="iso-8859-1";
  name="ethtool.result"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ethtool.result"

RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x2a96efa3
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x7ead7be9
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xd2c6370e
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x26dda945
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x7af27d83
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xcf0b80e5
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x232232d1
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x773c0d55
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xcb52cad8
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x1f68aea3
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x737cca6c
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xc79425ad
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x1baa3bc3
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x6fc28720
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xc3d68b35
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x7bcb6000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x17efc4ef
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x7ce2c000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x64ab20d1
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xb8cda99d
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x0ce350fc
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x60f96139
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xb50ea33b
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x09260ace
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0x5d3a8291
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f
RealTek RTL-8169s registers:
------------------------------
0x00: MAC Address                      00:13:46:3b:e5:78
0x08: Multicast Address Filter     0x80000000 0x00000000
0x10: Dump Tally Counter Command   0x41001000 0x00800210
0x20: Tx Normal Priority Ring Addr 0x78399000 0x00000000
0x28: Tx High Priority Ring Addr   0x00022000 0x00108000
0x30: Flash memory read/write                 0x00000000
0x34: Early Rx Byte Count                              0
0x36: Early Rx Status                               0x08
      ERxGood 
0x37: Command                                       0x0c
      Rx on, Tx on
0x3C: Interrupt Mask                              0x807f
      SERR RxFIFO LinkChg RxNoBuf TxErr TxOK RxErr RxOK 
0x3E: Interrupt Status                            0x0000
      
0x40: Tx Configuration                        0x07000600
0x44: Rx Configuration                        0x0000e60e
0x48: Timer count                             0xb152e676
0x4C: Missed packet counter                     0x000000
0x50: EEPROM Command                                0x00
0x51: Config 0                                      0x05
0x52: Config 1                                      0xcd
0x53: Config 2                                      0x10
0x54: Config 3                                      0xa1
0x55: Config 4                                      0x80
0x56: Config 5                                      0x01
0x58: Timer interrupt                         0x00000000
0x5C: Multiple Interrupt Select                   0x0000
0x60: PHY access                              0x80001000
0x64: TBI control and status                  0x00000000
0x68: TBI Autonegotiation advertisement (ANAR)    0x0000
0x6A: TBI Link partner ability (LPAR)             0x0000
0x6C: PHY status                                    0x73
0x84: PM wakeup frame 0            0xe090000a 0xc2100018
0x8C: PM wakeup frame 1            0x80010402 0x00102804
0x94: PM wakeup frame 2 (low)      0x00880000 0x04101c00
0x9C: PM wakeup frame 2 (high)     0x00140608 0x00200205
0xA4: PM wakeup frame 3 (low)      0x10200000 0x00049388
0xAC: PM wakeup frame 3 (high)     0xe4000028 0x20085045
0xB4: PM wakeup frame 4 (low)      0x02000080 0x02800630
0xBC: PM wakeup frame 4 (high)     0x12000002 0x02080802
0xC4: Wakeup frame 0 CRC                          0x3120
0xC6: Wakeup frame 1 CRC                          0xc001
0xC8: Wakeup frame 2 CRC                          0x0400
0xCA: Wakeup frame 3 CRC                          0x05a0
0xCC: Wakeup frame 4 CRC                          0x5005
0xDA: RX packet maximum size                      0x3fff
0xE0: C+ Command                                  0x602b
      RX checksumming
      PCI Multiple RW
0xE2: Interrupt Mitigation                        0x0000
      TxTimer:       0
      TxPackets:     0
      RxTimer:       0
      RxPackets:     0
0xE4: Rx Ring Addr                 0x79ad0000 0x00000000
0xEC: Early Tx threshold                            0x3f

--Boundary-00=_Ncx7FatjmoRA6Uj--

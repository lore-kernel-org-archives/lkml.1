Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbXEXJO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbXEXJO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbXEXJOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:14:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:60167 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754361AbXEXJOR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:14:17 -0400
X-Authenticated: #24081109
X-Provags-ID: V01U2FsdGVkX19zdPlIgQJztH0AS/7AP6Xqa2TmEUeWX3qkh3xtnT
	pGXzBIzsCvMoD9
From: =?utf-8?q?Ren=C3=A9_Peters?= <ice.face@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: SCSI drives, audio CDs and temporary system freeze with AIC7xxx
Date: Thu, 24 May 2007 11:12:55 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705241112.55901.ice.face@gmx.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Inserting of audio CDs causes my system to hang with high I/O-load while 
kded's mediamanagement is running.
Long time later (round about 10-20 minutes) the system comes back again and 
i'm able to play the audio CD. The issue is reproduceable with the following 
drive:
->CD-R   PX-W1210S
Data CD's don't show this behavior.
No system freeze or any other bad behavior with audio CDs after stopping 
kded's mediamanagement by hand. Maybe it is a kernel bug, maybe a bug in 
kded.

Debian kernel 2.6.18.dfsg.1-12etch2 is running, i tried 2.6.21-2 but no 
difference. What can i do?


->devices
 cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST373207LW       Rev: 0003
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: SEAGATE  Model: ST373207LW       Rev: 0003
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: PLEXTOR  Model: CD-R   PX-W1210S Rev: 1.06
  Type:   CD-ROM                           ANSI SCSI revision: 02


->transport settings
 cat /proc/scsi/aic7xxx/0
Adaptec AIC7xxx driver version: 7.0
Adaptec 2940 Ultra2 SCSI adapter
aic7890/91: Ultra2 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 16, SG List Length: 128

Serial EEPROM:
0xc3bb 0xc3bb 0xc3bb 0xc29d 0xc2d8 0xc1bb 0xc1bb 0xc3bb
0xc1bb 0xc1bb 0xc1bb 0xc1bb 0xc1bb 0xc1bb 0xc1bb 0xc1bb
0xb8c5 0x7c1d 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0x84ee

Target 0 Negotiation Settings
        User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
        Goal: 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
        Curr: 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
        Channel A Target 0 Lun 0 Settings
                Commands Queued 180809
                Commands Active 0
                Command Openings 8
                Max Tagged Openings 8
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 80.000MB/s transfers (40.000MHz, offset 127, 16bit)
        Goal: 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
        Curr: 80.000MB/s transfers (40.000MHz, offset 63, 16bit)
        Channel A Target 1 Lun 0 Settings
                Commands Queued 7694
                Commands Active 0
                Command Openings 8
                Max Tagged Openings 8
                Device Queue Frozen Count 0
Target 3 Negotiation Settings
        User: 20.000MB/s transfers (20.000MHz, offset 127)
        Goal: 20.000MB/s transfers (20.000MHz, offset 16)
        Curr: 20.000MB/s transfers (20.000MHz, offset 16)
        Channel A Target 3 Lun 0 Settings
                Commands Queued 482911
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0


->messages
May 24 10:56:01 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 10:56:46 TUX kernel: CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
May 24 10:56:46 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 10:56:47 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 10:56:47 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 10:56:47 TUX kernel: Card was paused
May 24 10:56:47 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 10:56:47 TUX kernel: HCNT = 0xc SCBPTR = 0xa
May 24 10:56:47 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] 
SCSIBUSL[0x50] 
May 24 10:56:47 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 10:56:47 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 10:56:47 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 10:56:47 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 10:56:47 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 10:56:47 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 10:56:47 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 10:56:47 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 10:56:47 TUX kernel: SCB count = 16
May 24 10:56:47 TUX kernel: Kernel NEXTQSCB = 3
May 24 10:56:47 TUX kernel: Card NEXTQSCB = 2
May 24 10:56:47 TUX kernel: QINFIFO entries: 2 0 
May 24 10:56:47 TUX kernel: Waiting Queue entries: 
May 24 10:56:47 TUX kernel: Disconnected Queue entries: 
May 24 10:56:47 TUX kernel: QOUTFIFO entries: 
May 24 10:56:47 TUX kernel: Sequencer Free SCB List: 1 2 7 3 8 6 5 11 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 10:56:47 TUX kernel: Sequencer SCB Info: 
May 24 10:56:47 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   5 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   6 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   8 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 10:56:47 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:47 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:56:47 TUX kernel: SCB_TAG[0xa] 
May 24 10:56:48 TUX kernel:  11 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:48 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:48 TUX kernel: Pending list: 
May 24 10:56:48 TUX kernel:   0 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 10:56:48 TUX kernel: SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 10:56:48 TUX kernel:   2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 10:56:48 TUX kernel: SCB_LUN[0x0] 
May 24 10:56:48 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:56:48 TUX kernel: Kernel Free SCB list: 14 7 1 4 5 8 9 6 11 15 13 12 
May 24 10:56:48 TUX kernel: Untagged Q(3): 10 
May 24 10:56:48 TUX kernel: 
May 24 10:56:48 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 10:56:49 TUX kernel: scsi0:0:0:0: Cmd aborted from QINFIFO
May 24 10:56:49 TUX kernel: aic7xxx_abort returns 0x2002
May 24 10:56:49 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 10:56:49 TUX kernel: CDB: 0x0 0x0 0x0 0x0 0x0 0x0
May 24 10:56:49 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 10:56:49 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 10:56:49 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb8
May 24 10:56:49 TUX kernel: Card was paused
May 24 10:56:49 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 10:56:49 TUX kernel: HCNT = 0xc SCBPTR = 0xa
May 24 10:56:49 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] 
SCSIBUSL[0x50] 
May 24 10:56:49 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 10:56:49 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 10:56:49 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 10:56:49 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 10:56:49 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 10:56:49 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 10:56:49 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 10:56:49 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 10:56:49 TUX kernel: SCB count = 16
May 24 10:56:49 TUX kernel: Kernel NEXTQSCB = 0
May 24 10:56:49 TUX kernel: Card NEXTQSCB = 3
May 24 10:56:49 TUX kernel: QINFIFO entries: 3 2 
May 24 10:56:49 TUX kernel: Waiting Queue entries: 
May 24 10:56:49 TUX kernel: Disconnected Queue entries: 
May 24 10:56:49 TUX kernel: QOUTFIFO entries: 
May 24 10:56:49 TUX kernel: Sequencer Free SCB List: 1 2 7 3 8 6 5 11 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 10:56:49 TUX kernel: Sequencer SCB Info: 
May 24 10:56:49 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   5 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   6 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   8 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:49 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:56:49 TUX kernel: SCB_TAG[0xa] 
May 24 10:56:49 TUX kernel:  11 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:56:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:56:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:56:50 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:56:50 TUX kernel: Pending list: 
May 24 10:58:25 TUX kernel:   2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 10:58:26 TUX kernel: SCB_LUN[0x0] 
May 24 10:58:26 TUX kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 10:58:26 TUX kernel: SCB_LUN[0x0] 
May 24 10:58:26 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:58:26 TUX kernel: Kernel Free SCB list: 14 7 1 4 5 8 9 6 11 15 13 12 
May 24 10:58:26 TUX kernel: Untagged Q(3): 10 
May 24 10:58:26 TUX kernel: 
May 24 10:58:26 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 10:58:26 TUX kernel: scsi0:0:0:0: Cmd aborted from QINFIFO
May 24 10:58:26 TUX kernel: aic7xxx_abort returns 0x2002
May 24 10:58:26 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 10:58:26 TUX kernel: CDB: 0x2a 0x0 0x2 0x7b 0xa7 0x5d 0x0 0x0 0x48 0x0
May 24 10:58:26 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 10:58:26 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 10:58:26 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 10:58:26 TUX kernel: Card was paused
May 24 10:58:26 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 10:58:26 TUX kernel: HCNT = 0xc SCBPTR = 0xa
May 24 10:58:26 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] 
SCSIBUSL[0x50] 
May 24 10:58:27 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 10:58:27 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 10:58:27 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 10:58:27 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 10:58:27 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 10:58:27 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 10:58:27 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 10:58:27 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 10:58:27 TUX kernel: SCB count = 16
May 24 10:58:27 TUX kernel: Kernel NEXTQSCB = 3
May 24 10:58:27 TUX kernel: Card NEXTQSCB = 0
May 24 10:58:27 TUX kernel: QINFIFO entries: 0 
May 24 10:58:27 TUX kernel: Waiting Queue entries: 
May 24 10:58:27 TUX kernel: Disconnected Queue entries: 
May 24 10:58:27 TUX kernel: QOUTFIFO entries: 
May 24 10:58:27 TUX kernel: Sequencer Free SCB List: 1 2 7 3 8 6 5 11 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 10:58:27 TUX kernel: Sequencer SCB Info: 
May 24 10:58:27 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:   5 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB|LID) 
SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:27 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:27 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:27 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:27 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:27 TUX kernel: Pending list: 
May 24 10:58:27 TUX kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 10:58:27 TUX kernel: SCB_LUN[0x0] 
May 24 10:58:27 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:58:27 TUX kernel: Kernel Free SCB list: 2 14 7 1 4 5 8 9 6 11 15 13 
12 
May 24 10:58:27 TUX kernel: Untagged Q(3): 10 
May 24 10:58:27 TUX kernel: 
May 24 10:58:27 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 10:58:27 TUX kernel: scsi0:0:0:0: Cmd aborted from QINFIFO
May 24 10:58:27 TUX kernel: aic7xxx_abort returns 0x2002
May 24 10:58:27 TUX kernel: sr 0:0:3:0: Attempting to queue an ABORT message
May 24 10:58:27 TUX kernel: CDB: 0x12 0x0 0x0 0x0 0x24 0x0 0x0 0x0 0x0 0x0 0x0 
0x0
May 24 10:58:27 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 10:58:27 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 10:58:27 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 10:58:27 TUX kernel: Card was paused
May 24 10:58:27 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 10:58:27 TUX kernel: HCNT = 0xc SCBPTR = 0xa
May 24 10:58:28 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] 
SCSIBUSL[0x50] 
May 24 10:58:28 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 10:58:28 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 10:58:28 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 10:58:28 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 10:58:28 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 10:58:28 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 10:58:28 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 10:58:28 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 10:58:28 TUX kernel: SCB count = 16
May 24 10:58:28 TUX kernel: Kernel NEXTQSCB = 0
May 24 10:58:28 TUX kernel: Card NEXTQSCB = 0
May 24 10:58:28 TUX kernel: QINFIFO entries: 
May 24 10:58:28 TUX kernel: Waiting Queue entries: 
May 24 10:58:28 TUX kernel: Disconnected Queue entries: 
May 24 10:58:28 TUX kernel: QOUTFIFO entries: 
May 24 10:58:28 TUX kernel: Sequencer Free SCB List: 1 2 7 3 8 6 5 11 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 10:58:28 TUX kernel: Sequencer SCB Info: 
May 24 10:58:28 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   5 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   6 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   8 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:58:28 TUX kernel: SCB_TAG[0xa] 
May 24 10:58:28 TUX kernel:  11 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 10:58:28 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:28 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:28 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 10:58:29 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 10:58:29 TUX kernel: Pending list: 
May 24 10:58:29 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 10:58:29 TUX kernel: Kernel Free SCB list: 3 2 14 7 1 4 5 8 9 6 11 15 
13 12 
May 24 10:58:29 TUX kernel: Untagged Q(3): 10 
May 24 10:58:29 TUX kernel: 
May 24 10:58:29 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 10:58:29 TUX kernel: sr 0:0:3:0: Device is active, asserting ATN
May 24 10:58:29 TUX kernel: Recovery code sleeping
May 24 10:58:29 TUX kernel: Timer Expired
May 24 10:58:29 TUX kernel: Recovery code awake
May 24 10:58:29 TUX kernel: aic7xxx_abort returns 0x2003
May 24 10:58:29 TUX kernel: sd 0:0:0:0: Attempting to queue a TARGET RESET 
message
May 24 10:58:29 TUX kernel: CDB: 0x1a 0x0 0x1c 0x0 0xff 0x0
May 24 10:58:29 TUX kernel: sd 0:0:0:0: Command not found
May 24 10:58:29 TUX kernel: aic7xxx_dev_reset returns 0x2002
May 24 10:58:29 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 10:58:29 TUX kernel: CDB: 0x0 0x0 0x0 0x0 0x0 0x0
May 24 10:58:29 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 10:58:29 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 10:58:29 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 10:58:29 TUX kernel: Card was paused
May 24 10:58:30 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 10:58:30 TUX kernel: HCNT = 0xc SCBPTR = 0xa
May 24 10:58:30 TUX kernel: SCSISIGI[0x54]:(BSYI|ATNI|IOI) ERROR[0x0] 
SCSIBUSL[0x50] 
May 24 10:58:30 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 10:58:31 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:00:43 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:00:43 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:00:43 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:00:44 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:34 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:35 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:35 TUX kernel: SCB count = 16
May 24 11:03:35 TUX kernel: Kernel NEXTQSCB = 3
May 24 11:03:35 TUX kernel: Card NEXTQSCB = 0
May 24 11:03:35 TUX kernel: QINFIFO entries: 0 
May 24 11:03:36 TUX kernel: Waiting Queue entries: 
May 24 11:03:36 TUX kernel: Disconnected Queue entries: 
May 24 11:03:36 TUX kernel: QOUTFIFO entries: 
May 24 11:03:36 TUX kernel: Sequencer Free SCB List: 1 2 7 3 8 6 5 11 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:36 TUX kernel: Sequencer SCB Info: 
May 24 11:03:36 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   1 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   2 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   5 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   6 SCB_CONTROL[0xc0]:(DISCENB|TARGET_SCB) 
SCB_SCSIID[0x37] 
May 24 11:03:36 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:36 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCx0 
0x0 0x0
May 24 11:03:36 TUX kernel: aic7xxx_dev_reset returns 0x2003
May 24 11:03:36 TUX kernel: Recovery SCB completes
May 24 11:03:37 TUX kernel: Recovery SCB completes
May 24 11:03:37 TUX kernel: sr0: CDROM not ready yet.
May 24 11:03:37 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 11:03:37 TUX kernel: CDB: 0x28 0x0 0x2 0xfe 0xda 0xa 0x0 0x0 0x80 0x0
May 24 11:03:37 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:37 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:37 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 11:03:37 TUX kernel: Card was paused
May 24 11:03:37 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 11:03:37 TUX kernel: HCNT = 0xc SCBPTR = 0x8
May 24 11:03:37 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:37 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:37 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:37 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:37 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:37 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:37 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:37 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:37 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:37 TUX kernel: SCB count = 16
May 24 11:03:37 TUX kernel: Kernel NEXTQSCB = 5
May 24 11:03:38 TUX kernel: Card NEXTQSCB = 5
May 24 11:03:38 TUX kernel: QINFIFO entries: 
May 24 11:03:38 TUX kernel: Waiting Queue entries: 
May 24 11:03:38 TUX kernel: Disconnected Queue entries: 1:8 6:4 
May 24 11:03:38 TUX kernel: QOUTFIFO entries: 
May 24 11:03:38 TUX kernel: Sequencer Free SCB List: 10 7 3 5 11 2 4 9 0 12 13 
14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:38 TUX kernel: Sequencer SCB Info: 
May 24 11:03:38 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:38 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:38 TUX kernel:   1 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:38 TUX kernel: SCB_LUN[0x0] SCB_TAG[0x8] 
May 24 11:03:38 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:38 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:38 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:38 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:38 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:38 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:38 TUX kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:   6 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0x4] 
May 24 11:03:39 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:   8 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:39 TUX kernel: SCB_TAG[0xa] 
May 24 11:03:39 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:  11 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:39 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:39 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:39 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:40 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:40 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:41 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:41 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:42 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:42 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:42 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:42 TUX kernel: Pending list: 
May 24 11:03:42 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:42 TUX kernel:   8 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:43 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:43 TUX kernel:   4 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:43 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:43 TUX kernel: Kernel Free SCB list: 14 3 2 0 1 7 9 6 11 15 13 12 
May 24 11:03:43 TUX kernel: Untagged Q(3): 10 
May 24 11:03:43 TUX kernel: 
May 24 11:03:43 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:43 TUX kernel: (scsi0:A:0:0): Device is disconnected, re-queuing 
SCB
May 24 11:03:43 TUX kernel: Recovery code sleeping
May 24 11:03:43 TUX kernel: Timer Expired
May 24 11:03:43 TUX kernel: Recovery code awake
May 24 11:03:43 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:43 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 11:03:43 TUX kernel: CDB: 0x28 0x0 0x2 0x5b 0xad 0xd1 0x0 0x0 0x8 0x0
May 24 11:03:43 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:43 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:43 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb8
May 24 11:03:43 TUX kernel: Card was paused
May 24 11:03:43 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 11:03:43 TUX kernel: HCNT = 0xc SCBPTR = 0x8
May 24 11:03:43 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:43 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:43 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:43 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:43 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:43 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:43 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:43 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:43 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:43 TUX kernel: SCB count = 16
May 24 11:03:43 TUX kernel: Kernel NEXTQSCB = 5
May 24 11:03:44 TUX kernel: Card NEXTQSCB = 4
May 24 11:03:44 TUX kernel: QINFIFO entries: 4 
May 24 11:03:44 TUX kernel: Waiting Queue entries: 
May 24 11:03:44 TUX kernel: Disconnected Queue entries: 1:8 
May 24 11:03:44 TUX kernel: QOUTFIFO entries: 
May 24 11:03:44 TUX kernel: Sequencer Free SCB List: 6 10 7 3 5 11 2 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:44 TUX kernel: Sequencer SCB Info: 
May 24 11:03:44 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   1 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0x8] 
May 24 11:03:44 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:44 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:   8 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:44 TUX kernel: SCB_TAG[0xa] 
May 24 11:03:44 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  11 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:44 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:44 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:44 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:44 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:44 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:44 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:44 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:45 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:45 TUX kernel: Pending list: 
May 24 11:03:45 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:45 TUX kernel:   8 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:45 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:45 TUX kernel:   4 SCB_CONTROL[0x74]:(DISCONNECTED|MK_MESSAGE|
TAG_ENB|DISCENB) 
May 24 11:03:45 TUX kernel: SCB_SCSIID[0x7] SCB_LUN[0x0] 
May 24 11:03:45 TUX kernel: Kernel Free SCB list: 14 3 2 0 1 7 9 6 11 15 13 12 
May 24 11:03:45 TUX kernel: Untagged Q(3): 10 
May 24 11:03:45 TUX kernel: 
May 24 11:03:45 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:45 TUX kernel: Recovery SCB completes
May 24 11:03:45 TUX kernel: (scsi0:A:0:0): Device is disconnected, re-queuing 
SCB
May 24 11:03:45 TUX kernel: Recovery code sleeping
May 24 11:03:45 TUX kernel: Timer Expired
May 24 11:03:45 TUX kernel: Recovery code awake
May 24 11:03:45 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:45 TUX kernel: sr 0:0:3:0: Attempting to queue an ABORT message
May 24 11:03:45 TUX kernel: CDB: 0x46 0x2 0x0 0x1e 0x0 0x0 0x0 0x0 0x8 0x0 0x0 
0x0
May 24 11:03:45 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:45 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:46 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 11:03:46 TUX kernel: Card was paused
May 24 11:03:46 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x2
May 24 11:03:46 TUX kernel: HCNT = 0xc SCBPTR = 0x8
May 24 11:03:46 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:46 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:46 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:46 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:46 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:46 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:46 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:46 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:46 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:46 TUX kernel: SCB count = 16
May 24 11:03:46 TUX kernel: Kernel NEXTQSCB = 5
May 24 11:03:46 TUX kernel: Card NEXTQSCB = 8
May 24 11:03:46 TUX kernel: QINFIFO entries: 8 
May 24 11:03:46 TUX kernel: Waiting Queue entries: 
May 24 11:03:46 TUX kernel: Disconnected Queue entries: 
May 24 11:03:46 TUX kernel: QOUTFIFO entries: 
May 24 11:03:46 TUX kernel: Sequencer Free SCB List: 1 6 10 7 3 5 11 2 4 9 0 
12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:46 TUX kernel: Sequencer SCB Info: 
May 24 11:03:46 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:46 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   5 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   7 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:   8 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:46 TUX kernel: SCB_TAG[0xa] 
May 24 11:03:46 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  11 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:46 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:46 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:46 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:46 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:46 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:47 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:47 TUX kernel: Pending list: 
May 24 11:03:47 TUX kernel:  10 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x0] 
May 24 11:03:47 TUX kernel:   8 SCB_CONTROL[0x74]:(DISCONNECTED|MK_MESSAGE|
TAG_ENB|DISCENB) 
May 24 11:03:47 TUX kernel: SCB_SCSIID[0x7] SCB_LUN[0x0] 
May 24 11:03:47 TUX kernel: Kernel Free SCB list: 4 14 3 2 0 1 7 9 6 11 15 13 
12 
May 24 11:03:47 TUX kernel: Untagged Q(3): 10 
May 24 11:03:47 TUX kernel: 
May 24 11:03:47 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:47 TUX kernel: sr 0:0:3:0: Device is active, asserting ATN
May 24 11:03:47 TUX kernel: Recovery code sleeping
May 24 11:03:47 TUX kernel: Timer Expired
May 24 11:03:47 TUX kernel: Recovery code awake
May 24 11:03:47 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:47 TUX kernel: sd 0:0:0:0: Attempting to queue a TARGET RESET 
message
May 24 11:03:47 TUX kernel: CDB: 0x28 0x0 0x2 0xfe 0xda 0xa 0x0 0x0 0x80 0x0
May 24 11:03:47 TUX kernel: aic7xxx_dev_reset returns 0x2003
May 24 11:03:47 TUX kernel: sr 0:0:3:0: Attempting to queue a TARGET RESET 
message
May 24 11:03:47 TUX kernel: CDB: 0x46 0x2 0x0 0x1e 0x0 0x0 0x0 0x0 0x8 0x0 0x0 
0x0
May 24 11:03:47 TUX kernel: aic7xxx_dev_reset returns 0x2003
May 24 11:03:48 TUX kernel: Recovery SCB completes
May 24 11:03:48 TUX kernel: Recovery SCB completes
May 24 11:03:48 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 11:03:48 TUX kernel: CDB: 0x28 0x0 0x3 0x1c 0x60 0x72 0x0 0x0 0x8 0x0
May 24 11:03:48 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:48 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:48 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb8
May 24 11:03:48 TUX kernel: Card was paused
May 24 11:03:48 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x1
May 24 11:03:48 TUX kernel: HCNT = 0xc SCBPTR = 0xb
May 24 11:03:48 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:48 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:48 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:48 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:48 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:48 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:48 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:48 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:48 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:48 TUX kernel: SCB count = 16
May 24 11:03:48 TUX kernel: Kernel NEXTQSCB = 2
May 24 11:03:48 TUX kernel: Card NEXTQSCB = 2
May 24 11:03:48 TUX kernel: QINFIFO entries: 
May 24 11:03:48 TUX kernel: Waiting Queue entries: 
May 24 11:03:48 TUX kernel: Disconnected Queue entries: 7:14 6:8 
May 24 11:03:48 TUX kernel: QOUTFIFO entries: 
May 24 11:03:48 TUX kernel: Sequencer Free SCB List: 1 5 10 3 8 2 4 9 0 12 13 
14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:48 TUX kernel: Sequencer SCB Info: 
May 24 11:03:48 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   1 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:48 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:48 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   5 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:48 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   6 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0x8] 
May 24 11:03:48 TUX kernel:   7 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xe] 
May 24 11:03:48 TUX kernel:   8 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:48 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:48 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:48 TUX kernel:  11 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:48 TUX kernel: SCB_TAG[0x5] 
May 24 11:03:48 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:49 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:49 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:49 TUX kernel: Pending list: 
May 24 11:03:49 TUX kernel:   5 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:49 TUX kernel:  14 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:49 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:49 TUX kernel:   8 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:49 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:49 TUX kernel: Kernel Free SCB list: 0 10 4 3 7 1 9 6 11 15 13 12 
May 24 11:03:49 TUX kernel: Untagged Q(3): 5 
May 24 11:03:49 TUX kernel: 
May 24 11:03:49 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:49 TUX kernel: (scsi0:A:0:0): Device is disconnected, re-queuing 
SCB
May 24 11:03:49 TUX kernel: Recovery code sleeping
May 24 11:03:49 TUX kernel: Timer Expired
May 24 11:03:50 TUX kernel: Recovery code awake
May 24 11:03:50 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:50 TUX kernel: sd 0:0:0:0: Attempting to queue an ABORT message
May 24 11:03:50 TUX kernel: CDB: 0x28 0x0 0x2 0x5b 0x43 0xd1 0x0 0x0 0x40 0x0
May 24 11:03:50 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:50 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:50 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb7
May 24 11:03:50 TUX kernel: Card was paused
May 24 11:03:50 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x1
May 24 11:03:50 TUX kernel: HCNT = 0xc SCBPTR = 0xb
May 24 11:03:50 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:50 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:50 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:50 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:50 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:50 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:50 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:50 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:50 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:50 TUX kernel: SCB count = 16
May 24 11:03:50 TUX kernel: Kernel NEXTQSCB = 2
May 24 11:03:50 TUX kernel: Card NEXTQSCB = 8
May 24 11:03:50 TUX kernel: QINFIFO entries: 8 
May 24 11:03:50 TUX kernel: Waiting Queue entries: 
May 24 11:03:50 TUX kernel: Disconnected Queue entries: 7:14 
May 24 11:03:50 TUX kernel: QOUTFIFO entries: 
May 24 11:03:50 TUX kernel: Sequencer Free SCB List: 6 1 5 10 3 8 2 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:50 TUX kernel: Sequencer SCB Info: 
May 24 11:03:50 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   1 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:50 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:50 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   5 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:50 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   7 SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|
DISCENB) SCB_SCSIID[0x7] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xe] 
May 24 11:03:50 TUX kernel:   8 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:50 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:50 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:50 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  11 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:51 TUX kernel: SCB_TAG[0x5] 
May 24 11:03:51 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:51 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:51 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:51 TUX kernel: Pending list: 
May 24 11:03:51 TUX kernel:   5 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:51 TUX kernel:  14 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x7] 
May 24 11:03:51 TUX kernel: SCB_LUN[0x0] 
May 24 11:03:51 TUX kernel:   8 SCB_CONTROL[0x74]:(DISCONNECTED|MK_MESSAGE|
TAG_ENB|DISCENB) 
May 24 11:03:51 TUX kernel: SCB_SCSIID[0x7] SCB_LUN[0x0] 
May 24 11:03:51 TUX kernel: Kernel Free SCB list: 0 10 4 3 7 1 9 6 11 15 13 12 
May 24 11:03:52 TUX kernel: Untagged Q(3): 5 
May 24 11:03:52 TUX kernel: 
May 24 11:03:52 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:52 TUX kernel: Recovery SCB completes
May 24 11:03:52 TUX kernel: (scsi0:A:0:0): Device is disconnected, re-queuing 
SCB
May 24 11:03:52 TUX kernel: Recovery code sleeping
May 24 11:03:52 TUX kernel: Timer Expired
May 24 11:03:52 TUX kernel: Recovery code awake
May 24 11:03:52 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:52 TUX kernel: sr 0:0:3:0: Attempting to queue an ABORT message
May 24 11:03:52 TUX kernel: CDB: 0x46 0x2 0x0 0x1e 0x0 0x0 0x0 0xf 0xf3 0x0 
0x0 0x0
May 24 11:03:52 TUX kernel: scsi0: At time of recovery, card was not paused
May 24 11:03:52 TUX kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
May 24 11:03:52 TUX kernel: scsi0: Dumping Card State in Command phase, at 
SEQADDR 0xb8
May 24 11:03:52 TUX kernel: Card was paused
May 24 11:03:52 TUX kernel: ACCUM = 0x80, SINDEX = 0xa0, DINDEX = 0xe4, ARG_2 
= 0x1
May 24 11:03:52 TUX kernel: HCNT = 0xc SCBPTR = 0xb
May 24 11:03:52 TUX kernel: SCSISIGI[0x44]:(BSYI|IOI) ERROR[0x0] SCSIBUSL[0x0] 
May 24 11:03:52 TUX kernel: LASTPHASE[0x80]:(CDI) SCSISEQ[0x12]:(ENAUTOATNP|
ENRSELI) 
May 24 11:03:52 TUX kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x15]:
(SINGLE_EDGE) 
May 24 11:03:52 TUX kernel: SEQCTL[0x10]:(FASTMODE) SEQ_FLAGS[0x0] SSTAT0[0x0] 
May 24 11:03:52 TUX kernel: SSTAT1[0x3]:(REQINIT|PHASECHG) SSTAT2[0x50]:
(EXP_ACTIVE|SHVALID) 
May 24 11:03:52 TUX kernel: SSTAT3[0x8] SIMODE0[0x8]:(ENSWRAP) SIMODE1[0xac]:
(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
May 24 11:03:52 TUX kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x24]:(DIRECTION|
SCSIEN) 
May 24 11:03:52 TUX kernel: DFSTATUS[0x80]:(PRELOAD_AVAIL) 
May 24 11:03:52 TUX kernel: STACK: 0x0 0x167 0x17d 0x35
May 24 11:03:52 TUX kernel: SCB count = 16
May 24 11:03:52 TUX kernel: Kernel NEXTQSCB = 2
May 24 11:03:52 TUX kernel: Card NEXTQSCB = 14
May 24 11:03:52 TUX kernel: QINFIFO entries: 14 
May 24 11:03:52 TUX kernel: Waiting Queue entries: 
May 24 11:03:52 TUX kernel: Disconnected Queue entries: 
May 24 11:03:52 TUX kernel: QOUTFIFO entries: 
May 24 11:03:52 TUX kernel: Sequencer Free SCB List: 7 6 1 5 10 3 8 2 4 9 0 12 
13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May 24 11:03:52 TUX kernel: Sequencer SCB Info: 
May 24 11:03:52 TUX kernel:   0 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:52 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   1 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:52 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   2 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:52 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   3 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:52 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   4 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:52 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   5 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:52 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   7 SCB_CONTROL[0x0] SCB_SCSIID[0x7] SCB_LUN[0x0] 
SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   8 SCB_CONTROL[0x80]:(TARGET_SCB) 
SCB_SCSIID[0x37] SCB_LUN[0x0] 
May 24 11:03:52 TUX kernel: SCB_TAG[0xff] 
May 24 11:03:52 TUX kernel:   9 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x17] 
May 24 11:03:53 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  10 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:53 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  11 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:53 TUX kernel: SCB_TAG[0x5] 
May 24 11:03:53 TUX kernel:  12 SCB_CONTROL[0xe0]:(TAG_ENB|DISCENB|TARGET_SCB) 
SCB_SCSIID[0x7] 
May 24 11:03:53 TUX kernel: SCB_LUN[0x0] SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  17 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|
OID|TWIN_TID) 
May 24 11:03:53 TUX kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff] 
May 24 11:03:53 TUX kernel: Pending list: 
May 24 11:03:53 TUX kernel:   5 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x37] 
SCB_LUN[0x80]:(SCB_XFERLEN_ODD) 
May 24 11:03:53 TUX kernel:  14 SCB_CONTROL[0x74]:(DISCONNECTED|MK_MESSAGE|
TAG_ENB|DISCENB) 
May 24 11:03:54 TUX kernel: SCB_SCSIID[0x7] SCB_LUN[0x0] 
May 24 11:03:54 TUX kernel: Kernel Free SCB list: 8 0 10 4 3 7 1 9 6 11 15 13 
12 
May 24 11:03:54 TUX kernel: Untagged Q(3): 5 
May 24 11:03:54 TUX kernel: 
May 24 11:03:54 TUX kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
>>>>>>>>>>>>>>>>>>
May 24 11:03:54 TUX kernel: sr 0:0:3:0: Device is active, asserting ATN
May 24 11:03:54 TUX kernel: Recovery code sleeping
May 24 11:03:54 TUX kernel: Timer Expired
May 24 11:03:54 TUX kernel: Recovery code awake
May 24 11:03:54 TUX kernel: aic7xxx_abort returns 0x2003
May 24 11:03:54 TUX kernel: sd 0:0:0:0: Attempting to queue a TARGET RESET 
message
May 24 11:03:54 TUX kernel: CDB: 0x28 0x0 0x3 0x1c 0x60 0x72 0x0 0x0 0x8 0x0
May 24 11:03:54 TUX kernel: aic7xxx_dev_reset returns 0x2003
May 24 11:03:54 TUX kernel: sr 0:0:3:0: Attempting to queue a TARGET RESET 
message
May 24 11:03:54 TUX kernel: CDB: 0x46 0x2 0x0 0x1e 0x0 0x0 0x0 0xf 0xf3 0x0 
0x0 0x0
May 24 11:03:54 TUX kernel: aic7xxx_dev_reset returns 0x2003
May 24 11:03:54 TUX kernel: Recovery SCB completes


Thanks a lot!
René Peters

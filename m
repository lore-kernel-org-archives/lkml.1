Return-Path: <linux-kernel-owner+w=401wt.eu-S1030494AbXCHJor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030494AbXCHJor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030491AbXCHJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:44:47 -0500
Received: from hazard.jcu.cz ([160.217.1.6]:45236 "EHLO hazard.jcu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030461AbXCHJop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:44:45 -0500
X-Greylist: delayed 1690 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Mar 2007 04:44:45 EST
Date: Thu, 8 Mar 2007 10:16:34 +0100
From: Jan Marek <linux@hazard.jcu.cz>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Problem with SCSI communication between Adaptec and Ecrix VXA1
Message-ID: <20070308091634.GD6836@hazard.jcu.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello lkml,

I have problem in the communication between Adaptec:

02:09.0 SCSI storage controller: Adaptec AIC-7892B U160/m (rev 02)

which is driven by aic7xxx driver.

Kernel version is 2.6.13.1

Tape is ECRIX:

  Vendor: ECRIX     Model: VXA-1             Rev: 2C8C
  Type:   Sequential-Access                  ANSI SCSI revision: 02

I've found in the logs this messages:

Mar  7 07:47:53 rek kernel: st0: Error with sense data: <6>st0: Current: sense key=0x4
Mar  7 07:47:53 rek kernel:     ASC=0x44 ASCQ=0x0
Mar  7 07:47:53 rek kernel: Info fld=0x0
Mar  7 07:47:59 rek kernel: st0: Error with sense data: <6>st0: Current: sense key=0x4
Mar  7 07:47:59 rek kernel:     ASC=0x15 ASCQ=0x1
Mar  7 07:47:59 rek kernel: Info fld=0x0
Mar  7 07:47:59 rek kernel: st0: Error on write filemark.
Mar  7 07:48:15 rek kernel: st0: Error with sense data: <6>st0: Current: sense key=0x4
Mar  7 07:48:15 rek kernel:     ASC=0x15 ASCQ=0x1
Mar  7 07:48:15 rek kernel: Info fld=0x1
Mar  7 08:06:48 rek kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Mar  7 08:06:48 rek kernel: CDB: 0x8 0x0 0x0 0x80 0x0 0x0
Mar  7 08:06:48 rek kernel: scsi0: At time of recovery, card was not paused
Mar  7 08:06:48 rek kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Mar  7 08:06:48 rek kernel: scsi0: Dumping Card State while idle, at SEQADDR 0x9
Mar  7 08:06:48 rek kernel: Card was paused
Mar  7 08:06:48 rek kernel: ACCUM = 0x4, SINDEX = 0x17, DINDEX = 0x22, ARG_2 = 0x0
Mar  7 08:06:48 rek kernel: HCNT = 0x0 SCBPTR = 0x0 Mar  7 08:06:48 rek kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0]
Mar  7 08:06:48 rek kernel: LASTPHASE[0x1]:(P_BUSFREE) SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Mar  7 08:06:48 rek kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] SEQCTL[0x10]:(FASTMODE)
Mar  7 08:06:48 rek kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) SSTAT0[0x0]
Mar  7 08:06:48 rek kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]:(ENSWRAP)
Mar  7 08:06:48 rek kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Mar  7 08:06:48 rek kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Mar  7 08:06:48 rek kernel: STACK: 0x0 0x163 0x178 0x3
Mar  7 08:06:48 rek kernel: SCB count = 4
Mar  7 08:06:48 rek kernel: Kernel NEXTQSCB = 2
Mar  7 08:06:48 rek kernel: Card NEXTQSCB = 2
Mar  7 08:06:48 rek kernel: QINFIFO entries:
Mar  7 08:06:48 rek kernel: Waiting Queue entries:
Mar  7 08:06:48 rek kernel: Disconnected Queue entries: 0:3
Mar  7 08:06:48 rek kernel: QOUTFIFO entries:
Mar  7 08:06:48 rek kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Mar  7 08:06:48 rek kernel: Sequencer SCB Info:
Mar  7 08:06:48 rek kernel:   0 SCB_CONTROL[0x44]:(DISCONNECTED|DISCENB) SCB_SCSIID[0x17]
Mar  7 08:06:48 rek kernel: SCB_LUN[0x0] SCB_TAG[0x3]
Mar  7 08:06:48 rek kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
...
Mar  7 08:06:48 rek kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Mar  7 08:06:48 rek kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Mar  7 08:06:48 rek kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Mar  7 08:06:48 rek kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Mar  7 08:06:48 rek kernel: Pending list:
Mar  7 08:06:48 rek kernel:   3 SCB_CONTROL[0x40]:(DISCENB) SCB_SCSIID[0x17] SCB_LUN[0x0]
Mar  7 08:06:48 rek kernel: Kernel Free SCB list: 1 0
Mar  7 08:06:48 rek kernel: Untagged Q(1): 3
Mar  7 08:06:48 rek kernel:
Mar  7 08:06:48 rek kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Mar  7 08:06:48 rek kernel: (scsi0:A:1:0): Device is disconnected, re-queuing SCB
Mar  7 08:06:48 rek kernel: Recovery code sleeping
Mar  7 08:06:48 rek kernel: (scsi0:A:1:0): Abort Message Sent
Mar  7 08:06:48 rek kernel: (scsi0:A:1:0): SCB 3 - Abort Completed.
Mar  7 08:06:48 rek kernel: Recovery SCB completes
Mar  7 08:06:48 rek kernel: Recovery code awake
Mar  7 08:06:48 rek kernel: aic7xxx_abort returns 0x2002
Mar  7 08:06:50 rek kernel: (scsi0:A:1:0): Unexpected busfree in Command phase
Mar  7 08:06:50 rek kernel: SEQADDR == 0x16b
Mar  7 08:06:50 rek kernel: scsi0:0:1:0: Attempting to queue a TARGET RESET message
Mar  7 08:06:50 rek kernel: CDB: 0x8 0x0 0x0 0x80 0x0 0x0
Mar  7 08:06:50 rek kernel: scsi0:0:1:0: Command not found
Mar  7 08:06:50 rek kernel: aic7xxx_dev_reset returns 0x2002
Mar  7 08:06:50 rek kernel: (scsi0:A:1:0): refuses WIDE negotiation.  Using 8bit transfers
Mar  7 08:06:50 rek kernel:  target0:0:1: FAST-40 SCSI 40.0 MB/s ST (25 ns, offset 32)
Mar  7 08:06:50 rek kernel: (scsi0:A:1:0): Unexpected busfree in Message-in phase
Mar  7 08:06:50 rek kernel: SEQADDR == 0x16b
Mar  7 08:07:00 rek kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 1 lun 0
Mar  7 08:07:00 rek kernel: st0: Error 30000 (sugg. bt 0x0, driver bt 0x0, host bt 0x3).

Please, can you advice me, where is problem? I have changed SCSI cable
with proper active terminator...

Thank you very much.

Sincerely
Jan Marek

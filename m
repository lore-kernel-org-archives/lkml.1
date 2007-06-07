Return-Path: <linux-kernel-owner+w=401wt.eu-S935906AbXFGTW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935906AbXFGTW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 15:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764263AbXFGTWV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 15:22:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:16381 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762751AbXFGTWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 15:22:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PJzcsigXjXO8FM6yFkviy0IKIWmYdjC0cN15MXETlJknLI0/1IPhJvDZ1tmVFZl8sf3pFUem4qaBjNjGzRuc2mHyfJA2sUkvvd1BSLmINm3l1smJLeaOJ9f+zLfQzETk9ySGHApcPMmFJgh0L7ZIC+7AoUbPyvbP/ftUVkgvVRI=
Message-ID: <46685AE5.4010908@gmail.com>
Date: Thu, 07 Jun 2007 21:22:13 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com>	<464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com>	<4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com>	<4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com>	<4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com>	<46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com>
In-Reply-To: <4667B39D.209@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Can you test the attached patch
Here is what I get on the T41 (TI Cardbus controller) with 2.6.22-rc4 + 
timing-debug.patch + 
disable-dev_init_param-and-setxfermode-for-CFA.patch + 
libata-dont-test-slave-register-readiness-after-srst.patch

Jun  7 21:10:28 localhost kernel: pccard: PCMCIA card inserted into slot 0
Jun  7 21:10:28 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
Jun  7 21:10:28 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
Jun  7 21:10:28 localhost kernel: pcmcia: registering new device pcmcia0.0
Jun  7 21:10:28 localhost kernel: scsi3 : pata_pcmcia
Jun  7 21:10:28 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 
0x0001410e bmdma 0x00000000 irq 0
Jun  7 21:10:28 localhost kernel: ata3: soft resetting port
Jun  7 21:10:28 localhost kernel: ata3: reset complete
Jun  7 21:10:28 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun  7 21:10:28 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun  7 21:10:28 localhost kernel: ata3.00: issuing IDENTIFY
Jun  7 21:10:29 localhost kernel: ata3.00: IDENTIFY complete
Jun  7 21:10:29 localhost kernel: ata3.00: CFA: Memory Card Adapter, 
20011212, max PIO1
Jun  7 21:10:29 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
Jun  7 21:10:29 localhost kernel: ata3.00: issuing IDENTIFY
Jun  7 21:10:29 localhost kernel: ata3.00: IDENTIFY complete
Jun  7 21:10:29 localhost kernel: ata3.00: configured for PIO0
Jun  7 21:10:29 localhost kernel: ata3: EH complete
Jun  7 21:10:29 localhost kernel: scsi 3:0:0:0: Direct-Access     
ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte 
hardware sectors (130 MB)
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte 
hardware sectors (130 MB)
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Jun  7 21:10:59 localhost kernel:  sdd:<3>ata3.00: exception Emask 0x0 
SAct 0x0 SErr 0x0 action 0x2 frozen
Jun  7 21:10:59 localhost kernel: ata3.00: cmd 
20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
Jun  7 21:10:59 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun  7 21:10:59 localhost kernel: ata3: soft resetting port
Jun  7 21:10:59 localhost kernel: ata3: reset complete
Jun  7 21:10:59 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun  7 21:10:59 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun  7 21:10:59 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:10:59 localhost kernel: ata3.00: issuing IDENTIFY
Jun  7 21:10:59 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:10:59 localhost last message repeated 4 times
Jun  7 21:10:59 localhost kernel: ata3.00: IDENTIFY complete
Jun  7 21:10:59 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun  7 21:10:59 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun  7 21:10:59 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Jun  7 21:11:04 localhost kernel: ata3: soft resetting port
Jun  7 21:11:04 localhost kernel: ata3: reset complete
Jun  7 21:11:04 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun  7 21:11:04 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun  7 21:11:04 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:11:04 localhost kernel: ata3.00: issuing IDENTIFY
Jun  7 21:11:04 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:11:04 localhost last message repeated 4 times
Jun  7 21:11:04 localhost kernel: ata3.00: IDENTIFY complete
Jun  7 21:11:04 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun  7 21:11:04 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun  7 21:11:04 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Jun  7 21:11:09 localhost kernel: ata3: soft resetting port
Jun  7 21:11:09 localhost kernel: ata3: reset complete
Jun  7 21:11:09 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun  7 21:11:09 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun  7 21:11:09 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:11:09 localhost kernel: ata3.00: issuing IDENTIFY
Jun  7 21:11:09 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun  7 21:11:09 localhost last message repeated 4 times
Jun  7 21:11:09 localhost kernel: ata3.00: IDENTIFY complete
Jun  7 21:11:09 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun  7 21:11:09 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun  7 21:11:09 localhost kernel: ata3.00: disabled
Jun  7 21:11:10 localhost kernel: ata3: EH complete
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: Dev sdd: unable to read RDB block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: end_request: I/O error, dev sdd, sector 0
Jun  7 21:11:10 localhost kernel: Buffer I/O error on device sdd, 
logical block 0
Jun  7 21:11:10 localhost kernel:  unable to read partition table
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Attached SCSI 
removable disk
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: Attached scsi generic sg3 
type 0
Jun  7 21:11:10 localhost udevd-event[2477]: udev_rules_apply_format: 
unknown format variable '$modalias'
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:10 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:11 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:13 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:15 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:17 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:19 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:21 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:23 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:25 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] READ CAPACITY failed
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Sense not available.
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Asking for cache 
data failed
Jun  7 21:11:27 localhost kernel: sd 3:0:0:0: [sdd] Assuming drive 
cache: write through
Jun  7 21:11:31 localhost kernel: pccard: card ejected from slot 0
Jun  7 21:11:31 localhost kernel: sd 3:0:0:0: [sdd] Stopping disk
Jun  7 21:11:31 localhost kernel: sd 3:0:0:0: [sdd] START_STOP FAILED
Jun  7 21:11:31 localhost kernel: sd 3:0:0:0: [sdd] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbXFVLwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbXFVLwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFVLvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:51:52 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:60609 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbXFVLvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=NC2ZFnUNJNKMfhBQaIq7E32dNsFVJb5TdiF93UUhhw6+Sy2JOifbc3y5UPcQsd8TBoquQ2roRk6nGoroka5hHwh5VvGKP4QznKP6yrD8cgZFpftQiU/3Qe3Q3SoHFQQ2B4KDN/JPpwvBdHYtddLl9BL3hjm9wjjlHY1O+tZjK2Q=
Message-ID: <467BB7DB.4090004@gmail.com>
Date: Fri, 22 Jun 2007 13:51:55 +0200
From: Robert de Rooy <robert.de.rooy@gmail.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: albertl@mail.com, Mark Lord <mlord@pobox.com>, Mark Lord <liml@rtr.ca>,
       Jeff Garzik <jeff@garzik.org>, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com> <46710CD7.9070901@gmail.com>
In-Reply-To: <46710CD7.9070901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Albert Lee wrote:
>   
>>> libata can do most of this too by using ATA_FLAG_PIO_POLLING (doesn't
>>> cover nodata commands tho).
>>>
>>>       
>> Hi Tejun,
>>
>> Polling of nodata commands was fixed in:
>> http://marc.info/?l=linux-ide&m=116546272916399&w=2
>>     
>
> Right.  Thanks for reminding me.  :-)
>
>   

I did another try with libata pcmcia support using 2.6.22-rc5 which 
already includes the nodata polling fix, in combination with 
disable-dev_init_param-and-setxfermode-for-CFA.patch and the 
timing-debug.patch

Jun 22 13:19:44 localhost kernel: pccard: PCMCIA card inserted into slot 1
Jun 22 13:19:44 localhost kernel: cs: memory probe 
0xe8000000-0xefffffff: excluding 0xe8000000-0xefffffff
Jun 22 13:19:44 localhost kernel: cs: memory probe 
0xc0200000-0xcfffffff: excluding 0xc0200000-0xc11fffff 
0xc1a00000-0xc21fffff 0xc2a00000-0xc31fffff 0xc3a00000-0xcc1fffff 
0xcca00000-0xcd1fffff 0xcda00000-0xce1fffff 0xcea00000-0xcf1fffff 
0xcfa00000-0xd01fffff
Jun 22 13:19:44 localhost kernel: pcmcia: registering new device pcmcia1.0
Jun 22 13:19:44 localhost kernel: scsi2 : pata_pcmcia
Jun 22 13:19:44 localhost kernel: ata3: PATA max PIO0 cmd 0x00014100 ctl 
0x0001410e bmdma 0x00000000 irq 0
Jun 22 13:19:44 localhost kernel: ata3: soft resetting port
Jun 22 13:19:44 localhost kernel: ata3: reset complete
Jun 22 13:19:44 localhost kernel: ata3.00: issuing IDENTIFY
Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
Jun 22 13:19:45 localhost kernel: ata3.00: CFA: Memory Card Adapter, 
20011212, max PIO1
Jun 22 13:19:45 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
Jun 22 13:19:45 localhost kernel: ata3.00: issuing IDENTIFY
Jun 22 13:19:45 localhost kernel: ata3.00: IDENTIFY complete
Jun 22 13:19:45 localhost kernel: ata3.00: configured for PIO0
Jun 22 13:19:45 localhost kernel: ata3: EH complete
Jun 22 13:19:45 localhost kernel: scsi 2:0:0:0: Direct-Access     
ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte 
hardware sectors (130 MB)
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] 253696 512-byte 
hardware sectors (130 MB)
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:19:45 localhost kernel: sd 2:0:0:0: [sdb] Write cache: 
disabled, read cache: enabled, doesn't support DPO or FUA
Jun 22 13:20:15 localhost kernel:  sdb:<3>ata3.00: exception Emask 0x0 
SAct 0x0 SErr 0x0 action 0x2 frozen
Jun 22 13:20:15 localhost kernel: ata3.00: cmd 
20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
Jun 22 13:20:15 localhost kernel:          res 
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
Jun 22 13:20:15 localhost kernel: ata3: soft resetting port
Jun 22 13:20:15 localhost kernel: ata3: reset complete
Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:15 localhost kernel: ata3.00: issuing IDENTIFY
Jun 22 13:20:15 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:15 localhost last message repeated 4 times
Jun 22 13:20:15 localhost kernel: ata3.00: IDENTIFY complete
Jun 22 13:20:15 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun 22 13:20:15 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun 22 13:20:15 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Jun 22 13:20:20 localhost kernel: ata3: soft resetting port
Jun 22 13:20:20 localhost kernel: ata3: reset complete
Jun 22 13:20:20 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun 22 13:20:20 localhost kernel: ATA: abnormal status 0x80 on port 
0x00014107
Jun 22 13:20:20 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:20 localhost kernel: ata3.00: issuing IDENTIFY
Jun 22 13:20:20 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:20 localhost last message repeated 4 times
Jun 22 13:20:20 localhost kernel: ata3.00: IDENTIFY complete
Jun 22 13:20:20 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun 22 13:20:20 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun 22 13:20:20 localhost kernel: ata3: failed to recover some devices, 
retrying in 5 secs
Jun 22 13:20:25 localhost kernel: ata3: soft resetting port
Jun 22 13:20:25 localhost kernel: ata3: reset complete
Jun 22 13:20:25 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun 22 13:20:25 localhost kernel: ATA: abnormal status 0xB8 on port 
0x00014107
Jun 22 13:20:25 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:25 localhost kernel: ata3.00: issuing IDENTIFY
Jun 22 13:20:25 localhost kernel: ATA: abnormal status 0x58 on port 
0x00014107
Jun 22 13:20:25 localhost last message repeated 4 times
Jun 22 13:20:25 localhost kernel: ata3.00: IDENTIFY complete
Jun 22 13:20:25 localhost kernel: ata3.00: failed to IDENTIFY (I/O 
error, err_mask=0x2)
Jun 22 13:20:25 localhost kernel: ata3.00: revalidation failed (errno=-5)
Jun 22 13:20:25 localhost kernel: ata3.00: disabled
Jun 22 13:20:26 localhost kernel: ata3: EH complete
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: Dev sdb: unable to read RDB block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: end_request: I/O error, dev sdb, sector 0
Jun 22 13:20:26 localhost kernel: Buffer I/O error on device sdb, 
logical block 0
Jun 22 13:20:26 localhost kernel:  unable to read partition table
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Attached SCSI 
removable disk
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: Attached scsi generic sg2 
type 0
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:26 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:27 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] READ CAPACITY failed
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Sense not available.
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Asking for cache 
data failed
Jun 22 13:20:43 localhost kernel: sd 2:0:0:0: [sdb] Assuming drive 
cache: write through
Jun 22 13:20:48 localhost kernel: pccard: card ejected from slot 1
Jun 22 13:20:48 localhost kernel: sd 2:0:0:0: [sdb] Stopping disk
Jun 22 13:20:48 localhost kernel: sd 2:0:0:0: [sdb] START_STOP FAILED
Jun 22 13:20:48 localhost kernel: sd 2:0:0:0: [sdb] Result: 
hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK

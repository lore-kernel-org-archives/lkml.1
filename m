Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZGUDl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZGUDl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZGUDlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:41:55 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:33378 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbZGUDlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:41:55 -0400
Message-ID: <4A6538FF.4030105@technicalogic.com>
Date: Mon, 20 Jul 2009 22:41:51 -0500
From: Dwayne Rightler <drightler@technicalogic.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: No UDMA with BLK_DEV_IT821X with 2.6.30.2
References: <4A64F7BA.2030900@technicalogic.com> <20090721004811.31a79a98@lxorguk.ukuu.org.uk>
In-Reply-To: <20090721004811.31a79a98@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the libata driver and "ATAPI BIOS" I get this sort of garbage (note 
I don't get these drive errors on other controllers):

[  604.314837] ata8.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  604.314895] ata8.01: BMDMA stat 0x4
[  604.314951] ata8.01: cmd c8/00:00:e0:20:e4/00:00:00:00:00/f1 tag 0 
dma 131072 in
[  604.314952]          res 00/00:00:80:00:80/00:00:00:00:00/80 Emask 
0x2 (HSM violation)
[  604.315097] ata8: soft resetting link
[  605.462588] ata8.00: configured for UDMA/100
[  605.508491] ata8.01: configured for UDMA/100
[  605.508501] ata8: EH complete
[  979.174939] ata8.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6
[  979.174949] ata8.01: BMDMA stat 0x4
[  979.174958] ata8.01: cmd c8/00:00:e0:4e:89/00:00:00:00:00/f4 tag 0 
dma 131072 in
[  979.174959]          res 00/00:00:80:00:80/00:00:00:00:00/80 Emask 
0x2 (HSM violation)
[  979.175008] ata8: soft resetting link
[  979.944287] ata8.01: NODEV after polling detection
[  979.944290] ata8.01: revalidation failed (errno=-2)
[  984.944026] ata8: soft resetting link
[  985.100384] ata8.01: NODEV after polling detection
[  985.100388] ata8.01: revalidation failed (errno=-2)
[  990.100032] ata8: soft resetting link
[  990.256322] ata8.01: NODEV after polling detection
[  990.256325] ata8.01: revalidation failed (errno=-2)
[  990.256334] ata8.01: disabled
[  990.256338] ata8.00: failed to IDENTIFY (I/O error, err_mask=0x40)
[  990.256340] ata8.00: revalidation failed (errno=-5)
[  995.256024] ata8: soft resetting link
[  995.539133] ata8.00: configured for UDMA/100
[  995.539158] ata8: EH complete
[  995.539185] sd 7:0:1:0: [sdg] Unhandled error code
[  995.539187] sd 7:0:1:0: [sdg] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK
[  995.539192] end_request: I/O error, dev sdg, sector 76107488
[  995.539206] Buffer I/O error on device sdg, logical block 9513436
[  995.539215] Buffer I/O error on device sdg, logical block 9513437
[  995.539222] Buffer I/O error on device sdg, logical block 9513438
[  995.539229] Buffer I/O error on device sdg, logical block 9513439
[  995.539244] Buffer I/O error on device sdg, logical block 9513440
[  995.539260] Buffer I/O error on device sdg, logical block 9513441
[  995.539276] Buffer I/O error on device sdg, logical block 9513442
[  995.539292] Buffer I/O error on device sdg, logical block 9513443
[  995.539308] Buffer I/O error on device sdg, logical block 9513444
[  995.539323] Buffer I/O error on device sdg, logical block 9513445
[  995.539359] sd 7:0:1:0: [sdg] Unhandled error code
[  995.539361] sd 7:0:1:0: [sdg] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK
[  995.539364] end_request: I/O error, dev sdg, sector 76107744
[  995.539411] sd 7:0:1:0: [sdg] Unhandled error code
[  995.539413] sd 7:0:1:0: [sdg] Result: hostbyte=DID_BAD_TARGET 
driverbyte=DRIVER_OK
[  995.539415] end_request: I/O error, dev sdg, sector 76107488


After this happens hdparm fails:

root@darkomen-desktop:~# hdparm -i /dev/sdg

/dev/sdg:
  HDIO_GET_IDENTITY failed: No message of desired type


As well as smartctl:

root@darkomen-desktop:~# smartctl -H /dev/sdg
smartctl version 5.38 [x86_64-unknown-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Short INQUIRY response, skip product id
A mandatory SMART command failed: exiting. To continue, add one or more 
'-T permissive' options.



Alan Cox wrote:
> On Mon, 20 Jul 2009 18:03:22 -0500
> Dwayne Rightler <drightler@technicalogic.com> wrote:
> 
>> Hello,
>>
>> I have a ITE8212 PCI card and it does not seem to allow UDMA on the 
>> drives attached.  The drives run at ATA100 under other controllers.
> 
> The old IDE driver support for IT821x has been somewhat broken for some
> time. The drivers/ata (libata) driver should handle it fully. In smart
> mode it's "IDE-ish" and the old IDE code really isn't flexible enough to
> cope. With the "ATAPI BIOS" its a fairly normal controller so both drivers
> ought to work.

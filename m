Return-Path: <linux-kernel-owner+w=401wt.eu-S964941AbXFFGsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964941AbXFFGsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 02:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964980AbXFFGrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 02:47:49 -0400
Received: from eazy.amigager.de ([213.239.192.238]:44644 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964AbXFFGrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 02:47:48 -0400
Date: Wed, 6 Jun 2007 08:47:44 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Bad behaviour after hdparm -M  128
Message-ID: <20070606064744.GA14552@dose.home.local>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried to enable acoustic management on my SATA drive, because
hdparm -I reported a recommended value of 128, and a current value
of 0 (off).

I did this:

$ sudo hdparm -M 128 /dev/sda
/dev/sda:
 setting acoustic management to 128
 HDIO_DRIVE_CMD:ACOUSTIC failed: Input/output error
 acoustic      = not supported

It apperently failed, no big deal.

However, I had these messages in the kernel log, and they don't look
really harmless to me:

ata3.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata3.01: cmd ef/42:80:00:00:00/00:00:00:00:00/50 tag 0 cdb 0x0 data 0 
         res 51/04:80:00:00:00/00:00:00:00:00/50 Emask 0x1 (device error)
ata3.01: configured for UDMA/133
ata3: EH complete
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Is this expected behaviour?

I used kernel 2.6.21 with the libata PIIX SATA driver and a
Seagate ST98823AS drive.

Regards,
Tino

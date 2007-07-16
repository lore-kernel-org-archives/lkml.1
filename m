Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbXGPXT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbXGPXT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 19:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756288AbXGPXTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 19:19:48 -0400
Received: from rtr.ca ([64.26.128.89]:2692 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990AbXGPXTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 19:19:47 -0400
Message-ID: <469BFD12.5060008@rtr.ca>
Date: Mon, 16 Jul 2007 19:19:46 -0400
From: Mark Lord <liml@rtr.ca>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ryan Power <rpower@sysreset.com>, jgarzik@pobox.com,
       Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.1] libata: Adjust libata to ignore errors after
  spinup
References: <6.2.0.14.2.20070713000748.031a2660@linux.sysreset.com> <469775E0.2000609@rtr.ca> <6.2.0.14.2.20070713184231.02db2d20@linux.sysreset.com> <46982875.60503@rtr.ca> <6.2.0.14.2.20070715210841.02fcab90@linux.sysreset.com> <469BFA38.1090309@rtr.ca> <469BFC0E.60005@rtr.ca>
In-Reply-To: <469BFC0E.60005@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ryan Power wrote:
>> From: Ryan Power <rpower@sysreset.com>
>>
>> Adjust libata to ignore errors after spinup
>>
>> This patch is to ignore errors from the spinup attempt if the drive is
>> in the "standby id" state.
> 
> Jeff / Tejun:  here is Ryan's patch for his WD drive spinup problems.
> This copy has the pathnames and whitespace repaired.

Mmm.. Thunderbird-2.x seems to no longer keep my whitespace intact,
even when using the external editor plugin.. 

Hopefully this one (posted with thunderbird-1.5 + exteditor.xpi) works:

Signed-off-by: Ryan Power <rpower@sysreset.com>
Signed-off-by: Mark Lord <mlord@pobox.com>
---
Index: linux/drivers/ata/libata-core.c
--- old/drivers/ata/libata-core.c   2007-07-10 12:56:30.000000000 -0600
+++ linux/drivers/ata/libata-core.c       2007-07-15 01:58:49.000000000 -0600
@@ -1750,7 +1750,7 @@ int ata_dev_read_id(struct ata_device *d
		tf.protocol = ATA_PROT_NODATA;
		tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
		err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
-		if (err_mask) {
+		if (err_mask && id[2] != 0x738c) {
			rc = -EIO;
			reason = "SPINUP failed";
			goto err_out;


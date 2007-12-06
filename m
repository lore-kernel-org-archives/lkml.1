Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbXLFBeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbXLFBeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbXLFBeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:34:04 -0500
Received: from main.gmane.org ([80.91.229.2]:35962 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbXLFBeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:34:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: Failure with SATA DVD-RW
Date: Thu, 6 Dec 2007 01:33:16 +0000 (UTC)
Message-ID: <loom.20071206T012459-620@post.gmane.org>
References: <cd32a0620712041608o7733db74xf4975dec44925730@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 76.112.239.161 (Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; WOW64; SLCC1; .NET CLR 2.0.50727; .NET CLR 3.0.04506; Media Center PC 5.0; .NET CLR 3.5.21022))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Lanyon <tomlanyon <at> gmail.com> writes:

> scsi4: ahci
> ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: limiting speed to UDMA/44
> ata5: failed to recover some devices, retrying in 5 secs
> ata5: port is slow to respond, please be patient (Status 0x80)
> ata5: port failed to respond (30 secs, status 0x80)
> ata5: COMRESET failed (device not ready)
> ata5: hardreset failed, retrying in 5 secs
> ata5: SATA link up at 1.5 Gbps (SStatus 113 SControl 300)
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: limiting speed to PIO0
> ata5: failed to recover some devices, retrying in 5 secs
> ata5: port is slow to respond, please be patient (Status 0x80)
> ata5: port failed to respond (30 secs, status 0x80)
> ata5: COMRESET failed (device not ready)
> ata5: hardreset failed, retrying in 5 secs
> ata5.00: ATAPI, max UDMA/66
> ata5.00: qc timeout (cmd 0xef)
> ata5.00: failed to set xfermode (err_mask=0x104)
> ata5.00: disabled
> 
Looks like it is trying to set transfer mode to UDMA/66 and failing. After 
that it tried UDMA/44 and failed again. Next UDMA/66 again with unsurprising 
result - failed. After that PIO0 which seems to cause some kind of trouble, 
then it tries UDMA/66 again, and I am not stating the result again :) ! 

> Any ideas what to try to get it working under AHCI?
> 

I recall reading somewhere - the Pioneer drive needs UDMA/33 which it did not 
try in your case - need to some how have it try UDMA/33 but I don't find a 
boot parameter which will do that. So may be adding a quirk for this device to 
limit the xfer mode to 33 may work. 

What does your dmesg output for the drives look like when you run in IDE 
compat mode? (Particularly the DMA for this drive?)

Parag


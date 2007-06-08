Return-Path: <linux-kernel-owner+w=401wt.eu-S937311AbXFHHLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937311AbXFHHLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762819AbXFHHLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:11:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:10489 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbXFHHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H8Y8TXeYc/lcLXnRXnwlyVIiVSapV//mo4B2LeBFfVZInmHj3lxsy4dSInjNXp3BIgmI2XZTVdo0wAuXddFmZTq0eQHg+k/l8XMrrm2k4tc2atBPOp9V0anS8310JJlkucowE9gyTA4/Ay2k4tKg7GCsTcMbxSZneJ9Ga0kHSPo=
Message-ID: <466900F3.7040801@gmail.com>
Date: Fri, 08 Jun 2007 16:10:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Robert de Rooy <robert.de.rooy@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, bzolnier@gmail.com,
       linux-pcmcia@lists.infradead.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Mark Lord <mlord@pobox.com>
Subject: Re: libata and legacy ide pcmcia failure
References: <464A0321.3080201@gmail.com>	<464C1575.8070005@gmail.com>	<464CB7C9.2080807@gmail.com>	<46503192.1040300@gmail.com>	<4650B9E3.7070409@gmail.com>	<46518798.2020808@gmail.com>	<4651B66E.6030505@gmail.com>	<4651B834.3060702@gmail.com>	<4651C4A1.6000101@gmail.com>	<4651C74B.7020108@gmail.com>	<46520B36.90409@garzik.org> <20070523150229.00a0c3c4@the-village.bc.nu> <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com>
In-Reply-To: <46685AE5.4010908@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert de Rooy wrote:
> Jun  7 21:10:28 localhost kernel: ata3: soft resetting port
> Jun  7 21:10:28 localhost kernel: ata3: reset complete
> Jun  7 21:10:28 localhost kernel: ATA: abnormal status 0x80 on port
> 0x00014107
> Jun  7 21:10:28 localhost kernel: ATA: abnormal status 0x80 on port
> 0x00014107
> Jun  7 21:10:28 localhost kernel: ata3.00: issuing IDENTIFY
> Jun  7 21:10:29 localhost kernel: ata3.00: IDENTIFY complete
> Jun  7 21:10:29 localhost kernel: ata3.00: CFA: Memory Card Adapter,
> 20011212, max PIO1
> Jun  7 21:10:29 localhost kernel: ata3.00: 253696 sectors, multi 0: LBA
> Jun  7 21:10:29 localhost kernel: ata3.00: issuing IDENTIFY
> Jun  7 21:10:29 localhost kernel: ata3.00: IDENTIFY complete
> Jun  7 21:10:29 localhost kernel: ata3.00: configured for PIO0
> Jun  7 21:10:29 localhost kernel: ata3: EH complete
> Jun  7 21:10:29 localhost kernel: scsi 3:0:0:0: Direct-Access    
> ATA      Memory Card Adap 2001 PQ: 0 ANSI: 5
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte
> hardware sectors (130 MB)
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache:
> disabled, read cache: enabled, doesn't support DPO or FUA
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] 253696 512-byte
> hardware sectors (130 MB)
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Jun  7 21:10:29 localhost kernel: sd 3:0:0:0: [sdd] Write cache:
> disabled, read cache: enabled, doesn't support DPO or FUA

So, that made it go through detection okay.  That's a good news.

> Jun  7 21:10:59 localhost kernel:  sdd:<3>ata3.00: exception Emask 0x0
> SAct 0x0 SErr 0x0 action 0x2 frozen
> Jun  7 21:10:59 localhost kernel: ata3.00: cmd
> 20/00:08:00:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 in
> Jun  7 21:10:59 localhost kernel:          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)

But, read for partition table failed miserably and took the device
offline completely.

Whee... Cc'ing linux-ide and Mark Lord.  The original thread is..

  http://thread.gmane.org/gmane.linux.kernel/530099

Any ideas?

-- 
tejun

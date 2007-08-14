Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbXHNJa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbXHNJa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 05:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXHNJam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 05:30:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:47443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXHNJak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 05:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=P8fsI160RqKPhiHXSXz5+9o9hqq+2SBhanjOy0hWh1PQHQ4HEDYW++36/aIlKq7htTBtjTkwxN2CfRs8s+nUgePFCde9nsy6v2spO7wr/BSrDSXdIAP4xMhmMHXkVK1MYAifyKEyVEboqQ5iW0Cr9enLMw4+e030lfnwc5fAMvE=
Message-ID: <46C17634.2040504@gmail.com>
Date: Tue, 14 Aug 2007 18:30:28 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Gabor Gombas <gombasg@sztaki.hu>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: sata_nv + ADMA + Samsung disk problem
References: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
In-Reply-To: <20070808120804.GB5257@boogie.lpds.sztaki.hu>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gabor Gombas wrote:
> Hi,
> 
> Since I have upgraded to 2.6.22.1 from 2.6.20 I have problems with
> Samsung disks. Sometimes the disks stall for about half a minute and
> then I have these messages in the logs:
> 
> Aug  6 20:10:11 twister kernel: ata7: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
> Aug  6 20:10:12 twister kernel: ata7: CPB 0: ctl_flags 0x9, resp_flags 0x0
> Aug  6 20:10:12 twister kernel: ata7: timeout waiting for ADMA IDLE, stat=0x400
> Aug  6 20:10:12 twister kernel: ata7: timeout waiting for ADMA LEGACY, stat=0x400
> Aug  6 20:10:12 twister kernel: ata7.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> Aug  6 20:10:12 twister kernel: ata7.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
> Aug  6 20:10:12 twister kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug  6 20:10:12 twister kernel: ata7: soft resetting port
> Aug  6 20:10:12 twister kernel: ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug  6 20:10:12 twister kernel: ata7.00: configured for UDMA/133
> Aug  6 20:10:12 twister kernel: ata7: EH complete
> Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] 488397168 512-byte hardware sectors (250059 MB)
> Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Write Protect is off
> Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> Aug  6 20:10:12 twister kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Aug  6 20:20:25 twister kernel: ata8: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
> Aug  6 20:20:25 twister kernel: ata8: CPB 0: ctl_flags 0x9, resp_flags 0x0
> Aug  6 20:20:25 twister kernel: ata8: timeout waiting for ADMA IDLE, stat=0x400
> Aug  6 20:20:25 twister kernel: ata8: timeout waiting for ADMA LEGACY, stat=0x400
> Aug  6 20:20:25 twister kernel: ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> Aug  6 20:20:25 twister kernel: ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 
> Aug  6 20:20:25 twister kernel:          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> Aug  6 20:20:25 twister kernel: ata8: soft resetting port
> Aug  6 20:20:25 twister kernel: ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Aug  6 20:20:25 twister kernel: ata8.00: configured for UDMA/133
> Aug  6 20:20:25 twister kernel: ata8: EH complete
> Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] 488397168 512-byte hardware sectors (250059 MB)
> Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Write Protect is off
> Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> Aug  6 20:20:25 twister kernel: sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> I also have two Maxtor disks on the same controller but they are working
> correctly in ADMA mode. I now disabled ADMA mode and that seems to help.

Hmmm... That's timeout on cache flush, indicative of failing disk.
Please post the result of 'smartctl -a /dev/sdc'.

-- 
tejun

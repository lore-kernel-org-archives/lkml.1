Return-Path: <linux-kernel-owner+w=401wt.eu-S1761575AbXGQGGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575AbXGQGGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXGQGGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:06:37 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:30592 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760706AbXGQGGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:06:36 -0400
Date: Tue, 17 Jul 2007 00:08:28 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv: 2.6.22 is not fixed, but certainly improved
In-reply-to: <fa.Y7u9A1ShoS8YDBp6YOFkRHtg2K0@ifi.uio.no>
To: Charles Shannon Hendrix <shannon@widomaker.com>
Cc: linux-kernel@vger.kernel.org, Allen Martin <AMartin@nvidia.com>,
       Jeff Garzik <jeff@garzik.org>
Message-id: <469C5CDC.8070908@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.zmoY2vXgUq7eREE2Ed2QLHUKvsI@ifi.uio.no>
 <fa.Y7u9A1ShoS8YDBp6YOFkRHtg2K0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Can you post the output you got from the reset on 2.6.22?

It's one of these:

ata4: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000
status 0x400 next cpb count 0x0 next cpb idx 0x0
ata4: CPB 0: ctl_flags 0x9, resp_flags 0x0
ata4: timeout waiting for ADMA IDLE, stat=0x400
ata4: timeout waiting for ADMA LEGACY, stat=0x400
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4: soft resetting port
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sdb] 156301488 512-byte hardware sectors (80026 MB)
sd 5:0:0:0: [sdb] Write Protect is off
sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA

Essentially the controller has been given a command (a cache flush, 
which for whatever reason seems to cause this frequently) but it doesn't 
give any indication that it has done anything with it (CPB response 
flags remain at 0). There have been a few reports of this, and I'm at a 
loss to explain why it happens. Certainly the publicly known information 
on this controller doesn't seem to give any hints on what if anything we 
could be doing wrong.

A workaround was added in sata_nv a while back that adds a delay between 
  completion of an NCQ command and issuing of a non-NCQ command, or vice 
versa. This seems to have improved things (for unknown reasons), but 
hasn't entirely fixed the problem. If your drive has NCQ support, it may 
be a remaining case of this problem.

I've previously asked for info on this issue from NVIDIA (as well as 
Jeff Garzik who has access to the controller documentation), but haven't 
gotten any info yet. Consider this another ping :-)

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


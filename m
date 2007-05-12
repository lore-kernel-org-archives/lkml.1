Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbXELTJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbXELTJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbXELTJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:09:34 -0400
Received: from app2.redhotpenguin.com ([64.151.90.21]:56318 "EHLO
	redhotpenguin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbXELTJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:09:33 -0400
X-Spam-Check-By: app2.redhotpenguin.com
Message-ID: <464610F7.6030202@redhotpenguin.com>
Date: Sat, 12 May 2007 12:09:43 -0700
From: Fred Moyer <fred@redhotpenguin.com>
User-Agent: Thunderbird 2.0.0.0 (Macintosh/20070326)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [2.6.21.1] SATA freeze
References: <fa.zU1kuoSgByTYCYqY+iCQ5rMJy34@ifi.uio.no> <46460C1B.6000609@shaw.ca>
In-Reply-To: <46460C1B.6000609@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Fred Moyer wrote:
>> I just joined the list today so apologies if this email breaks any 
>> email client post threading.
>>
>> I have been seeing similar errors on two different systems.  I applied 
>> Robert's sata_nv patch posted to the list on May 5th, and approved 
>> today by Jeff Garzik.  I've taken several steps to insure that this 
>> isn't a faulty cable or drive issue.  This is running on a hp 
>> dl145g2.  Here is my lspci, dmesg, and relevant kernel config sections:
> 
> (snip)
> 
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd b0/d2:f1:00:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 
>> 123392 in
>>          res 50/00:f1:00:4f:c2/00:00:00:00:00/00 Emask 0x202 (HSM 
>> violation)
>> ata1: soft resetting port
>> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
>> ata1.00: configured for UDMA/100
>> ata1: EH complete
> 
> This appears to be a different problem. Something is issuing 
> SMART-related commands (smartd or smartctl perhaps) which the drive 
> seems to be reacting strangely to. It apparently completed the command 
> but never raised DRQ to request any data being transferred even though 
> we expected it to. Maybe SMART is disabled on the drive and that's 
> causing it to just toss these commands? CCing linux-ide in case anyone 
> knows what would cause this.

Here's smartctl -a for this drive - same output for both sda and sdb. 
Smartd is currently running.  Any advice appreciated.

Previously on 2.6.15 I was seeing sdb remount as readonly under heavy 
i/o.  I have not seen that issue yet with 2.6.21 (with Robert's patch 
from May 5th for sata_nv), but that occurrence of remounts read-only was 
infrequently, so that issue may be solved.

app2 ~ # smartctl -a /dev/sda
smartctl version 5.36 [x86_64-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: ATA      ST3808110AS      Version: n/a
Serial number:             5LR8895K
Device type: disk
Local Time is: Sat May 12 12:05:58 2007 PDT
Device does not support SMART

Error Counter logging not supported

[GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
Device does not support Self Test logging

app2 ~ # ps aux | grep smart
root      5227  0.0  0.0   2892   672 ?        S    May11   0:00 
/usr/sbin/smartd -p /var/run/smartd.pid
root     19510  0.0  0.0   2648   648 pts/0    S+   12:07   0:00 grep 
--colour=auto smart

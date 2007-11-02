Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbXKBDes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbXKBDes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 23:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbXKBDel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 23:34:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50114 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbXKBDek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 23:34:40 -0400
Message-ID: <472A9ACB.6040107@garzik.org>
Date: Thu, 01 Nov 2007 23:34:35 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Heikki Orsila <shdl@zakalwe.fi>
CC: Max Krasnyansky <maxk@qualcomm.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange freezes (seems like SATA related)
References: <47261043.5020907@qualcomm.com> <20071101235348.GC3441@zakalwe.fi>
In-Reply-To: <20071101235348.GC3441@zakalwe.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila wrote:
> On Mon, Oct 29, 2007 at 09:54:27AM -0700, Max Krasnyansky wrote:
>> A couple of HP xw9300 machines (dual Opterons) started freezing up.
>> We're running on 2.6.22.1 on them. Freezes a somewhere weird. 
>> VGA console is alive
>> (I can switch vts, etc) but everything else is dead (network, etc).
> 
> I'm thinking this is not a coincidence. I was running 2.6.22.5, and 
> looking at your problems, I just had a similar experience on tuesday.. 
> The network was still fine after kernel errors so that I was able to 
> login with SSH. See:
> 
> 	http://lkml.org/lkml/2007/10/30/193
> 
>> ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1581000 status 0x1540 next cpb count 0x0 next cpb idx 0x0
>> ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd ca/00:08:57:00:80/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Descriptor sense data with sense descriptors (in hex):
>> end_request: I/O error, dev sda, sector 8388695
>> Buffer I/O error on device sda1, logical block 1048579
>> lost page write due to I/O error on sda1
>> sd 0:0:0:0: [sda] Write Protect is off
> 
> With ata_piix Intel SATA I got these errors:
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd ca/00:68:6f:3a:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 53248 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: port is slow to respond, please be patient (Status 0xd0)
> ata1: device not ready (errno=-16), forcing hardreset
> ata1: soft resetting port
> ata1.00: revalidation failed (errno=-2)
> ata1: failed to recover some devices, retrying in 5 secs
> ata1: soft resetting port
> ata1.00: configured for UDMA/133
> ata1: EH complete
> sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

These are two 100% different issues....  The only thing they have in 
common is that they spit out an error.

	Jeff




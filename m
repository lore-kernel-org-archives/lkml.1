Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXFMA1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXFMA1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 20:27:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbXFMA1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 20:27:41 -0400
Received: from idcmail-mo2no.cg.shawcable.net ([64.59.134.9]:53830 "EHLO
	pd8mo4no.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbXFMA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 20:27:40 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jun 2007 20:27:40 EDT
Date: Tue, 12 Jun 2007 17:27:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv adma issues
In-reply-to: <466ECA55.8020100@widomaker.com>
To: Charles Shannon Hendrix <shannon@widomaker.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <466F2BE5.7040700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.FTA/czKnA9MrTZ9ueGrcQfRm9qs@ifi.uio.no>
 <466E3563.1030900@shaw.ca> <466ECA55.8020100@widomaker.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Charles Shannon Hendrix wrote:
> Ah... I thought I put the error in my post.
> 
> Here is an example:
> 
> Jun 10 19:47:21 daydream kernel: [  174.432000] ata4: timeout waiting 
> for ADMA IDLE, stat=0x400
> Jun 10 19:47:21 daydream kernel: [  174.432000] ata4: timeout waiting 
> for ADMA LEGACY, stat=0x400
> Jun 10 19:47:21 daydream kernel: [  174.432000]          res 
> 40/00:00:00:00:00/0
> 0:00:00:00:00/00 Emask 0x4 (timeout)

Looks like a line or two is missing here, there should be one saying 
what the failed command was. Can you post the full dmesg output from the 
start with these occurrences in it?

> Jun 10 19:47:21 daydream kernel: [  174.744000] ata4: soft resetting port
> Jun 10 19:47:21 daydream kernel: [  174.900000] ata4: SATA link up 1.5 
> Gbps (SStatus 113 SControl 300)
> Jun 10 19:47:21 daydream kernel: [  174.908000] ATA: abnormal status 
> 0xD0 on port 0xf885659c
> Jun 10 19:47:21 daydream kernel: [  174.920000] ATA: abnormal status 
> 0xD0 on port 0xf885659c
> Jun 10 19:47:21 daydream last message repeated 2 times
> Jun 10 19:47:21 daydream kernel: [  174.936000] ata4.00: ata_hpa_resize 
> 1: sectors = 156301488, hpa_sectors = 156301488
> Jun 10 19:47:21 daydream kernel: [  174.944000] ata4.00: ata_hpa_resize 
> 1: sectors = 156301488, hpa_sectors = 156301488
> Jun 10 19:47:21 daydream kernel: [  174.944000] ata4.00: configured for 
> UDMA/133
> Jun 10 19:47:21 daydream kernel: [  174.944000] ata4: EH complete
> Jun 10 19:47:21 daydream kernel: [  174.944000] SCSI device sdb: 
> 156301488 512-byte hdwr sectors (80026 MB)
> Jun 10 19:47:21 daydream kernel: [  174.944000] sdb: Write Protect is off
> Jun 10 19:47:21 daydream kernel: [  174.944000] SCSI device sdb: write 
> cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> A lot of people reported this problem.  Basically the driver does this a 
> few times, and then stops.
> 
>> If sata_nv is built modular, then you may need to put:
>>
>> options sata_nv adma=0
> 
> It is, but I thought the kernel command line was still supposed to be 
> able to
> pass options to a module.  That's not correct?

It really should, but I don't think it does.

> 
> Anyway, I'll create a new init ramdisk with the module option set and 
> see how that works.
> 
>> However I should point out that adma=0 is a poor workaround, it would 
>> be better to find the real cause of the problem.
> 
> Agreed.
> 
> However, I tried all the patches and workarounds before, and had to give 
> up to get work done.
> 
> It has happened across two different motherboards, and on two drives.
> 
> Right now it happens with my second drive (I have two identical Seagate 
> SATA drives).  The last time I had adma enabled, it was the first drive.
> 
> No idea why it would be one drive one time and the other one a different 
> time.
> 
>> Please post the dmesg output from when this happens. If it starts 
>> working after the kernel disables NCQ, then it might mean that your 
>> drive has some problems with NCQ..
> 
> See above for dmesg output.
> 
> If that were true, then why would NCQ work perfectly under Windows?  
> Neither drive has issues there.
> 
> If the drives are at fault, then shouldn't they have the problem 
> regardless of the OS running?
> 
> FreeBSD had no trouble either.
> 
> Linux didn't have trouble until the 2.6.20 kernel.

There was no support for ADMA or NCQ on these controllers in Linux until 
2.6.20.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


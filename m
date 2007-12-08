Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbXLHDpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbXLHDpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 22:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXLHDpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 22:45:01 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:6939 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXLHDpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 22:45:00 -0500
Date: Fri, 07 Dec 2007 21:44:53 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Possible EXT2 race
In-reply-to: <fa.KAMBv2HxgDHKEZW9BUNlO1zsYAg@ifi.uio.no>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Dave Jones <davej@redhat.com>, Linux kernel <linux-kernel@vger.kernel.org>
Message-id: <475A1335.1080708@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.GlQhcAEmKY+sQUhug9FU2RfqU7U@ifi.uio.no>
 <fa.drfDhE7MUuSb7VZP+2J0c3nmSCc@ifi.uio.no>
 <fa.KAMBv2HxgDHKEZW9BUNlO1zsYAg@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-os (Dick Johnson) wrote:
> On Fri, 7 Dec 2007, Dave Jones wrote:
> 
>> On Fri, Dec 07, 2007 at 08:15:42AM -0500, linux-os (Dick Johnson) wrote:
>>
>>> Dec  7 04:05:55 chaos kernel: sd 0:0:1:0: [sdb] Add. Sense: Peripheral device write fault
>> This sounds more like a hardware problem.
>>
>> 	Dave
>>
> 
> There was an attempt to write beyond the end of the device because
> everything in the file-system was getting trashed. I can read/write
> the 5 year-old SCSI physical drive with no errors from both within
> linux and through the Adaptec BIOS. This problem only occurs
> when I attempt to truncate a file that is being written by another
> task.

That SCSI error code doesn't sound like a reasonable one for the drive 
getting a bad block address. The more typical one in that case would be 
"Logical block address out of range", or maybe the catch-all "Invalid 
field in CDB". "Peripheral device write fault", especially as a deferred 
error (i.e. after the drive already returned a normal completion for the 
data, and then is reporting the failure to actually write to the media 
on the next command), really sounds like a drive problem.

And the kernel is supposed to trap those at the disk layer, like these 
are saying it is, _after_ that error occurs:

Dec  7 04:08:13 chaos kernel: attempt to access beyond end of device
Dec  7 04:08:13 chaos kernel: sdb1: rw=0, want=29687515944, limit=33736437

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


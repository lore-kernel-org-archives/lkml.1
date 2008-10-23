Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbYJWUVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbYJWUVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 16:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYJWUV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 16:21:26 -0400
Received: from rtr.ca ([76.10.145.34]:47999 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbYJWUVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 16:21:25 -0400
Message-ID: <4900DCE4.3020901@rtr.ca>
Date: Thu, 23 Oct 2008 16:21:56 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
Cc: Tejun Heo <tj@kernel.org>, David Greaves <david@dgreaves.com>,
       linux-ide@vger.kernel.org,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [smartmontools-support] SMART to USB/sata dock in 2.6.27-rc5
 doesn't work
References: <48EE7E0A.8040701@dgreaves.com> <48F40164.5000502@kernel.org> <48F641A3.5080609@free.fr> <4900A0A7.3090102@rtr.ca> <4900C949.6040604@free.fr>
In-Reply-To: <4900C949.6040604@free.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

matthieu castet wrote:
> Mark Lord wrote:
>> matthieu castet wrote:
>>> Hi,
>>>
>>> Tejun Heo wrote:
>>>> David Greaves wrote:
>>>>> Error Counter logging not supported
>>>>> Device does not support Self Test logging
>>>>
>>>> The USB bridge should support SAT (SCSI-ATA translation) and many
>>>> don't.  Nothing much can be done about it.  The hardware just don't 
>>>> know
>>>> how to do it.
>>>>
>>> That true that the hardware should support SAT, but even if it 
>>> support it, linux need some patches to support SAT over USB. See 
>>> http://thread.gmane.org/gmane.linux.scsi/43688 and the patch 
>>> mentioned in the thread.
>> ...
>>
>> Ahh.. Great!  This mostly fixes smartctl operation on at least two
>> of my USB drive enclosures here:
>>
>>    1. a recent rev.  2.5" NexStar-3 SATA enclosure.
>>    2. a 250GB 2.5" WD "Passport" external USB drive/enclosure.
>>
>> With the patch, this command line works for me:
>>
>>    smartctl -a -dsat -T permissive /dev/sdb
>> And hdparm just works regardless, with or without the patch.
>>
>>
> It should work without permissive, permissive was need without the patch.
> 
> You said hdparm works without the patch. I wonder how it work. IRRC it 
> asks check condition stuff for every command. I am interested to see the 
> hdparm --verbose output without the patch.
..

Mmm... actually, the "-dsat" flag seems to make smartctl mostly work
with and without the patch.  This is on 2.6.25.6 on my notebook here.
Some month I'll update the kernel and fix VMware and wireless again
for a newer kernel, but for now that's what it runs.

Here's hdparm --verbose, sans patch:

hdparm --verbose -I /dev/sdb

/dev/sdb:
outgoing cdb:  85 08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
SG_IO: ATA_16 status=0x2, host_status=0x0, driver_status=0x8
SG_IO: sb[] = {72 00 00 00 00 00 00 0e}
SG_IO: desc[] = {09 0c .. }
      ATA_16 tf->status=0x00 tf->error=0x00

ATA device, with non-removable media
        Model Number:       Hitachi HTS541612J9SA00
        Serial Number:      SB2D11E4GESWAB
        Firmware Revision:  SBDOC74P
...

And here is smartctl -a -dsat, without the -T permissive flag:

smartctl -a -dsat /dev/sdb
smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Hitachi Travelstar 5K160 series
Device Model:     Hitachi HTS541612J9SA00
Serial Number:    SB2D11E4GESWAB
Firmware Version: SBDOC74P
User Capacity:    120,034,123,776 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   7
ATA Standard is:  ATA/ATAPI-7 T13 1532D revision 1
Local Time is:    Thu Oct 23 16:21:45 2008 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

Error SMART Status command failed
Please get assistance from http://smartmontools.sourceforge.net/
Values from ATA Return Descriptor are:
 00     09 0c 00 00 50 00 00 00  c2 4f 00 00 00 00
A mandatory SMART command failed: exiting. To continue, add one or more '-T permissive' options.


Cheers

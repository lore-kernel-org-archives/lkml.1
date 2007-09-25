Return-Path: <linux-kernel-owner+w=401wt.eu-S1753350AbXIYWlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbXIYWlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 18:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbXIYWkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 18:40:52 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44486 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbXIYWkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 18:40:51 -0400
Date: Tue, 25 Sep 2007 16:39:05 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
In-reply-to: <fa.Q/HeymU0u7VpG+dN5Lc1DraTos0@ifi.uio.no>
To: Jeff Garzik <jeff@garzik.org>
Cc: "Berck E. Nash" <flyboy@gmail.com>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Message-id: <46F98E09.70805@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7B5oGGPZtkIAG9trDHdybt+z9Qg@ifi.uio.no>
 <fa.lh2GEsFivC+TeMBqgRXU+5p7ySM@ifi.uio.no>
 <fa.tqIC/0YXN2BDEJQ7WBFuJ0EEUrI@ifi.uio.no>
 <fa.Q/HeymU0u7VpG+dN5Lc1DraTos0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Berck E. Nash wrote:
>> Jeff Garzik wrote:
>>> Once the blame has been squared fixed upon me :) you can use git-bisect
>>> to locate the precise change that broke your setup.
>>
>> Okay, here's the problem:
>>
>> 268fe6f9f15551be9abedd44a237392675d529d5 is first bad commit
>> commit 268fe6f9f15551be9abedd44a237392675d529d5
>> Author: Jeff Garzik <jeff@garzik.org>
>> Date:   Fri Sep 21 07:09:36 2007 -0400
>>
>>     [libata] SCSI: simple TEST UNIT READY simulation
>>
>>     It's trivial to ping the device, and that's a much more sane behavior
>>     than no-op.
>>
>>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
>>
>> :040000 040000 44d34cdad073bd623545b8239aca9a113652c6d0
>> df6d21f7ce56a4e796f8f856c1f647b0395ab4df M      drivers
> 
> Thanks for debugging!
> 
> Can you tell me something about this device?
> 
> [   49.045635] ata2.00: ATA-6: Config  Disk, RGL10364, max UDMA/133
> [   49.051677] ata2.00: 640 sectors, multi 1: LBA
> [   49.056321] ata2.00: configured for UDMA/133
> 
> It seems like it does not support the 'check power mode' command.
> 
> Can you post a text file attachment, containing the output of 'hdparm 
> --Istdout' ?

ATA spec says "The device shall return command aborted if the device 
does not support the Power Management feature set." Whereas TEST UNIT 
READY is required for SCSI. It seems the SAT authors didn't consider 
this case.

I assume we can tell from the identify data that the device doesn't 
support power management and just fake success for TEST UNIT READY in 
this case?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


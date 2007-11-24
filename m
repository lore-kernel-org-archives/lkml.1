Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbXKXAOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbXKXAOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 19:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXKXANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 19:13:52 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:38853 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXKXANv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 19:13:51 -0500
Date: Fri, 23 Nov 2007 18:13:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-reply-to: <474711FE.8040805@rtr.ca>
To: Mark Lord <liml@rtr.ca>
Cc: "Morrison, Tom" <tmorrison@empirix.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <47476CB9.2040409@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <47463534.9010100@shaw.ca> <4746F02D.2060204@rtr.ca>
 <BD261180E6D35F4D9D32F3E44FD3D901053E8542@EMPBEDEX.empirix.com>
 <474711FE.8040805@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Morrison, Tom wrote:
>> I am hopeful that the sata_mv has this bug (I proved that the
>> problem I was experiencing was due to the sata_mv driver with 3.75Gig 
>> or more of memory)...
>>  
>> I am on vacation for a week or more ...or I'd tell you today
>> if it did have this bug!
> ..
> 
> Yeah, I kind of had your reports in mind when I asked that.  :)
> 
> On a related note, I now have lots of Marvell (sata_mv) hardware here,
> and an Intel CPU/chipset box with physical RAM above the 4GB boundary.

Based on a quick look at sata_mv it appears it sets a 64-bit DMA mask 
unconditionally, but for non-ATA_PROT_DMA commands (which includes all 
ATAPI), it just falls back to ata_qc_issue_prot which issues via the 
legacy SFF interface and can only handle 32-bit addressing. So yes, it 
appears to have a similar bug as sata_nv had.

Likely it needs a similar slave_config trick to change bounce limit 
depending on the connected device, unless there is really a way to issue 
ATAPI commands with this EDMA interface, as the TODO list in sata_mv.c 
suggests may be possible..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


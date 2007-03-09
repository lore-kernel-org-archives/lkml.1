Return-Path: <linux-kernel-owner+w=401wt.eu-S1767313AbXCIO1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767313AbXCIO1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 09:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767321AbXCIO1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 09:27:50 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:13970 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767313AbXCIO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 09:27:49 -0500
Date: Fri, 09 Mar 2007 08:27:47 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch 29/30] sata_nv: don't read shadow registers when in ADMA
 mode
In-reply-to: <45F154A8.1050606@garzik.org>
To: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org
Message-id: <45F16EE3.40602@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200703061038.l26AcD3M019553@shell0.pdx.osdl.net>
 <45F154A8.1050606@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> akpm@linux-foundation.org wrote:
>> From: Robert Hancock <hancockr@shaw.ca>
>>
>> Reading from the ATA shadow registers while we are in ADMA mode may cause
>> undefined behavior.  Don't read the ATA status register when completing
>> commands for this reason, it shouldn't be needed as the controller will
>> notify us if the command failed.  Also, don't allow commands with result
>> taskfile requested to execute in ADMA mode, since that requires accessing
>> the shadow registers.  We also still need to override tf_read since 
>> libata
>> will read the result taskfile on a command failure, and we need to go 
>> into
>> port register mode before allowing this.
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  drivers/ata/sata_nv.c |   33 ++++++++++++++++++++-------------
>>  1 file changed, 20 insertions(+), 13 deletions(-)
> 
> Robert, do you think this should be pushed into #upstream-fixes 
> (2.6.21-rc)?
> 
> I lean towards "yes", since it is a needed-by-hardware fix, but I also 
> am interested in testing feedback since it is so late in the 2.6.21-rc 
> game.

I would lean toward that as well, but it would be good to get some 
testing from some sata_nv ADMA users to make sure it doesn't do anything 
funny for them..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


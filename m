Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXA2X5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXA2X5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 18:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965015AbXA2X5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 18:57:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:30000 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965041AbXA2X5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 18:57:09 -0500
Date: Mon, 29 Jan 2007 17:55:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH RFC] sd: spin down disks on removal or power-down
In-reply-to: <20070129154706.dfb3edab.akpm@osdl.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
Message-id: <45BE897D.7000400@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <45BD522F.3070706@shaw.ca> <20070129154706.dfb3edab.akpm@osdl.org>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> triviata:
> 
>> --- linux-2.6.20-rc6nv/drivers/scsi/sd.c	2007-01-28 17:00:00.000000000 -0600
>> +++ linux-2.6.20-rc6nvedit/drivers/scsi/sd.c	2007-01-28 18:08:53.000000000 -0600
>> @@ -821,6 +821,39 @@ static int sd_sync_cache(struct scsi_dev
>>  	return res;
>>  }
>>  
>> +static int sd_stop_unit(struct scsi_device *sdp, struct scsi_disk* sdkp)
> 
> s/* / */
> 
>> +{
>> +	int res;
>> +	struct scsi_sense_hdr sshdr;
>> +	unsigned char cmd[10] = { 0 };
> 
> I don't think this initialisation-to-all-zeroes is needed, is it?

Pretty sure it is, the rest of the command needs to be set to 0. Without 
it the other 9 bytes will contain uninitialized junk.

For the other cleanup changes, though:

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/




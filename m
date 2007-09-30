Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXI3Xp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXI3Xp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXI3Xpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:45:49 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:13564 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbXI3Xps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:45:48 -0400
Date: Sun, 30 Sep 2007 17:45:41 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] blacklist NCQ on Seagate Barracuda ST380817AS
In-reply-to: <fa.ernzRd7lGBTxTXHl/DtyMhz/rPk@ifi.uio.no>
To: Paolo Ornati <ornati@fastwebnet.it>
Cc: Tejun Heo <htejun@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <47003525.7040407@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ernzRd7lGBTxTXHl/DtyMhz/rPk@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ornati wrote:
> Hi, I think you forgot to blacklist this one  :)
> 
> --
> Seagate Barracuda ST380817AS has troubles with NCQ. For example,
> unpacking a tarball on an XFS filesystem gives this:
> 
> ata1.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x2 frozen
> ata1.00: cmd 61/40:00:29:a3:98/00:00:00:00:00/40 tag 0 cdb 0x0 data 32768 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> 
> More info here:
> http://lkml.org/lkml/2007/1/21/76
>     
> Blacklist it!
>     
> Signed-off-by: Paolo Ornati <ornati@fastwebnet.it>
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 772be09..be289d0 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3781,6 +3781,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "Maxtor 7B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ, },
>  	{ "Maxtor 7B300S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
>  	{ "Maxtor 7V300F0",	"VA111630",	ATA_HORKAGE_NONCQ },
> +	{ "ST380817AS",		"3.42",		ATA_HORKAGE_NONCQ },
>  	{ "HITACHI HDS7250SASUN500G 0621KTAWSD", "K2AOAJ0AHITACHI",
>  	 ATA_HORKAGE_NONCQ },
>  	/* NCQ hard hangs device under heavier load, needs hard power cycle */
> 
> 

Are you sure this isn't just a bum drive? Looking at the SMART listing 
that was posted, looks like it's had some uncorrectable sector read 
errors in the event log..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


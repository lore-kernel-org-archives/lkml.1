Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbXBWWQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbXBWWQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 17:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933237AbXBWWQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 17:16:44 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49834 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933240AbXBWWQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 17:16:43 -0500
Message-ID: <45DF67C4.8090802@garzik.org>
Date: Fri, 23 Feb 2007 17:16:36 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tejun Heo <htejun@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver
References: <45DD2EC9.4050403@shaw.ca>
In-Reply-To: <45DD2EC9.4050403@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This patch adds in some NCQ blacklist entries taken from the Silicon
> Image Windows drivers' .inf files for the 3124 and 3132 controllers.
> These entries were marked as ""DisableSataQueueing". Assume these are
> in their blacklist for a reason and disable NCQ on these drives.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> --- linux-2.6.21-rc1edit/drivers/ata/libata-core.c.prev    2007-02-21 
> 22:23:05.000000000 -0600
> +++ linux-2.6.21-rc1edit/drivers/ata/libata-core.c    2007-02-21 
> 22:25:44.000000000 -0600
> @@ -3269,6 +3269,13 @@ static const struct ata_blacklist_entry
>     /* Devices with NCQ limits */
> 
> +    /* The following blacklist entries are taken from the Windows
> +       driver .inf files for the Silicon Image 3124 and 3132. */
> +    { "Maxtor 7B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ, },
> +    { "HTS541060G9SA00",    "MB3OC60D",    ATA_HORKAGE_NONCQ, },
> +    { "HTS541080G9SA00",    "MB4OC60D",    ATA_HORKAGE_NONCQ, },
> +    { "HTS541010G9SA00",    "MBZOC60D",    ATA_HORKAGE_NONCQ, },


The general consensus of private emails seems to be that its ok to 
blacklist the Maxtor one, at least.

So let's go ahead and at least get that entry in.

	Jeff



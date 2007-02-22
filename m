Return-Path: <linux-kernel-owner+w=401wt.eu-S1751444AbXBVG5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbXBVG5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXBVG5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:57:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:34446 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbXBVG5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:57:17 -0500
Message-ID: <45DD3EC7.3050801@garzik.org>
Date: Thu, 22 Feb 2007 01:57:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Tejun Heo <htejun@gmail.com>
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

Do we have information that these drives fail on non-SiI controllers?

Sometimes the problem can be related to a single family of controllers.

	Jeff




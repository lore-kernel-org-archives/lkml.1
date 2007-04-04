Return-Path: <linux-kernel-owner+w=401wt.eu-S2992691AbXDDGKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992691AbXDDGKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXDDGKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:10:05 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41657 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992683AbXDDGKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:10:02 -0400
Message-ID: <46134137.2010102@pobox.com>
Date: Wed, 04 Apr 2007 02:09:59 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver (v2)
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070331181940.GV14134@stusta.de> <4611D289.5090209@shaw.ca>
In-Reply-To: <4611D289.5090209@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This adds some NCQ blacklist entries taken from the Silicon Image 3124/3132
> Windows driver .inf files. There are some confirming reports of problems
> with these drives under Linux (for example 
> http://lkml.org/lkml/2007/3/4/178)
> so let's disable NCQ on these drives.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> --- linux-2.6.21-rc5-git9/drivers/ata/libata-core.c    2007-04-02 
> 21:03:29.000000000 -0600
> +++ linux-2.6.21-rc5-git9edit/drivers/ata/libata-core.c    2007-04-02 
> 21:26:23.000000000 -0600
> @@ -3363,6 +3363,11 @@ static const struct ata_blacklist_entry     { 
> "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
>     /* NCQ hard hangs device under heavier load, needs hard power cycle */
>     { "Maxtor 6B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ },
> +    /* Blacklist entries taken from Silicon Image 3124/3132
> +       Windows driver .inf file - also several Linux problem reports */
> +    { "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },
> +    { "HTS541080G9SA00",    "MB4OC60D",     ATA_HORKAGE_NONCQ, },
> +    { "HTS541010G9SA00",    "MBZOC60D",     ATA_HORKAGE_NONCQ, },

The thread you link to seems like an irq problem, especially because it 
worked in 2.6.20 and prior?

	Jeff




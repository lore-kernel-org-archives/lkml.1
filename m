Return-Path: <linux-kernel-owner+w=401wt.eu-S1751147AbXBUH57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbXBUH57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 02:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXBUH57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 02:57:59 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:49500 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbXBUH56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 02:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=a7JA2S3FmM1y+45+KgKdX2wDQ7K5dyhU87c/s28M4/EIIS6UMZTzfnLBbsGhwKViubnMt9Kv/myknBofj56AcEgypeg0s0FTgvR662x7FCdt1clDRAeMvoxq4dMuh9jn7vNh6HVyBCPYTuggtljQKCGHgMB076kXb5y3mdxZud0=
Message-ID: <45DBFB82.3090504@gmail.com>
Date: Wed, 21 Feb 2007 16:57:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH RFC] libata: FUA updates
References: <45DA4E13.10700@shaw.ca>
In-Reply-To: <45DA4E13.10700@shaw.ca>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This updates libata FUA support to be more more in line with reality.
> FUA support remains off by default.
> 
> Add a setting for the fua command-line parameter on libata which enables
> FUA only on NCQ-supporting disks.
> 
> Update the ata_dev_supports_fua function to remove the blacklisting of
> Maxtor BANC1G10 firmware, as there is no conclusive evidence it was ever
> needed.
> 
> Centralize all of the FUA on/off decisions in this function.
> 
> Bypass the checks for FUA command support bit for NCQ disks, since that
> bit only applies to non-NCQ FUA, and FUA is part of the spec for NCQ
> commands.
> 
> When queue depth is set by the user resulting in enabling/disabling
> NCQ, trigger a revalidate so that the FUA state will be rechecked,
> since disabling/enabling NCQ may also affect FUA support on some disks.
> 
> Add a controller flag to indicate it doesn't support FUA commands, and
> set this flag for Silicon Image 311x (since that one is known to have
> problems) as well as for ITE821x when in smart mode.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

Yeap, I like the clean up.  Just a few comments.

* s/if(/if (/

* The patch adds a number of trailing white spaces.  I suggest using git
or quilt for patch management.  They complain when they see such things.

I'm still not so sure about NCQ FUA.  I still think that separate opcode
for FUA ops is the right thing to do (tm), well, or the safer thing to
do (tm).  Regarding drives which support NCQ but not separate opcode for
FUA, unless many drives are like that, I don't think the loss is too
great.  Also, I'm more uncomfortable with trusting those drives doing
NCQ FUA properly.

Let's talk about this on the other thread.

Thanks.

-- 
tejun

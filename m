Return-Path: <linux-kernel-owner+w=401wt.eu-S964783AbXBLIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbXBLIbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 03:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933125AbXBLIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 03:31:25 -0500
Received: from wr-out-0506.google.com ([64.233.184.225]:47064 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122AbXBLIbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 03:31:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=fXTGyxL6ziWZcTOSd/1snH4mitw4Nlw9BHV3hrSgl2dcNbDK79MpurV0e6imk6Y7SwHGGkfDmGQkFaakC71gpaFHW96iPp+8p+DHSM0PlwrUYRs9mQ2jcl4C1+X/Vq9yer332AgmjsCnIup4SNIrRg0uul0zskPOEOD07zgnAdo=
Message-ID: <45D025CB.6070205@gmail.com>
Date: Mon, 12 Feb 2007 00:31:07 -0800
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       edmudama@gmail.com, Nicolas.Mailhot@LaPoste.net
Subject: Re: libata FUA revisited
References: <45CFDE27.5030607@shaw.ca>
In-Reply-To: <45CFDE27.5030607@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
[--correct summary snipped--]
> Given the above, what I'm proposing to do is:
> 
> -Remove the blacklisting of Maxtor BANC1G10 firmware for FUA. If we need 
> to FUA-blacklist any drives this should likely be added to the existing 
> "horkage" mechanism we now have. However, at this point I don't think 
> that's needed, considering that I've seen no conclusive evidence that 
> any drive has ever been established to have broken FUA.

Agreed.

> -Add a new port flag ATA_FLAG_NO_FUA to indicate that a controller can't 
> handle FUA commands, and add that flag to sata_sil. Force FUA off on any 
> drive connected to a controller with this bit set.
> 
> There was some talk that sata_mv might have this problem, but I believe 
> the conclusion was that it didn't. The only controllers that would are 
> ones that actually try to interpret the ATA command codes and don't know 
> about WRITE DMA FUA.

I think it would be better to add ATA_FLAG_FUA instead of ATA_FLAG_NO_FUA.

> -Change the fua module option to control FUA enable/disable to have a 
> third value, "enable for NCQ-supporting drives only", which would become 
> the new default. That case seems less likely to cause problems since FUA 
> on NCQ is just another bit in the command whereas FUA on non-NCQ is an 
> entirely different, potentially unsupported command.

Not enabling FUA doesn't result in huge performance hit.  I'm not sure 
whether we should go such far.  Just supporting FUA on known good 
controllers sounds good enough to me.

> Any comments?
> 
> As an aside, I came across a comment that the Silicon Image Windows 
> drivers for NCQ-supporting controllers have some blacklist entries for 
> drives with broken NCQ in their .inf files. We only seem to have one in 
> the libata NCQ blacklist, we may want to add some more of these. The 
> ones in the current SiI3124 and 3132 drivers' .inf files for 
> "DisableSataQueueing" appear to be:
> 
> Model                Firmware
> Maxtor 7B250S0            BANC1B70
> HTS541060G9SA00            MB3OC60D
> HTS541080G9SA00            MB4OC60D
> HTS541010G9SA00            MBZOC60D
> 
> (the latter 3 being Hitachi Travelstar drives)

Yeah, I don't think we need to be too careful about blacklisting NCQ 
considering the sorry state of many early NCQ firmwares.  Please submit 
a patch.  It would be nice if you add a comment why the drives are added 
for documentation.

Thanks.

-- 
tejun

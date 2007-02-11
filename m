Return-Path: <linux-kernel-owner+w=401wt.eu-S932906AbXBKXGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906AbXBKXGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 18:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbXBKXGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 18:06:15 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:61831 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906AbXBKXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 18:06:14 -0500
Date: Sun, 11 Feb 2007 17:04:55 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sata_nv - ADMA issues with 2.6.20
In-reply-to: <fa.skzjVxsBWVzk9Yzhsb2UIA1VDGY@ifi.uio.no>
To: linux-kernel@vger.kernel.org
Cc: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Neil Schemenauer <nas@arctrix.com>, david@unsolicited.net
Message-id: <45CFA117.3030508@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <fa.4+EfmBKJuhLBKrzZ9Tr6IwbmP9o@ifi.uio.no>
 <fa.k0ZDYzgHEXJHC2/UddL2J4jq/kE@ifi.uio.no>
 <fa.W/MKSda79+AG31HO6bl30nzW79o@ifi.uio.no>
 <fa.skzjVxsBWVzk9Yzhsb2UIA1VDGY@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> If the look like this, you might want to try a few patches that are in
> -mm.
> 
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata1.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0 out
>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata1: soft resetting port
> 
> We thought that Robert had fixed these with some changes that went into
> -rc6. But they reappeared a few days later, the -mm patches seem to have
>  finally cured it.
> 
> The original patches are here:
> 
> http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2.patch
> http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-cleanup-adma-error-handling-v2-cleanup.patch
> http://www2.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out/sata_nv-use-adma-for-nodata-commands.patch
> 
> As they had a few rejects against 2.6.20-rc7, I'm attaching my fixed all-in-one version of these patches, I guess it should apply to 2.6.20 just fine.

This isn't quite the same as that problem we were seeing, these are an 
actual NCQ read/write that is timing out and not a cache flush command. 
Nevertheless it wouldn't hurt for people having this problem to test out 
the latest and greatest sata_nv patches. In particular there was one 
that I resurrected from the debugging of that problem, "sata_nv: wait 
for response on entering/leaving ADMA mode" which though it didn't end 
up fixing it, seemed like a good thing to be doing anyway, and which 
potentially might have some effect on this problem here.

All the patches I have for sata_nv are in Linus' git tree, that is 
probably a simpler way to test them than -mm right now - applying the 
2.6.20-git6 patch on top of 2.6.20 should do it.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758814AbXERB7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814AbXERB7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 21:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbXERB67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 21:58:59 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:63447 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbXERB67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 21:58:59 -0400
Date: Thu, 17 May 2007 19:58:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for
 MCP51/MCP55/MCP61
In-reply-to: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>
To: Zoltan Boszormenyi <zboszor@dunaweb.hu>
Cc: Peer Chen <pchen@nvidia.com>, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <464D0855.20703@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
References: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zoltan Boszormenyi wrote:
> Hi,
> 
> thanks for publishing this.
> 
>> Add the Software NCQ support to sata_nv.c for MCP51/MCP55/MCP61 SATA
>> controller.
>>
>> This patch base on sata_nv.c file from kernel 2.6.22-rc1
>>
>> See attachment for the patch.
>>
>> Signed-off-by: Kuan Luo <kluo@nvidia.com>
>> Signed-off-by: Peer Chen <pchen@nvidia.com>
>> ==================================
>> See attached file.
>> ==================================
>>   
> 
> However, I saw this in the patch:
> 
> +               /* determine if physical DMA addr spans 64K boundary.
> +                * Note h/w doesn't support 64-bit, so we unconditionally
> +                * truncate dma_addr_t to u32.
> +                */
> +               addr = (u32) sg_dma_address(sg);
> 
> Does it mean that I can't upgrade my machine to 4 GB or more
> without losing NCQ or risking data corruption?
> Can the code be made IOMMU-aware?

That shouldn't be a problem, libata default DMA mask is 32 bits (which 
isn't overridden with this controller) and so the block layer will 
bounce any data being read/written above that point with IOMMU or 
swiotlb. The comment is a bit unnecessarily scary.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


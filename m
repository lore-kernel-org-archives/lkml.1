Return-Path: <linux-kernel-owner+w=401wt.eu-S1764031AbXETIej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764031AbXETIej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 04:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbXETIec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 04:34:32 -0400
Received: from linux.dunaweb.hu ([62.77.196.1]:40033 "EHLO linux.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758154AbXETIeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 04:34:31 -0400
Message-ID: <465007FD.2060807@dunaweb.hu>
Date: Sun, 20 May 2007 10:34:05 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Peer Chen <pchen@nvidia.com>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/ata: Add the SW NCQ support to sata_nv for MCP51/MCP55/MCP61
References: <fa.iernIz8Xcuvw0SBwi4A99Ju0g2o@ifi.uio.no>	<464D0855.20703@shaw.ca> <20070518133456.5f1392e9@the-village.bc.nu> <464DB97B.8030204@garzik.org>
In-Reply-To: <464DB97B.8030204@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Jeff Garzik írta:
> Alan Cox wrote:
>>> That shouldn't be a problem, libata default DMA mask is 32 bits 
>>> (which isn't overridden with this controller) and so the block layer 
>>> will bounce any data being read/written above that point with IOMMU 
>>> or swiotlb. The comment is a bit unnecessarily scary.
>>
>> Adding a BUG_ON for this would be wise. Its trivial to check and a BUG
>> rather than corruption if this assumption ever changes would be far
>> preferable
>
> The default DMA mask -everywhere- is 32 bits.
>
> A lot of code will break if this assumption ever changes, not just 
> libata.
>
>     Jeff

thanks for clarifying this.

I tested the effect of this patch on 2.6.22-rc2 + CFS-v13
with the current CVS version of PostgreSQL 8.3devel.
pgbench with 25 clients and some large number of
transactions to make the result stable showed substantial
increase in throughput. Without NCQ, I got around 446 tps,
with NCQ I got around 680 via local TCP connection.
Previously, I got this level of performance only over
local unix socket and smaller number of simultaneous clients.
The disk is Seagate 320GB (ST3320620AS).

Again, thanks for this patch.

Best regards,
Zoltán Böszörményi


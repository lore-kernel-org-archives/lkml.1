Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbZA0Xql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbZA0Xql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZA0Xqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:46:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57128 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbZA0Xqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:46:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <497F9CC5.8080807@s5r6.in-berlin.de>
Date: Wed, 28 Jan 2009 00:46:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: swiotlb default size (64 MB) too small?
References: <20090127165508L.fujita.tomonori@lab.ntt.co.jp>	<20090127183723W.fujita.tomonori@lab.ntt.co.jp>	<tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de> <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> +static void sbp2_unmap_scatterlist(struct device *card_device,
>> +				   struct sbp2_command_orb *orb)
>> +{
>> +	if (scsi_sg_count(orb->cmd))
>> +		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
>> +			     scsi_sg_count(orb->cmd),
>> +			     orb->cmd->sc_data_direction);
>> +
>> +	if (orb->page_table_bus)
>> +		dma_unmap_single(card_device, orb->page_table_bus,
>> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> 
> Well, this does not look correct since zero can be a valid dma
> address.

Hmm.

> static void sbp2_unmap_scatterlist(struct device *card_device,
> 				   struct sbp2_command_orb *orb)
> {
> 	if (scsi_sg_count(orb->cmd))
> 		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> 			     scsi_sg_count(orb->cmd),
> 			     orb->cmd->sc_data_direction);
> 
> 	if (scsi_sg_count(orb->cmd) > 1)
> 		dma_unmap_single(card_device, orb->page_table_bus,
> 				 sizeof(orb->page_table), DMA_TO_DEVICE);
> 
> 
> Well, looks cranky a bit but firewire is cranky for me :)

Even if scsi_sg_count(cmd) > 1, the outcome of dma_map_sg() could have
been 1, couldn't it?  So I need to take note of that in another way.
-- 
Stefan Richter
-=====-==--= ---= ===--
http://arcgraph.de/sr/

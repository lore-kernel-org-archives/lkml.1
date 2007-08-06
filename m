Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbXHFPeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbXHFPeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763015AbXHFPeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:34:06 -0400
Received: from cluster-d.mailcontrol.com ([217.69.20.190]:39233 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbXHFPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:34:04 -0400
Message-ID: <46B73F18.5030109@csr.com>
Date: Mon, 06 Aug 2007 16:32:40 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org
Subject: Re: sdio: enhance IO_RW_EXTENDED support
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com> <20070806171207.59fafa18@poseidon.drzeus.cx>
In-Reply-To: <20070806171207.59fafa18@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2007 15:32:41.0346 (UTC) FILETIME=[06E37E20:01C7D83F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Mon, 06 Aug 2007 11:31:19 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> I would expect the block size to be set once per card, and never be
>> changed and thus it's not logically a per-transfer operation.  We
>> certainly wouldn't want to change the block size willy-nilly as it's
>> an expensive operation.
>>
> 
> Indeed. It would of course be optimized so that it doesn't change the
> size needlessly.

Drivers may care about the block size though so you can't have it
changing behind their backs. e.g., they may need to pad data to a
multiple of the block size.

>>> I suspect that some transactions might require a certain block size.
>>> But we could satisfy that by stating that any transfer small enough
>>> to fit into one block will not be split up.
>> I consider it unlikely that any card would want to do anything other
>> than always use the largest possible block size.
>>
> 
> I have a counter example. I have here a Marvell wifi card which needs a
> firmware upload. And it seems to be rather picky about parameters
> during that upload.
>
> I'm still experimenting with a clean way to do things for this card.
> I'll get back to you. :)

sdio_set_block_size(func, 64); /* ew, this card is fussy */

download_firmware();

sdio_set_block_size(func, func->max_blksize); /* Ahhh, back to the
card's default */

If a card is fussy about the block size I don't think there's anything
cleaner than specifying directly in the driver.

David
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

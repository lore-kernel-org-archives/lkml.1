Return-Path: <linux-kernel-owner+w=401wt.eu-S1764189AbXHHNXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764189AbXHHNXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:23:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757747AbXHHNXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:23:25 -0400
Received: from cluster-g.mailcontrol.com ([85.115.41.190]:55271 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbXHHNXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:23:24 -0400
Message-ID: <46B9C38C.1030708@csr.com>
Date: Wed, 08 Aug 2007 14:22:20 +0100
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: linux-kernel@vger.kernel.org, David Vrabel <david.vrabel@csr.com>
Subject: Re: [patch 3/4] sdio: extend sdio_readsb() and friends to handle
 any length of buffer
References: <11858961933491-git-send-email-david.vrabel@csr.com>	<20070804152304.65ed8f1b@poseidon.drzeus.cx>	<46B6F877.7060504@csr.com>	<20070806171207.59fafa18@poseidon.drzeus.cx>	<46B73F18.5030109@csr.com>	<20070806220145.66b97559@poseidon.drzeus.cx>	<46B86ADB.90000@csr.com>	<46B86BB0.4000100@csr.com>	<20070807221719.7c89e5b6@poseidon.drzeus.cx>	<46B998B5.9040203@csr.com> <20070808123759.26a74b2a@poseidon.drzeus.cx>
In-Reply-To: <20070808123759.26a74b2a@poseidon.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Aug 2007 13:22:21.0076 (UTC) FILETIME=[26787D40:01C7D9BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Wed, 08 Aug 2007 11:19:33 +0100
> David Vrabel <david.vrabel@csr.com> wrote:
> 
>> We need to know the block size in use /before/ the start of the
>> transfer as we would like drivers to be able to perform transfers
>> with single commands as this can result in significantly better
>> performance[1].  The drivers for our (CSR's) WiFi chips should do
>> this.  This isn't some (as you suggested in a previous post) 'rare'
>> requirement.
>>
> 
> Well, there are more ways that can be achieved.
> 
> First, the driver could lock down the block size using
> sdio_force_block_size(). Then it knows what it gets.
> 
> Second, we could try to make it possible for the driver to indicate
> "feel free to pad this transfer". Then we could also remove the need
> for drivers to mess with buffers and keep such stuff in the core. We
> could even magically remove a memcpy() by setting up two sg entries,
> one for the data and one for the padding.

Setting the block size in io_rw_ext_helper() has several drawbacks, namely:

1. Reduces the flexibility of drivers to manage what commands are performed.
2. A performance penalty on the first transfer.
3. Greater code complexity.
4. Non-intuitive location for card initialization code.

Sure we could just through hoops and add (much) extra complexity to the
core, to improve item 1 but 2, 3 and 4 are insoluble. Given that setting
block size before the first command has /zero/ benefits[1], why bother?

Your insistence on this stupid idea baffles me, particularly in the
light of your other useful comments.

I would also like to advise that until a larger number of function
drivers become available that the core is kept as simple and as flexible
as possible.  Without knowing how different cards operate it is
difficult to know what's common behaviour and what's card specific.

My latest (and hopefully final) patch set follows.

David

[1] dynamic block sizing was (potentially) a useful benefit but I have
comprehensibly shown it's not beneficial.  The idea that is somehow
necessary to permit the core to change it's block size selection
algorithm is bogus.
-- 
David Vrabel, Software Engineer, Drivers group  Tel: +44 (0)1223 692562
CSR plc, Churchill House, Cambridge Business Park, Cowley Road, CB4 0WZ


.

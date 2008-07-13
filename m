Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYGMUN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYGMUN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbYGMUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:13:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34891 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911AbYGMUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:13:19 -0400
Message-ID: <487A61DD.6090304@firstfloor.org>
Date: Sun, 13 Jul 2008 22:13:17 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: mpatocka@redhat.com, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
References: <87iqvb2skz.fsf@basil.nowhere.org>	<Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>	<487A083F.9010301@firstfloor.org> <20080713.124610.193703496.davem@davemloft.net>
In-Reply-To: <20080713.124610.193703496.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Andi Kleen <andi@firstfloor.org>
> Date: Sun, 13 Jul 2008 15:50:55 +0200
> 
>> Still I would expect that modern IO controllers are typically fast
>> enough at processing SG lists that it shouldn't matter much.
> 
> I know it matters a lot on sparc64 ESP scsi controllers.
> 
> You can only have one address/len pair DMA'ing at a time and you have
> to service an interrupt to load in the the next DMA sg elements into
> the chips registers.
> 
> Merging is essentially a must for performance on those cards.

Well right now your setup breaks all controllers with "weird requirements"
like 64k DMA or similar. You'll need to find some way to turn off BIO
merge for those at least.

Perhaps this needs to be really a block queue attribute instead of a global?

-Andi



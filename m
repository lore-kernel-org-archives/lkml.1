Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYGMXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYGMXxX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 19:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYGMXxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 19:53:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338AbYGMXxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 19:53:14 -0400
Date: Sun, 13 Jul 2008 19:53:01 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@devserv.devel.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
In-Reply-To: <487A61DD.6090304@firstfloor.org>
Message-ID: <Pine.LNX.4.64.0807131947090.7803@devserv.devel.redhat.com>
References: <87iqvb2skz.fsf@basil.nowhere.org>
 <Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>
 <487A083F.9010301@firstfloor.org> <20080713.124610.193703496.davem@davemloft.net>
 <487A61DD.6090304@firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2008, Andi Kleen wrote:

> David Miller wrote:
>> From: Andi Kleen <andi@firstfloor.org>
>> Date: Sun, 13 Jul 2008 15:50:55 +0200
>>
>>> Still I would expect that modern IO controllers are typically fast
>>> enough at processing SG lists that it shouldn't matter much.
>>
>> I know it matters a lot on sparc64 ESP scsi controllers.
>>
>> You can only have one address/len pair DMA'ing at a time and you have
>> to service an interrupt to load in the the next DMA sg elements into
>> the chips registers.
>>
>> Merging is essentially a must for performance on those cards.
>
> Well right now your setup breaks all controllers with "weird requirements"
> like 64k DMA or similar. You'll need to find some way to turn off BIO
> merge for those at least.
>
> Perhaps this needs to be really a block queue attribute instead of a global?
>
> -Andi

There is no need to turn BIO merge off --- the problem is caused by 
accounting of BIO merging in block layer, not by BIO merging itself.

Just do #define BIO_VMERGE_BOUNDARY 0, and that disables the accounting, 
but leaves merging as it is.

Mikulas

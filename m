Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838Ab0AFNmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab0AFNmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 08:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604Ab0AFNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 08:42:12 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:43534 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0AFNmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 08:42:09 -0500
Message-ID: <4B4492B2.1040107@vflare.org>
Date: Wed, 06 Jan 2010 19:10:02 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] [mmotm] Add swap slot free callback to block_device_operations
References: <1262661514-4148-1-git-send-email-ngupta@vflare.org> <alpine.LSU.2.00.1001051045510.26135@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1001051045510.26135@sister.anvils>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/05/2010 04:28 PM, Hugh Dickins wrote:
> On Tue, 5 Jan 2010, Nitin Gupta wrote:
> 
>> This callback is required when RAM based devices are
>> used as swap disks. One such device is ramzswap[1] which
>> is used as compressed in-memory swap disk. For such
>> devices, we need a callback as soon as a swap slot is no
>> longer used to allow freeing memory allocated for this
>> slot. Without this callback, stale data can quickly
>> accumulate in memory defeating the whole purpose of
>> such devices.
>>
>> Another user of this callback will be "preswap" as
>> introduced by "Transcendent Memory" patches:
>> http://lwn.net/Articles/367286/
>> (I intend to integrade preswap with ramzswap).
>>
>> [1] ramzswap: http://code.google.com/p/compcache/
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> Yes, thanks for your patience in putting this together:
> I much prefer this version to all the other ways considered.
> 

> (Though you should later add a comment, pointing out that this
> callback is with swap_lock and often page table lock also held.)
> 

I will send another patch for this.

> We know that's unsatisfactory, but it is the nature of swap:
> cutting some corners to get the job done without allocating
> more memory.  Having tried myself to do proper discard at
> swap_free time, I know that is hard: and I believe you've
> made the right decision to do it in this way for ramzswap.
> 
> Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 

Thanks for the review.
So, is this now going in mmotm tree?

Nitin

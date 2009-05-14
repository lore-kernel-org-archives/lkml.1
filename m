Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbZENNFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbZENNFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 09:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbZENNFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 09:05:21 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53063 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760436AbZENNFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 09:05:19 -0400
Date: Thu, 14 May 2009 15:04:55 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <1242302702.6642.1140.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utw7yhv67p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2009-05-14 at 13:48 +0200, Michał Nazarewicz wrote:
>>> On Thu, 2009-05-14 at 11:00 +0200, Michał Nazarewicz wrote:
>>>>   PMM solves this problem since the buffers are allocated when they
>>>>   are needed.

>> On Thu, 14 May 2009 13:20:02 +0200, Peter Zijlstra wrote:
>>> Ha - only when you actually manage to allocate things. Physically
>>> contiguous allocations are exceedingly hard once the machine has been
>>> running for a while.

>> PMM reserves memory during boot time using alloc_bootmem_low_pages().
>> After this is done, it can allocate buffers from reserved pool.
>>
>> The idea here is that there are n hardware accelerators, each
>> can operate on 1MiB blocks (to simplify assume that's the case).
>> However, we know that at most m < n devices will be used at the same
>> time so instead of reserving n MiBs of memory we reserve only m MiBs.

On Thu, 14 May 2009 14:05:02 +0200, Peter Zijlstra wrote:
> And who says your pre-allocated pool won't fragment with repeated PMM
> use?

Yes, this is a good question.  What's more, there's no good answer. ;)

There is no guarantee and it depends on use cases.  The biggest problem
is a lot of small buffers allocated by different applications which get
freed at different times.  However, if in most cases one or two
applications use PMM, we can assume that buffers are allocated and
freed in groups.  If that's the case, fragmentation is less likely to
occur.

I'm not claiming that PMM is panacea for all the problems present on
systems with no scatter-gather capability -- it is an attempt to gather
different functionality and existing solutions in one place which is
easier to manage and improve if needed.

Problem with allocation of continuous blocks hos no universal solution
-- you can increased reserved area but then overall performance of the
system will decrease.  PMM is trying to find a compromise between the
two.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--


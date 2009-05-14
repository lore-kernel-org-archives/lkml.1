Return-Path: <linux-kernel-owner+w=401wt.eu-S1760791AbZENLtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760791AbZENLtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760642AbZENLst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:48:49 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29158 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616AbZENLss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:48:48 -0400
Date: Thu, 14 May 2009 13:48:39 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <1242300002.6642.1091.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utw4fdhz7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2009-05-14 at 11:00 +0200, Michał Nazarewicz wrote:
>>   PMM solves this problem since the buffers are allocated when they
>>   are needed.

On Thu, 14 May 2009 13:20:02 +0200, Peter Zijlstra wrote:
> Ha - only when you actually manage to allocate things. Physically
> contiguous allocations are exceedingly hard once the machine has been
> running for a while.

PMM reserves memory during boot time using alloc_bootmem_low_pages().
After this is done, it can allocate buffers from reserved pool.

The idea here is that there are n hardware accelerators, each
can operate on 1MiB blocks (to simplify assume that's the case).
However, we know that at most m < n devices will be used at the same
time so instead of reserving n MiBs of memory we reserve only m MiBs.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--


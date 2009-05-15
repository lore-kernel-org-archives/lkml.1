Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbZEOKrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbZEOKrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:47:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZEOKr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:47:28 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13600 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758977AbZEOKr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:47:27 -0400
Date: Fri, 15 May 2009 12:47:23 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <20090515101811.GC16682@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utyv89ek7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utu26hq77p4s8u@amdc030>
 <20090513151142.5d166b92.akpm@linux-foundation.org>
 <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
 <op.utw7yhv67p4s8u@amdc030>
 <20090514100718.d8c20b64.akpm@linux-foundation.org>
 <1242321000.6642.1456.camel@laptop> <op.utyudge07p4s8u@amdc030>
 <20090515101811.GC16682@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Correct me if I'm wrong, but if I understand correctly, currently only
>> one size of huge page may be defined, even if underlaying architecture

On Fri, 15 May 2009 12:18:11 +0200, Andi Kleen wrote:
> That's not correct, support for multiple huge page sizes was recently
> added. The interface is a bit clumpsy admittedly, but it's there.

I'll have to look into that further then.  Having said that, I cannot
create a huge page SysV shared memory segment with pages of specified
size, can I?

> However for non fragmentation purposes you probably don't
> want too many different sizes anyways, the more sizes, the worse
> the fragmentation. Ideal is only a single size.

Unfortunately, sizes may very from several KiBs to a few MiBs.
On the other hand, only a handful of apps will use PMM in our system
and at most two or three will be run at the same time so hopefully
fragmentation won't be so bad.  But yes, I admit it is a concern.

>> largest blocks that may ever be requested and then waste a lot of
>> memory when small pages are requested or (ii) define smaller huge
>> page size but then special handling of large regions need to be
>> implemented.
>
> If you don't do that then long term fragmentation will
> kill you anyways. it's easy to show that pre allocation with lots
> of different sizes is about equivalent what the main page allocator
> does anyways.

However, having an allocator in PMM used by a handful of apps, an
architect may provide a use cases that need to be supported and then
PMM may be reimplemented to guarantee that those cases are handled.

> As Peter et.al. explained earlier varying buffer sizes don't work
> anyways.

Either I missed something or Peter and Adrew only pointed the problem
we all seem to agree exists: a problem of fragmentation.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--


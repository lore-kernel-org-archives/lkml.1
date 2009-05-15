Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZEOMFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZEOMFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbZEOMFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:05:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20602 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbZEOMFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:05:21 -0400
Date: Fri, 15 May 2009 14:05:17 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] Physical Memory Management [0/1]
In-reply-to: <20090515112656.GD16682@one.firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Message-id: <op.utyzu3ot7p4s8u@amdc030>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.00 (Win32)
References: <op.utwwmpsf7p4s8u@amdc030> <1242300002.6642.1091.camel@laptop>
 <op.utw4fdhz7p4s8u@amdc030> <1242302702.6642.1140.camel@laptop>
 <op.utw7yhv67p4s8u@amdc030>
 <20090514100718.d8c20b64.akpm@linux-foundation.org>
 <1242321000.6642.1456.camel@laptop> <op.utyudge07p4s8u@amdc030>
 <20090515101811.GC16682@one.firstfloor.org> <op.utyv89ek7p4s8u@amdc030>
 <20090515112656.GD16682@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Fri, 15 May 2009 12:18:11 +0200, Andi Kleen wrote:
>>> However for non fragmentation purposes you probably don't
>>> want too many different sizes anyways, the more sizes, the worse
>>> the fragmentation. Ideal is only a single size.

> On Fri, May 15, 2009 at 12:47:23PM +0200, Michał Nazarewicz wrote:
>> Unfortunately, sizes may very from several KiBs to a few MiBs.

On Fri, 15 May 2009 13:26:56 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> Then your approach will likely not be reliable.

>> On the other hand, only a handful of apps will use PMM in our system
>> and at most two or three will be run at the same time so hopefully
>> fragmentation won't be so bad.  But yes, I admit it is a concern.
>
> Such tight restrictions might work for you, but for mainline Linux the  
> quality standards are higher.

I understand PMM in current form may be unacceptable, however, hear me
out and please do correct me if I'm wrong at any point as I would love
to use an existing solution if any fulfilling my needs is present:

When different sizes of buffers are needed fragmentation is even bigger
problem in hugetlb (as pages must be aligned) then with PMM.

If a buffer that does not match page size is needed then with hugetlb
either bigger page needs to be allocated (and memory wasted) or few
smaller need to be merged (and the same problem as in PMM exists --
finding contiguous pages).

Reclaiming is not really an option since situation where there is no
sane bound time for allocation is not acceptable -- you don't want to
wait 10 seconds for an application to start on your cell phone. ;)

Also, I need an ability to convert any buffer to a Sys V shm, as to
be able to pass it to X server.  Currently no such API exist, does it?

With PMM and it's notion of memory types, different allocators and/or
memory pools, etc.  Allocators could be even dynamically loaded as
modules if one desires that.  My point is, that PMM is to be considered
a framework for situations similar to the one I described thorough all
of my mails, rather then a universal solution.

-- 
Best regards,                                            _     _
 .o. | Liege of Serenly Enlightened Majesty of         o' \,=./ `o
 ..o | Computer Science,  Michał "mina86" Nazarewicz      (o o)
 ooo +-<m.nazarewicz@samsung.com>-<mina86@jabber.org>-ooO--(_)--Ooo--


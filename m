Return-Path: <linux-kernel-owner+w=401wt.eu-S966837AbXEGUxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966837AbXEGUxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966608AbXEGUxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:53:38 -0400
Received: from terminus.zytor.com ([192.83.249.54]:49358 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966560AbXEGUxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:53:37 -0400
Message-ID: <463F91AF.6060005@zytor.com>
Date: Mon, 07 May 2007 13:53:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] deflate inflate_dynamic too
References: <4632AF57.1070102@goop.org> <463F712F.90902@zytor.com> <463F8C22.40902@goop.org>
In-Reply-To: <463F8C22.40902@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> It might be worth reverting some of the code back to the zlib original.
>>  The use of stack allocations here is actually a Linux divergence from
>> zlib (done by Linus), in order to reduce the number of dynamic allocations.
>>
>> In general, the use of dynamic allocations is highly dangerous, because
>> any time you have dynamic allocations you have the choice of either
>> sleeping or failing, unless you have a pre-reserved memory pool.
>>   
> 
> Well, every time this code is instantiated, it gets its own malloc/free
> definitions, so they can decide how to handle the dynamic allocations. 
> Seems better than assuming that every caller will have enough stack
> space.  If you want to approximate that, it would be easy enough to have
> a stack-like malloc/free, in which freeing the last allocation will
> always release space.

Indeed, however, the point still holds:

- Going to something more like the upstream zlib code makes it
worthwhile to see whatever else should be merged;
- Users must be audited for correctness.

In particular, it would be good to have a "preallocate me enough memory
so it can be guaranteed that this will succeed" operation.

	-hpa

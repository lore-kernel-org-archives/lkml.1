Return-Path: <linux-kernel-owner+w=401wt.eu-S1755047AbXJaEoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047AbXJaEoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 00:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbXJaEoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 00:44:10 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:28894 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623AbXJaEoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 00:44:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GGfNNVWzMfAYOZrpsR7unaPGhNIN1r9tnwH1/3BjX5dc95Q86nBq7qLme6RXomLzdHlUDuMGwSTBZ66835vn2gFt9/xy5WuwIIkJYFYRbnAHirQ0VtV4y40oxe7OSCaxHr/bbFvDSLsIr65Ov7+2V7UTlIBg5JtDG1f2mK5ZTXc=  ;
X-YMail-OSG: S4OkT_AVM1ldIVngzff0X7Gdrw6TU7wM1NKZP.123MwpYZW17ZLiZLIz4FpyVgltKz3RgwmhEw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 03/33] mm: slub: add knowledge of reserve pages
Date: Wed, 31 Oct 2007 14:37:28 +1100
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071030160401.296770000@chello.nl> <20071030160910.813944000@chello.nl>
In-Reply-To: <20071030160910.813944000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710311437.28630.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2007 03:04, Peter Zijlstra wrote:
> Restrict objects from reserve slabs (ALLOC_NO_WATERMARKS) to allocation
> contexts that are entitled to it.
>
> Care is taken to only touch the SLUB slow path.
>
> This is done to ensure reserve pages don't leak out and get consumed.

I think this is generally a good idea (to prevent slab allocators
from stealing reserve). However I naively think the implementation
is a bit overengineered and thus has a few holes.

Humour me, what was the problem with failing the slab allocation
(actually, not fail but just call into the page allocator to do
correct waiting  / reclaim) in the slowpath if the process fails the
watermark checks?

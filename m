Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZLBDVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZLBDVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 22:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbZLBDVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 22:21:43 -0500
Received: from mtoichi14.ns.itscom.net ([219.110.2.184]:57624 "EHLO
	mtoichi14.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZLBDVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 22:21:42 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: Q, slab, kmemleak_erase() and redzone? 
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4B1502E3.4000304@cs.helsinki.fi>
References: <15109.1258733696@jrobl> <84144f020911220135l466247c5i9612386fcc30a28c@mail.gmail.com> <6801.1259046382@jrobl> <4B1502E3.4000304@cs.helsinki.fi>
Date: Wed, 02 Dec 2009 12:21:30 +0900
Message-ID: <7595.1259724090@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka Enberg:
> No. The pointer returned by cpu_cache_get() is not changed by 
> cache_alloc_refill(). The contents of the array might change, yes. That 
> said, we should check if objp is NULL before calling kmemleak_erase(). 

To test whether objp is NULL or not is another issue.
'ac' is changed actually. You can confirm it by inserting 
	WARN_ON_ONCE(ac != cpu_cache_get(cachep));
after cache_alloc_refill() in ____cache_alloc().

And do you think these comments/code in cache_alloc_refill() are wrong?
{
	:::
	x = cache_grow(cachep, flags | GFP_THISNODE, node, NULL);

	/* cache_grow can reenable interrupts, then ac could change. */
	ac = cpu_cache_get(cachep);
	:::
}


J. R. Okajima

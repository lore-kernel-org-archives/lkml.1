Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZCAAVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZCAAVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 19:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZCAAVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 19:21:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38529 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZCAAVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 19:21:34 -0500
Date: Sun, 1 Mar 2009 01:40:03 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, arjan@infradead.org, mingo@elte.hu,
       nickpiggin@yahoo.com.au, sqazi@google.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@zytor.com, andi@firstfloor.org
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090301004003.GF26292@one.firstfloor.org>
References: <alpine.LFD.2.00.0902280904271.3111@localhost.localdomain> <20090228092450.3ded2db5@infradead.org> <alpine.LFD.2.00.0902280935010.3111@localhost.localdomain> <20090228.160651.228301019.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228.160651.228301019.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think this is an accurate analysis as well, it's really unfortunate
> the non-temporal stuff on x86 doesn't preserve existing cache lines
> when present.
> 
> I thought that was the whole point.  Don't pollute the caches, but
> if cache lines are already loaded there, use them and don't purge!

x86 actually supports that, it's just not done through movnt.

You can do that on x86 by using PREFETCHNTA (or T0/T1/T2 for specific
cache levels). Typically this is implemented by forcing the cache line 
to only a single way of the cache (so only using max 1/8 or so of your last 
level cache) 

I'm not sure how it interacts with REP MOVS* though, this internally
tends to do additional magic for larger copies.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

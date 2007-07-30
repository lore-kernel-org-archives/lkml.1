Return-Path: <linux-kernel-owner+w=401wt.eu-S935545AbXG3KlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935545AbXG3KlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXG3KlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:41:00 -0400
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:4163 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbXG3Kk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:40:59 -0400
Date: Mon, 30 Jul 2007 11:39:21 +0100 (BST)
From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
To: David Miller <davem@davemloft.net>
cc: aaw@google.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [SPARC32] NULL pointer derefference
In-Reply-To: <20070729.211929.78713482.davem@davemloft.net>
Message-ID: <Pine.LNX.4.61.0707301127050.679@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
 <20070729.211929.78713482.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for the comments.

On Sun, 29 Jul 2007, David Miller wrote:

> From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
> Date: Mon, 30 Jul 2007 03:18:42 +0100 (BST)
>
>> Unfortunatly Sparc32 sun4c low level memory management apears to be
>> incompatible with commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
>> mm: variable length argument support.
>>
>> For some reason, this commit corrupts the memory used by the low level
>> context/pte handling ring buffers in arch/sparc/mm/sun4c (in
>> add_ring_ordered, head->next becomes set to a NULL pointer).
>>
>> I had a quick look at http://www.linux-mm.org to see if there were any
>> diagrams that show what is going on in the memory management systems, to
>> see if there was something that I could use to help me work out what is
>> going on, but I could not see any.
>
> One possible issue is sequencing, perhaps the stack argument copy
> is occuring before the new context is setup properly on sun4c.
>

I will see if I can generate some debug code to check out this posibility.

> Another issue might be the new flush_cache_page() call in this
> new code in fs/exec.c, there are now cases where flush_cache_page()
> will be called on kernel addresses, and sun4c's implementation might
> not like that at all.
>

I backed the commit out of my latest git pull (app 2am this morning) and I 
end up with a working kernel so this confirms that is is somthing 
specific to this patch.

I will try adding in a flush_cache_page() at an appropriate point on the 
pre-commit version of the code to see if that makes a mess of things.

Regards
 	Mark Fortescue.



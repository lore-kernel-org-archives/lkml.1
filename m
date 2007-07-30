Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbXG3ETk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbXG3ETk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 00:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXG3ETa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 00:19:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51120
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751569AbXG3ET3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 00:19:29 -0400
Date: Sun, 29 Jul 2007 21:19:29 -0700 (PDT)
Message-Id: <20070729.211929.78713482.davem@davemloft.net>
To: mark@mtfhpc.demon.co.uk
Cc: aaw@google.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, wli@holomorphy.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [SPARC32] NULL pointer derefference
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
References: <Pine.LNX.4.61.0707300301340.32210@mtfhpc.demon.co.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date: Mon, 30 Jul 2007 03:18:42 +0100 (BST)

> Unfortunatly Sparc32 sun4c low level memory management apears to be 
> incompatible with commit b6a2fea39318e43fee84fa7b0b90d68bed92d2ba
> mm: variable length argument support.
> 
> For some reason, this commit corrupts the memory used by the low level 
> context/pte handling ring buffers in arch/sparc/mm/sun4c (in 
> add_ring_ordered, head->next becomes set to a NULL pointer).
> 
> I had a quick look at http://www.linux-mm.org to see if there were any 
> diagrams that show what is going on in the memory management systems, to 
> see if there was something that I could use to help me work out what is 
> going on, but I could not see any.

One possible issue is sequencing, perhaps the stack argument copy
is occuring before the new context is setup properly on sun4c.

Another issue might be the new flush_cache_page() call in this
new code in fs/exec.c, there are now cases where flush_cache_page()
will be called on kernel addresses, and sun4c's implementation might
not like that at all.

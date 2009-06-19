Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbZFSO70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbZFSO70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 10:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbZFSO7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 10:59:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47631 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZFSO7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 10:59:18 -0400
Date: Fri, 19 Jun 2009 16:59:13 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       npiggin@suse.de, benh@kernel.crashing.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or
	suspending
Message-ID: <20090619145913.GA1389@ucw.cz>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> 
> As explained by Benjamin Herrenschmidt:
> 
>   Oh and btw, your patch alone doesn't fix powerpc, because it's missing
>   a whole bunch of GFP_KERNEL's in the arch code... You would have to
>   grep the entire kernel for things that check slab_is_available() and
>   even then you'll be missing some.
> 
>   For example, slab_is_available() didn't always exist, and so in the
>   early days on powerpc, we used a mem_init_done global that is set form
>   mem_init() (not perfect but works in practice). And we still have code
>   using that to do the test.
> 
> Therefore, ignore __GFP_WAIT in the slab allocators if we're booting or
> suspending.

Ok... GFP_KERNEL allocations normally don't fail; now they
will. Should we at least force access to atomic reserves in such case?
      	     	   	       	      	 		    	 Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbZFLIy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbZFLIy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 04:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZFLIys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 04:54:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:34736 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753193AbZFLIys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 04:54:48 -0400
Subject: Re: slab: setup allocators earlier in the boot sequence
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, mingo@elte.hu, cl@linux-foundation.org,
       akpm@linux-foundation.org, npiggin@suse.de
In-Reply-To: <1244796211.30512.32.camel@penberg-laptop>
References: <200906111959.n5BJxFj9021205@hera.kernel.org>
	 <1244770230.7172.4.camel@pasglop>  <1244779009.7172.52.camel@pasglop>
	 <1244780756.7172.58.camel@pasglop> <1244783235.7172.61.camel@pasglop>
	 <Pine.LNX.4.64.0906120913460.26843@melkki.cs.Helsinki.FI>
	 <1244792079.7172.74.camel@pasglop>
	 <1244792745.30512.13.camel@penberg-laptop>
	 <1244796045.7172.82.camel@pasglop>
	 <1244796211.30512.32.camel@penberg-laptop>
Content-Type: text/plain
Date: Fri, 12 Jun 2009 18:53:57 +1000
Message-Id: <1244796837.7172.95.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Yes, you're obviously right. I overlooked the fact that arch code have
> their own special slab_is_available() heuristics (yikes!).
> 
> But are you happy with the two patches I posted so I can push them to
> Linus?

I won't be able to test them until tomorrow. However, I think the first
one becomes unnecessary with the second one applied (provided you didn't
miss a case), no ?

I still prefer my approach of having a more fine grained control of what
bits to remove. First because applying a mask is less expensive than a
conditional branch (I used a negative mask because it would be too easy
to miss bits otherwise) and second, because it allows for masking of
other bits easily, for example, __GFP_IO for the suspend path etc...

Now, if you find it a bit too ugly, feel free to rename smellybits to
something else and create an accessor function for setting what bits are
masked out, but I still believe that the basic idea behind my patch is
saner than yours :-)

Cheers,
Ben.


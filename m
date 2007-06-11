Return-Path: <linux-kernel-owner+w=401wt.eu-S1763585AbXFKACi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763585AbXFKACi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 20:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761073AbXFKACb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 20:02:31 -0400
Received: from ozlabs.org ([203.10.76.45]:58336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbXFKACa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 20:02:30 -0400
Subject: Re: [PATCH RFC] struct list_node
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
References: <1181452290.16428.7.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 10:02:17 +1000
Message-Id: <1181520137.16428.69.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-10 at 10:20 -0700, Linus Torvalds wrote:
> 
> On Sun, 10 Jun 2007, Rusty Russell wrote:
> >
> > The current list.h has the same type for list elements and list heads
> > even though most code and coders treat them as distinct.
> 
> I think the old list.h is technically superior to yours.
> 
> Exactly *because* nodes and heads are interchangeable.
> 
> In fact, you are incorrect that "most code" treat them as distinct. Most 
> code that uses list.h in fact uses it as a list of entries, often without 
> any head at all (and each *entry* is a point of removal), because the way 
> to actually *find* the structure that contains the lists is separate from 
> the lists themselves.

Sorry, do you really believe a ring is "often" the case?  It's not
entirely trivial to audit, but I can do a random sample of 100
list_heads.

The list iterators reinforce the "standalone head" model (ie. it's not
called list_for_each_other_entry), and they're pretty popular.

> The Linux kernel list.h is _better_ than most stupid list implementations 
> that think that a head node is different from the list node. Exactly 
> because it very naturally supports the notion of "this structure exists in 
> a 'ring of entries'" where each node is 100% equivalent to any other node, 
> and there _is_ no head.

I agree it's a wonderful feature, but you talk about "no head" but
they're all called "list_head"?  In my version, they'd all be list_node,
and you can trivially treat it as a head with ->h.

It's a little more work for rings, but it's more explicit and gives us
type checking on the common case.

Thanks for your consideration,
Rusty.


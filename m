Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbXFJRUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbXFJRUl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXFJRUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:20:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbXFJRUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:20:33 -0400
Date: Sun, 10 Jun 2007 10:20:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] struct list_node
In-Reply-To: <1181452290.16428.7.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
References: <1181452290.16428.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Rusty Russell wrote:
>
> The current list.h has the same type for list elements and list heads
> even though most code and coders treat them as distinct.

I think the old list.h is technically superior to yours.

Exactly *because* nodes and heads are interchangeable.

In fact, you are incorrect that "most code" treat them as distinct. Most 
code that uses list.h in fact uses it as a list of entries, often without 
any head at all (and each *entry* is a point of removal), because the way 
to actually *find* the structure that contains the lists is separate from 
the lists themselves.

In other words, I think your patch is HORRIBLY BAD, because it totally 
obscures the beauty of the current list.h implementation, and makes it be 
something *average*.

The Linux kernel list.h is _better_ than most stupid list implementations 
that think that a head node is different from the list node. Exactly 
because it very naturally supports the notion of "this structure exists in 
a 'ring of entries'" where each node is 100% equivalent to any other node, 
and there _is_ no head.

And your patch totally misunderstands that, and breaks it.

Nack.

		Linus

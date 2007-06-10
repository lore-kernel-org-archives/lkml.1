Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbXFJUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbXFJUT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 16:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXFJUTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 16:19:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbXFJUTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 16:19:47 -0400
Date: Sun, 10 Jun 2007 13:19:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] struct list_node
In-Reply-To: <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.98.0706101317090.14121@woody.linux-foundation.org>
References: <1181452290.16428.7.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706101013420.20321@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Jun 2007, Linus Torvalds wrote:
> 
> The Linux kernel list.h is _better_ than most stupid list implementations 
> that think that a head node is different from the list node. Exactly 
> because it very naturally supports the notion of "this structure exists in 
> a 'ring of entries'" where each node is 100% equivalent to any other node, 
> and there _is_ no head.

Btw, to extend a bit on this: there actually *is* a "list with a head" 
implementation in <linux/list.h>, called "hlist".

Now, the "h" actually historically stands for "hash", but if you prefer, 
you can think of it as standing for "head", and be happy.

And if you want a head, you really do want to use "hlist", since the head 
is smaller than a list entry (a single pointer rather than two).

And yes, I'm sure we could change some "struct list" users to "struct 
hlist" if you wanted to.

		Linus

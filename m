Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbYETPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbYETPOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933030AbYETPN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:13:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932977AbYETPNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:13:55 -0400
Date: Tue, 20 May 2008 08:12:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Dave Jones <davej@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make
In-Reply-To: <b6fcc0a0805200800k10264445n59bb56d24b80cd2f@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805200806340.32253@woody.linux-foundation.org>
References: <20080502182745.GL14976@parisc-linux.org>  <20080501133209.2c04dad0@infradead.org>  <20080502184922.GM14976@parisc-linux.org>  <20080520032448.GA19348@redhat.com>  <20080520071458.707d6e90@infradead.org>  <20080520142727.GC4843@redhat.com>
 <b6fcc0a0805200800k10264445n59bb56d24b80cd2f@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Alexey Dobriyan wrote:
> 
> Why list_head corruptions are special?

It's not that list corruptions are special, but:
 - *any* corruption is very interesting, and the earlier we find it the 
   better
 - we have a lot of lists in the kernel, so testing pointers is actually 
   likely to find stuff.
 - and lists are something we can *test* for corruption

That third one is important. Most random pointers we can't sanely test 
because they don't have trivial and important patterns.

The second one is relevant too: some of the pointers that we *could* test 
(struct task has a pointer to the thread struct and back, and we could 
test that) are just not common enough to be worth testing. And other 
concepts don't have any nice centralized routines for adding the test.

So no, lists aren't "special" in any inherent way, they are just special 
in these kinds of "incidentally, a lot of random data structure corruption 
has traditionally shown up in lists, because there are so many of them".

			Linus

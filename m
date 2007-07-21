Return-Path: <linux-kernel-owner+w=401wt.eu-S936637AbXGUBhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936637AbXGUBhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 21:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760196AbXGUBhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 21:37:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37060 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758142AbXGUBhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 21:37:14 -0400
Date: Fri, 20 Jul 2007 18:37:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
In-Reply-To: <46A04129.1020900@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com>
 <20070717175017.8b8a8976.akpm@linux-foundation.org> <469DABA5.9070706@yahoo.com.au>
 <20070719204102.7b82692d.akpm@linux-foundation.org>
 <46A04129.1020900@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 20 Jul 2007, Nick Piggin wrote:
> 
> So you did. Then to answer that, yes it could be faster because there are
> stupid volatiles sprinkled all over the bitops code so you could easily
> end up having to do more loads. Does it make a real difference? Unlikely,
> but David loves counting cycles :)

I thought we long long since removed the volatiles. They are buggy and 
horrible, and we really want to let the compiler combine multiple 
test-bits, and if they matter that implies locking is buggy or something 
worse..

Ie we'd *want*

	if (test_bit(x, y) || test_bit(z,y))

to be rewritten by the compiler as testing bits x/z at the same time.

But now I'm too scared to look.

		Linus

Return-Path: <linux-kernel-owner+w=401wt.eu-S1763463AbXGWHH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763463AbXGWHH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbXGWHHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 03:07:18 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:46473 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750897AbXGWHHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 03:07:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=M1l6TrFrD8EDOZDUS4DMU8mugmLaxKHUcKDmkt1hGNurgNt5eCpq6GZ9RlFyNdK/ndq3G0DBMBBfp7uCiEu0wY4M9ukEvu7XcAmsciJ60IqjrKGVPorYwGG7J2uXqKXyHrnfD6f1cJT0nnGHTmeVUe/3b/v0/W86IPywNO14460=  ;
X-YMail-OSG: 6WKjXFcVM1l57bHa.sshARCkOi8iLuzEzwY8TuO4brfK78_s1HDvy9G33x5nxfWb7ztCScFL2A--
Message-ID: <46A4539D.9060100@yahoo.com.au>
Date: Mon, 23 Jul 2007 17:07:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
References: <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com> <20070717175017.8b8a8976.akpm@linux-foundation.org> <469DABA5.9070706@yahoo.com.au> <20070719204102.7b82692d.akpm@linux-foundation.org> <46A04129.1020900@yahoo.com.au> <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 20 Jul 2007, Nick Piggin wrote:
> 
>>So you did. Then to answer that, yes it could be faster because there are
>>stupid volatiles sprinkled all over the bitops code so you could easily
>>end up having to do more loads. Does it make a real difference? Unlikely,
>>but David loves counting cycles :)
> 
> 
> I thought we long long since removed the volatiles. They are buggy and 
> horrible, and we really want to let the compiler combine multiple 
> test-bits, and if they matter that implies locking is buggy or something 
> worse..
> 
> Ie we'd *want*
> 
> 	if (test_bit(x, y) || test_bit(z,y))
> 
> to be rewritten by the compiler as testing bits x/z at the same time.

Yep. We'd also want __set_bit(x, y); __set_bit(z, y); and such to be
combined.
> 
> But now I'm too scared to look.

Not a chance :) Even the asm-generic "reference" implementation ratifies
the volatile crapiness. Would you take a patch?

-- 
SUSE Labs, Novell Inc.

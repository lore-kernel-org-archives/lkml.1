Return-Path: <linux-kernel-owner+w=401wt.eu-S1751648AbXC3PNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbXC3PNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 11:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXC3PNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 11:13:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbXC3PNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 11:13:44 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com> 
References: <6d6a94c50703300738i7b9d3fcn341feb08dca8817d@mail.gmail.com>  <1175226172.15391.66.camel@roc-desktop> <10785.1175247540@redhat.com> <6d6a94c50703300334w6b4787f3p144715de5166d7bc@mail.gmail.com> <15938.1175253862@redhat.com> <6d6a94c50703300644y28e51f47h19182f550c18c40d@mail.gmail.com> <20070330155635.6a6c55d2@the-village.bc.nu> 
To: "Aubrey Li" <aubreylee@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, vapier.adi@gmail.com,
       jie.zhang@analog.com, bryan.wu@analog.com,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu arch dont zero the anonymous mapping by adding UNINITIALIZE flag 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 30 Mar 2007 16:11:17 +0100
Message-ID: <12871.1175267477@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li <aubreylee@gmail.com> wrote:

> Summary is, when I run the app "time test",
> 
> on x86:
> real    0m0.066s
> user    0m0.008s
> sys     0m0.058s
> 
> on Blackfin:
> real    3m 37.69s
> user    0m 0.04s
> sys     3m 37.58s

That's not a good comparison: you're comparing two different machines of two
different archs.

> Keep the same behave as MMU but with bad performance, or keep the same
> performance as MMU but without the same behave, Which one is more
> important?

The thing to do is to pass a flag to mmap() to suppress the memset (as
suggested).  This can then be used by the uClibc malloc() implementation and
does not impact any application that does an anon mmap() expecting the memory
returned to be zeroed.

David

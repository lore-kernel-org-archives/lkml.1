Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYIEL6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYIEL6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYIEL6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:58:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33356 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbYIEL6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:58:12 -0400
Date: Fri, 5 Sep 2008 14:01:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, pageexec@freemail.hu,
       Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905120127.GT18288@one.firstfloor.org>
References: <20080903195122.73905236@infradead.org> <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu> <1220609647.4879.169.camel@pasglop> <48C10EC5.24400.3008276@pageexec.freemail.hu> <1220612231.4879.175.camel@pasglop> <20080905114233.GA27878@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905114233.GA27878@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First as a minor pedantic correction (sorry!): the ro syscall table is not 
fully free.  It means you cannot use 2MB pages anymore to map it, which costs
you in TLB misses.

> [ It would be nice to have a 'randomize instruction scheduling' option 
>   for gcc, to make automated attacks that recognize specific instruction 
>   patterns less reliable. ]

One way to do that today is to feed gcc random data for profile feedback.
But your performance will probably suffer.

> experienced kernel developer could reliably tell it via a kgdb session 
> and full access to memory and system symbols that such a silent alarm is 
> running on a box. If he cannot do it reliably then there's probably no 
> good way for an attacker either.

Game copy protections have been playing similar games for decades. While
I'm sure it was endless fun for both sides afaik the crackers tended to 
ultimatively win. And all of these things also make the kernel more 
fragile which is not good. Likely a case of "the only way to win is not to play"

I liked Alan's proposal of using hypervisor support for truly ro pages,  
although even that is not fully hole proof because of indirect pointers. 
But at least it would make it generally harder to inject code.

-Andi

-- 
ak@linux.intel.com

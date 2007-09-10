Return-Path: <linux-kernel-owner+w=401wt.eu-S965562AbXIJT7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbXIJT7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbXIJT70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:59:26 -0400
Received: from smtpoutm.mac.com ([17.148.16.73]:54750 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbXIJT7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:59:25 -0400
In-Reply-To: <200709101746.34513.vda.linux@googlemail.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <200709101516.03234.vda.linux@googlemail.com> <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org> <200709101746.34513.vda.linux@googlemail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F5A2B8BD-CD28-44EE-9DB5-5E776279100F@mac.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Mon, 10 Sep 2007 15:59:06 -0400
To: Denys Vlasenko <vda.linux@googlemail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 10, 2007, at 12:46:33, Denys Vlasenko wrote:
> My point is that people are confused as to what atomic_read()   
> exactly means, and this is bad. Same for cpu_relax().  First one  
> says "read", and second one doesn't say "barrier".

Q&A:

Q:  When is it OK to use atomic_read()?
A:  You are asking the question, so never.

Q:  But I need to check the value of the atomic at this point in time...
A:  Your code is buggy if it needs to do that on an atomic_t for  
anything other than debugging or optimization.  Use either  
atomic_*_return() or a lock and some normal integers.

Q:  "So why can't the atomic_read DTRT magically?"
A:  Because "the right thing" depends on the situation and is usually  
best done with something other than atomic_t.

If somebody can post some non-buggy code which is correctly using  
atomic_read() *and* depends on the compiler generating extra  
nonsensical loads due to "volatile" then the issue *might* be  
reconsidered.  This also includes samples of code which uses  
atomic_read() and needs memory barriers (so that we can fix the buggy  
code, not so we can change atomic_read()).  So far the only code  
samples anybody has posted are buggy regardless of whether or not the  
value and/or accessors are flagged "volatile" or not.  And hey, maybe  
the volatile ops *should* be implemented in inline ASM for future- 
proof-ness, but that's a separate issue.

Cheers,
Kyle Moffett


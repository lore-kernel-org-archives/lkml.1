Return-Path: <linux-kernel-owner+w=401wt.eu-S1759847AbXHUOBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759847AbXHUOBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXHUOA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:00:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754113AbXHUOAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:00:54 -0400
Message-ID: <46CAED8B.9030006@redhat.com>
Date: Tue, 21 Aug 2007 09:50:03 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: torvalds@linux-foundation.org, piggin@cyberone.com.au,
       satyam@infradead.org, herbert@gondor.apana.org.au, paulus@samba.org,
       clameter@sgi.com, ilpo.jarvinen@helsinki.fi, paulmck@linux.vnet.ibm.com,
       stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org>	<46C993DF.4080400@redhat.com>	<alpine.LFD.0.999.0708202244520.30176@woody.linux-foundation.org> <20070821.000404.39159401.davem@davemloft.net>
In-Reply-To: <20070821.000404.39159401.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 20 Aug 2007 22:46:47 -0700 (PDT)
> 
>> Ie a "barrier()" is likely _cheaper_ than the code generation downside 
>> from using "volatile".
> 
> Assuming GCC were ever better about the code generation badness
> with volatile that has been discussed here, I much prefer
> we tell GCC "this memory piece changed" rather than "every
> piece of memory has changed" which is what the barrier() does.
> 
> I happened to have been scanning a lot of assembler lately to
> track down a gcc-4.2 miscompilation on sparc64, and the barriers
> do hurt quite a bit in some places.  Instead of keeping unrelated
> variables around cached in local registers, it reloads everything.

Moore's law is definitely working against us here.  Register counts, 
pipeline depths, core counts, and clock multipliers are all increasing 
in the long run.  At some point in the future, barrier() will be 
universally regarded as a hammer too big for most purposes.  Whether or 
not removing it now constitutes premature optimization is arguable, but 
I think we should allow such optimization to happen (or not happen) in 
architecture-dependent code, and provide a consistent API that doesn't 
require the use of such things in arch-independent code where it might 
turn into a totally superfluous performance killer depending on what 
hardware it gets compiled for.

	-- Chris

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761173AbXHUHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761173AbXHUHEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 03:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbXHUHEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 03:04:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54586
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756041AbXHUHEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 03:04:06 -0400
Date: Tue, 21 Aug 2007 00:04:04 -0700 (PDT)
Message-Id: <20070821.000404.39159401.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: csnook@redhat.com, piggin@cyberone.com.au, satyam@infradead.org,
       herbert@gondor.apana.org.au, paulus@samba.org, clameter@sgi.com,
       ilpo.jarvinen@helsinki.fi, paulmck@linux.vnet.ibm.com,
       stefanr@s5r6.in-berlin.de, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.0.999.0708202244520.30176@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0708170929580.30176@woody.linux-foundation.org>
	<46C993DF.4080400@redhat.com>
	<alpine.LFD.0.999.0708202244520.30176@woody.linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Aug 2007 22:46:47 -0700 (PDT)

> Ie a "barrier()" is likely _cheaper_ than the code generation downside 
> from using "volatile".

Assuming GCC were ever better about the code generation badness
with volatile that has been discussed here, I much prefer
we tell GCC "this memory piece changed" rather than "every
piece of memory has changed" which is what the barrier() does.

I happened to have been scanning a lot of assembler lately to
track down a gcc-4.2 miscompilation on sparc64, and the barriers
do hurt quite a bit in some places.  Instead of keeping unrelated
variables around cached in local registers, it reloads everything.

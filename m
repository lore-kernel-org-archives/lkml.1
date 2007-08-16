Return-Path: <linux-kernel-owner+w=401wt.eu-S936971AbXHPBwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936971AbXHPBwD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757609AbXHPBvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:51:50 -0400
Received: from ozlabs.org ([203.10.76.45]:45444 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbXHPBvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:51:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18115.44462.622801.683446@cargo.ozlabs.ibm.com>
Date: Thu, 16 Aug 2007 11:51:42 +1000
From: Paul Mackerras <paulus@samba.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Satyam Sharma <satyam@infradead.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
	<Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
	<alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
	<46C2D6F3.3070707@s5r6.in-berlin.de>
	<alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
	<18115.35524.56393.347841@cargo.ozlabs.ibm.com>
	<Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
	<20070816003948.GY9645@linux.vnet.ibm.com>
	<Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter writes:

> A volatile default would disable optimizations for atomic_read. 
> atomic_read without volatile would allow for full optimization by the 
> compiler. Seems that this is what one wants in many cases.

Name one such case.

An atomic_read should do a load from memory.  If the programmer puts
an atomic_read() in the code then the compiler should emit a load for
it, not re-use a value returned by a previous atomic_read.  I do not
believe it would ever be useful for the compiler to collapse two
atomic_read statements into a single load.

Paul.

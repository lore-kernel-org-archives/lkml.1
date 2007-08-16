Return-Path: <linux-kernel-owner+w=401wt.eu-S1765312AbXHPA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765312AbXHPA06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXHPA0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:26:40 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55184 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751980AbXHPA0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:26:38 -0400
Date: Wed, 15 Aug 2007 17:26:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Satyam Sharma <satyam@infradead.org>,
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
       Herbert Xu <herbert@gondor.apana.org.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Paul Mackerras wrote:

> In the kernel we use atomic variables in precisely those situations
> where a variable is potentially accessed concurrently by multiple
> CPUs, and where each CPU needs to see updates done by other CPUs in a
> timely fashion.  That is what they are for.  Therefore the compiler
> must not cache values of atomic variables in registers; each
> atomic_read must result in a load and each atomic_set must result in a
> store.  Anything else will just lead to subtle bugs.

This may have been the intend. However, today the visibility is controlled 
using barriers. And we have barriers that we use with atomic operations. 
Having volatile be the default just lead to confusion. Atomic read should 
just read with no extras. Extras can be added by using variants like 
atomic_read_volatile or so.


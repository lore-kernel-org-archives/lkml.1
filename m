Return-Path: <linux-kernel-owner+w=401wt.eu-S937508AbXHPA77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937508AbXHPA77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764048AbXHPA7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:59:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56662 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755757AbXHPA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:59:45 -0400
Date: Wed, 15 Aug 2007 17:59:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Paul Mackerras <paulus@samba.org>, Satyam Sharma <satyam@infradead.org>,
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
In-Reply-To: <20070816005348.GA9645@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0708151757400.11196@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
 <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
 <20070816005348.GA9645@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Paul E. McKenney wrote:

> The volatile cast should not disable all that many optimizations,
> for example, it is much less hurtful than barrier().  Furthermore,
> the main optimizations disabled (pulling atomic_read() and atomic_set()
> out of loops) really do need to be disabled.

In many cases you do not need a barrier. Having volatile there *will* 
impact optimization because the compiler cannot use a register that may 
contain the value that was fetched earlier. And the compiler cannot choose 
freely when to fetch the value. The order of memory accesses are fixed if 
you use volatile. If the variable is not volatile then the compiler can 
arrange memory accesses any way they fit and thus generate better code.


Return-Path: <linux-kernel-owner+w=401wt.eu-S937557AbXHPCRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937557AbXHPCRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760390AbXHPCRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:17:17 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759961AbXHPCRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:17:13 -0400
Date: Wed, 15 Aug 2007 19:17:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <Pine.LNX.4.64.0708151915390.11706@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0708151916310.11706@schroedinger.engr.sgi.com>
References: <20070809131423.GA9927@shell.boston.redhat.com>
 <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
 <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
 <18115.44462.622801.683446@cargo.ozlabs.ibm.com> <20070816020042.GA30650@gondor.apana.org.au>
 <18115.45316.702491.681906@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151915390.11706@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Christoph Lameter wrote:

> On Thu, 16 Aug 2007, Paul Mackerras wrote:
> 
> > > We don't need to reload sk->sk_prot->memory_allocated here.
> > 
> > Are you sure?  How do you know some other CPU hasn't changed the value
> > in between?
> 
> The cpu knows because the cacheline was not invalidated.

Crap my statement above is wrong..... We do not care that the 
value was changed otherwise we would have put a barrier in there.


Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXHPBmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXHPBmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761779AbXHPBlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:41:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58651 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760168AbXHPBlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:41:42 -0400
Date: Wed, 15 Aug 2007 18:41:40 -0700 (PDT)
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
In-Reply-To: <20070816011414.GC9645@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in>
 <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in>
 <18115.35524.56393.347841@cargo.ozlabs.ibm.com>
 <Pine.LNX.4.64.0708151725130.10497@schroedinger.engr.sgi.com>
 <20070816003948.GY9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151740570.10497@schroedinger.engr.sgi.com>
 <20070816005348.GA9645@linux.vnet.ibm.com> <Pine.LNX.4.64.0708151757400.11196@schroedinger.engr.sgi.com>
 <20070816011414.GC9645@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Aug 2007, Paul E. McKenney wrote:

> Understood.  My point is not that the impact is precisely zero, but
> rather that the impact on optimization is much less hurtful than the
> problems that could arise otherwise, particularly as compilers become
> more aggressive in their optimizations.

The problems arise because barriers are not used as required. Volatile 
has wishy washy semantics and somehow marries memory barriers with data 
access. It is clearer to separate the two. Conceptual cleanness usually 
translates into better code. If one really wants the volatile then lets 
make it explicit and use

	atomic_read_volatile()

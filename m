Return-Path: <linux-kernel-owner+w=401wt.eu-S932615AbXHPSua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615AbXHPSua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 14:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXHPSuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 14:50:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60179 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755435AbXHPSuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 14:50:03 -0400
Date: Thu, 16 Aug 2007 11:50:01 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Satyam Sharma <satyam@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
In-Reply-To: <18115.59365.268987.406001@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0708161149120.17049@schroedinger.engr.sgi.com>
References: <20070816011414.GC9645@linux.vnet.ibm.com>
 <Pine.LNX.4.64.0708151839140.11520@schroedinger.engr.sgi.com>
 <alpine.LFD.0.999.0708160730590.24380@enigma.security.iitk.ac.in>
 <20070816020851.GA30809@gondor.apana.org.au>
 <Pine.LNX.4.64.0708151917210.11736@schroedinger.engr.sgi.com>
 <18115.49946.522011.832468@cargo.ozlabs.ibm.com> <20070816033343.GA31844@gondor.apana.org.au>
 <18115.51472.408193.332905@cargo.ozlabs.ibm.com> <20070816040308.GA32133@gondor.apana.org.au>
 <18115.54225.644905.463771@cargo.ozlabs.ibm.com> <20070816053741.GA32442@gondor.apana.org.au>
 <18115.59365.268987.406001@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2007, Paul Mackerras wrote:

> Herbert Xu writes:
> 
> > It doesn't matter.  The memory pressure flag is an *advisory*
> > flag.  If we get it wrong the worst that'll happen is that we'd
> > waste some time doing work that'll be thrown away.
> 
> Ah, so it's the "racy but I don't care because it's only an
> optimization" case.  That's fine.  Somehow I find it hard to believe
> that all the racy uses of atomic_read in the kernel are like that,
> though. :)

My use of atomic_read in SLUB is like that. Volatile does not magically 
sync up reads somehow.


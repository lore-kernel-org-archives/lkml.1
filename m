Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbXHKEaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbXHKEaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 00:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbXHKE35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 00:29:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54698 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbXHKE3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 00:29:55 -0400
Date: Fri, 10 Aug 2007 21:29:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chris Snook <csnook@redhat.com>, dhowells@redhat.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
Message-ID: <20070811042943.GA13410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46BCC26B.6080600@redhat.com> <E1IJfFe-0003Sq-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IJfFe-0003Sq-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2007 at 08:54:46AM +0800, Herbert Xu wrote:
> Chris Snook <csnook@redhat.com> wrote:
> > 
> > cpu_relax() contains a barrier, so it should do the right thing.  For 
> > non-smp architectures, I'm concerned about interacting with interrupt 
> > handlers.  Some drivers do use atomic_* operations.
> 
> What problems with interrupt handlers? Access to int/long must
> be atomic or we're in big trouble anyway.

Reordering due to compiler optimizations.  CPU reordering does not
affect interactions with interrupt handlers on a given CPU, but
reordering due to compiler code-movement optimization does.  Since
volatile can in some cases suppress code-movement optimizations,
it can affect interactions with interrupt handlers.

						Thanx, Paul

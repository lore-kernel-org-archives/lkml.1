Return-Path: <linux-kernel-owner+w=401wt.eu-S937393AbXHMGDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937393AbXHMGDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbXHMGDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:03:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42823 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbXHMGDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:03:08 -0400
Date: Sun, 12 Aug 2007 23:03:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: csnook@redhat.com, dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
Message-ID: <20070813060302.GF13410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070811042943.GA13410@linux.vnet.ibm.com> <E1IKSHQ-0007hg-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IKSHQ-0007hg-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 01:15:52PM +0800, Herbert Xu wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Sat, Aug 11, 2007 at 08:54:46AM +0800, Herbert Xu wrote:
> >> Chris Snook <csnook@redhat.com> wrote:
> >> > 
> >> > cpu_relax() contains a barrier, so it should do the right thing.  For 
> >> > non-smp architectures, I'm concerned about interacting with interrupt 
> >> > handlers.  Some drivers do use atomic_* operations.
> >> 
> >> What problems with interrupt handlers? Access to int/long must
> >> be atomic or we're in big trouble anyway.
> > 
> > Reordering due to compiler optimizations.  CPU reordering does not
> > affect interactions with interrupt handlers on a given CPU, but
> > reordering due to compiler code-movement optimization does.  Since
> > volatile can in some cases suppress code-movement optimizations,
> > it can affect interactions with interrupt handlers.
> 
> If such reordering matters, then you should use one of the
> *mb macros or barrier() rather than relying on possibly
> hidden volatile cast.

If communicating among CPUs, sure.  However, when communicating between
mainline and interrupt/NMI handlers on the same CPU, the barrier() and
most expecially the *mb() macros are gross overkill.  So there really
truly is a place for volatile -- not a large place, to be sure, but a
place nonetheless.

						Thanx, Paul

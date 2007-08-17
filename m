Return-Path: <linux-kernel-owner+w=401wt.eu-S1764505AbXHQIqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764505AbXHQIqt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 04:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762596AbXHQIqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 04:46:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42299 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760255AbXHQIqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 04:46:32 -0400
Date: Fri, 17 Aug 2007 14:28:42 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, paulmck@linux.vnet.ibm.com,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
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
In-Reply-To: <46C556F1.8000407@yahoo.com.au>
Message-ID: <alpine.LFD.0.999.0708171420060.3666@enigma.security.iitk.ac.in>
References: <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in>
 <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au>
 <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au>
 <46C40587.7050708@s5r6.in-berlin.de> <20070816081049.GA1431@gondor.apana.org.au>
 <46C41EE4.9090806@s5r6.in-berlin.de> <46C42767.4070104@s5r6.in-berlin.de>
 <20070816104250.GB2927@gondor.apana.org.au> <20070816163441.GB16957@linux.vnet.ibm.com>
 <46C512EB.7020603@yahoo.com.au> <46C54D74.60101@s5r6.in-berlin.de>
 <46C556F1.8000407@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Nick Piggin wrote:

> Stefan Richter wrote:
> [...]
> Just use spinlocks if you're not absolutely clear about potential
> races and memory ordering issues -- they're pretty cheap and simple.

I fully agree with this. As Paul Mackerras mentioned elsewhere,
a lot of authors sprinkle atomic_t in code thinking they're somehow
done with *locking*. This is sad, and I wonder if it's time for a
Documentation/atomic-considered-dodgy.txt kind of document :-)


> > Sure, now
> > that I learned of these properties I can start to audit code and insert
> > barriers where I believe they are needed, but this simply means that
> > almost all occurrences of atomic_read will get barriers (unless there
> > already are implicit but more or less obvious barriers like msleep).
> 
> You might find that these places that appear to need barriers are
> buggy for other reasons anyway. Can you point to some in-tree code
> we can have a look at?

Such code was mentioned elsewhere (query nodemgr_host_thread in cscope)
that managed to escape the requirement for a barrier only because of
some completely un-obvious compilation-unit-scope thing. But I find such
an non-explicit barrier quite bad taste. Stefan, do consider plunking an
explicit call to barrier() there.


Satyam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760769AbXHXMHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760769AbXHXMHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbXHXMHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:07:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986AbXHXMHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:07:33 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()
Date: Fri, 24 Aug 2007 14:07:25 +0200
User-Agent: KMail/1.9.6
Cc: Satyam Sharma <satyam@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Chris Snook <csnook@redhat.com>, clameter@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <46C2350A.1010807@redhat.com> <alpine.LFD.0.999.0708160606580.24380@enigma.security.iitk.ac.in> <200708241259.33659.vda.linux@googlemail.com>
In-Reply-To: <200708241259.33659.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241407.26180.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 13:59:32 Denys Vlasenko wrote:
> On Thursday 16 August 2007 01:39, Satyam Sharma wrote:
> >
> >  static inline void wait_for_init_deassert(atomic_t *deassert)
> >  {
> > -	while (!atomic_read(deassert));
> > +	while (!atomic_read(deassert))
> > +		cpu_relax();
> >  	return;
> >  }
> 
> For less-than-briliant people like me, it's totally non-obvious that
> cpu_relax() is needed for correctness here, not just to make P4 happy.

I find it also non obvious. It would be really better to have a barrier
or equivalent (volatile or variable clobber) in the atomic_read()
 
> IOW: "atomic_read" name quite unambiguously means "I will read
> this variable from main memory". Which is not true and creates
> potential for confusion and bugs.

Agreed.

-Andi

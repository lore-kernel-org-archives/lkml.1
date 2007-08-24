Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbXHXMAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbXHXMAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 08:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754702AbXHXMAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 08:00:15 -0400
Received: from hu-out-0506.google.com ([72.14.214.232]:32083 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbXHXMAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 08:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ClY8+lu2ywahmG2Q0JwJaxcNRNJ9otNhqSvl/vveXLgaQf6q8Y3wCcQgNrUSl19SDEjp5Zcquz7QF1jRUCT8sVcjRRGhB7vXjKeIAdlZAG2V6KdsW3LmATQ8LB/gNxjm3O1kDf2lUTagnVRl9JH3luwGHu+ZoHpOK0/Tb0rfzrQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Satyam Sharma <satyam@infradead.org>
Subject: Re: [PATCH] i386: Fix a couple busy loops in mach_wakecpu.h:wait_for_init_deassert()
Date: Fri, 24 Aug 2007 12:59:32 +0100
User-Agent: KMail/1.9.1
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Chris Snook <csnook@redhat.com>, clameter@sgi.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <46C2350A.1010807@redhat.com> <20070815081841.GA16551@osiris.boeblingen.de.ibm.com> <alpine.LFD.0.999.0708160606580.24380@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708160606580.24380@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708241259.33659.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 August 2007 01:39, Satyam Sharma wrote:
>
>  static inline void wait_for_init_deassert(atomic_t *deassert)
>  {
> -	while (!atomic_read(deassert));
> +	while (!atomic_read(deassert))
> +		cpu_relax();
>  	return;
>  }

For less-than-briliant people like me, it's totally non-obvious that
cpu_relax() is needed for correctness here, not just to make P4 happy.

IOW: "atomic_read" name quite unambiguously means "I will read
this variable from main memory". Which is not true and creates
potential for confusion and bugs.
--
vda

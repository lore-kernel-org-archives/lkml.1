Return-Path: <linux-kernel-owner+w=401wt.eu-S1763653AbXHPUwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763653AbXHPUwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 16:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbXHPUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 16:52:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:45386 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbXHPUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 16:52:22 -0400
In-Reply-To: <alpine.LFD.0.999.0708161045360.25951@enigma.security.iitk.ac.in>
References: <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de> <alpine.LFD.0.999.0708151713080.16414@enigma.security.iitk.ac.in> <20070815233721.91032366.billfink@mindspring.com> <alpine.LFD.0.999.0708161045360.25951@enigma.security.iitk.ac.in>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <4952d3f536060c186f40c277dfc74194@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Christoph Lameter <clameter@sgi.com>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bill Fink <billfink@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, netdev@vger.kernel.org,
       ak@suse.de, cfriesen@nortel.com, rpjday@mindspring.com,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, zlynx@acm.org,
       schwidefsky@de.ibm.com, Chris Snook <csnook@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
       Linus Torvalds <torvalds@linux-foundation.org>, wensong@linux-vs.org,
       wjiang@resilience.com
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Thu, 16 Aug 2007 22:50:38 +0200
To: Satyam Sharma <satyam@infradead.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that "volatile"
> is a type-qualifier, not a type itself, so a cast of the _object_ 
> itself
> to a qualified-type i.e. (volatile int) would not make the access 
> itself
> volatile-qualified.

There is no such thing as "volatile-qualified access" defined
anywhere; there only is the concept of a "volatile-qualified
*object*".

> To serve our purposes, it is necessary for us to take the address of 
> this
> (non-volatile) object, cast the resulting _pointer_ to the 
> corresponding
> volatile-qualified pointer-type, and then dereference it. This makes 
> that
> particular _access_ be volatile-qualified, without the object itself 
> being
> such. Also note that the (dereferenced) result is also a valid lvalue 
> and
> hence can be used in "*(volatile int *)&a = b;" kind of construction
> (which we use for the atomic_set case).

There is a quite convincing argument that such an access _is_ an
access to a volatile object; see GCC PR21568 comment #9.  This
probably isn't the last word on the matter though...


Segher


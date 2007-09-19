Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbXISLBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbXISLBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 07:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbXISLA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 07:00:56 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:32865 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756726AbXISLAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 07:00:55 -0400
Date: Wed, 19 Sep 2007 07:00:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919110053.GB15500@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F04D53.6040903@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 07:00:03 up 51 days, 11:18,  4 users,  load average: 1.33, 1.56, 1.08
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Jeremy Fitzhardinge wrote:
> > Mathieu Desnoyers wrote:
> > 
> >> +#define immediate_read(name)						\
> >> +	({								\
> >> +		__typeof__(name##__immediate) value;			\
> >> +		switch (sizeof(value)) {				\
> >> +		case 1:							\
> >> +			asm (	".section __immediate, \"a\", @progbits;\n\t" \
> >> +					".long %1, (0f)+1, 1;\n\t"	\
> >> +					".previous;\n\t"		\
> >> +					"0:\n\t"			\
> >> +					"mov %2,%0;\n\t"		\
> > 
> > Given that you're relying on the exact instruction that this mov
> > generates, it might be better to explicitly put the opcodes in with
> > .byte.  That way you're protected from the assembler deciding to
> > generate some other form of the instruction (for whatever reason).  I
> > guess substituting in different registers would be a pain.
> 
> Allowing different registers should be doable, but if so, one would have
> to put 0: at the *end* of the instruction and use (0f)-4 instead, since
> the non-%eax forms are one byte longer.
> 
> This also seems "safer", since an imm32 is always the last thing in the
> instruction.
> 

The idea is very interesting, but then, if I can't be sure of the size
of my instruction, how can I align the immediate value properly ?

> 	-hpa
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

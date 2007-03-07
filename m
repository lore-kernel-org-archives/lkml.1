Return-Path: <linux-kernel-owner+w=401wt.eu-S1030766AbXCGAdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030766AbXCGAdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030775AbXCGAdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:33:44 -0500
Received: from ozlabs.org ([203.10.76.45]:53170 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030766AbXCGAdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:33:43 -0500
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <ak@suse.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070306193445.GI22829@bingen.suse.de>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <1173185592.4644.28.camel@localhost.localdomain>
	 <1173185666.4644.30.camel@localhost.localdomain>
	 <1173185734.4644.32.camel@localhost.localdomain>
	 <1173185827.4644.34.camel@localhost.localdomain>
	 <1173185909.4644.36.camel@localhost.localdomain>
	 <1173186021.4644.38.camel@localhost.localdomain>
	 <1173186107.4644.41.camel@localhost.localdomain>
	 <1173186214.4644.44.camel@localhost.localdomain>
	 <20070306193445.GI22829@bingen.suse.de>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:33:02 +1100
Message-Id: <1173227582.4644.74.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-06 at 20:34 +0100, Andi Kleen wrote:
> Sigh -- i had hoped this had settled down because it was a
> merging nightmare last time. Ok. 

Indeed, that's why I waited until everything else was fully merged and
accepted.

> > +#define percpu_to_op(op,var,val)				\
> > +	do {							\
> > +		typedef typeof(var) T__;			\
> > +		if (0) { T__ tmp__; tmp__ = (val); }		\
> > +		switch (sizeof(var)) {				\
> > +		case 1:						\
> > +			asm(op "b %1,"__percpu_seg"%0"		\
> > +			    : "+m" (var)			\
> > +			    :"ri" ((T__)val));			\
> 
> Perhaps I'm blind but I can't see where the %fs reference is there.
> How does this work? 

Here:

+/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
+#define __percpu_seg "%%fs:"
+#else  /* !SMP */
+#include <asm-generic/percpu.h>
+#define __percpu_seg ""
+#endif /* SMP */

That's how we get SMP & non-SMP unification in that code.

> Do you have text size comparisons before/after and possible lmbench? 

No, but I'll run them this evening.  Last time the size reduction was
slight, and there was no measurable performance improvement in
microbenchmarks.

Thanks,
Rusty.


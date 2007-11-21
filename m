Return-Path: <linux-kernel-owner+w=401wt.eu-S1765286AbXKUAe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765286AbXKUAe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756509AbXKUAeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:34:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756500AbXKUAeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:34:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Zachary Amsden <zach@vmware.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/18] x86 vDSO: ia32 sysenter_return
In-Reply-To: Zachary Amsden's message of  Tuesday, 20 November 2007 16:05:34 -0800 <1195603534.6352.231.camel@bodhitayantram.eng.vmware.com>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	<20071119220622.C5ED026F8BE@magilla.localdomain>
	<1195603534.6352.231.camel@bodhitayantram.eng.vmware.com>
X-Zippy-Says: Alright, you!!  Imitate a WOUNDED SEAL pleading for a PARKING SPACE!!
Message-Id: <20071121003413.D25F726F8BE@magilla.localdomain>
Date: Tue, 20 Nov 2007 16:34:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -104,7 +103,7 @@ ENTRY(ia32_sysenter_target)
> >  	pushfq
> >  	CFI_ADJUST_CFA_OFFSET 8
> >  	/*CFI_REL_OFFSET rflags,0*/
> > -	movl	$VSYSCALL32_SYSEXIT, %r10d
> > +	movl	8*3-THREAD_SIZE+threadinfo_sysenter_return(%rsp), %r10d
> 
> 8*3-THREAD_SIZE is not very intuitive.  Can you add a comment on the
> math?

When you are reading the whole stretch of code right there, and not just
the patch, it's fairly obvious that it matches the three pushes right there.


Thanks,
Roland

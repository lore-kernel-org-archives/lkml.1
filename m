Return-Path: <linux-kernel-owner+w=401wt.eu-S933158AbXCFJNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933158AbXCFJNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXCFJNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:13:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52321 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933158AbXCFJNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:13:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/linus
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
In-Reply-To: Ingo Molnar's message of  Tuesday, 6 March 2007 09:34:49 +0100 <20070306083449.GA12511@elte.hu>
X-Windows: live the nightmare.
Message-Id: <20070306091307.259DC1801C4@magilla.sf.frob.com>
Date: Tue,  6 Mar 2007 01:13:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -# define VDSO_PRELINK          VDSO_HIGH_BASE
> +# ifndef CONFIG_XEN
> +#  define VDSO_PRELINK         VDSO_HIGH_BASE
> +# else
> +#  define VDSO_PRELINK         (0UL - FIX_VDSO * PAGE_SIZE)
> +# endif
> 
> should be Kconfig driven, not #ifdef driven, due to cleanliness and also 
> because lguest wants to have the same thing. Plus:

In fact, with the relocate_vdso stuff it doesn't matter what VDSO_PRELINK
is at compile time.  It saves the small amount of startup cost if it
matches the runtime address, but that is probably not noticeable.

> furthermore, there should be a paravirt_ops method to chose the 
> relocation address, unless i'm missing something. On the native kernel 
> that address will default to 0xffffe000. (if CONFIG_COMPAT_VDSO is 
> selected)

For everything else to work, it needs to be set by changing __FIXADDR_TOP,
which seems to be done by calling reserve_top_address early enough.
It looks like that needs to be properly tied into paravirt_ops somehow.


Thanks,
Roland

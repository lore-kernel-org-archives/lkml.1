Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYDNEDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYDNEDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 00:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846AbYDNEDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 00:03:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYDNEDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 00:03:43 -0400
Date: Sun, 13 Apr 2008 20:58:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Erik Bosman <ejbosman@cs.vu.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3-REVISED] x86: Implement prctl PR_GET_TSC and
 PR_SET_TSC
Message-ID: <20080413205821.61d6c85b@laptopd505.fenrus.org>
In-Reply-To: <Pine.GSO.4.56.0804140014000.6537@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
	<Pine.GSO.4.56.0804140014000.6537@keg.few.vu.nl>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2008 00:24:18 +0200 (CEST)
Erik Bosman <ejbosman@cs.vu.nl> wrote:

> 
> (I have made it non-configurable and it does not touch
> kernel/seccomp.c anymore. I only changed ifdef/endifs)
> 
>     This patch implements the PR_GET_TSC and PR_SET_TSC prctl()
>     commands on the x86 platform (both 32 and 64 bit.) These
>     commands control the ability to read the timestamp counter
>     from userspace (the RDTSC instruction.)
> 
>     While the RDTSC instuction is a useful profiling tool,
>     it is also the source of some non-determinism in ring-3.
>     For deterministic replay applications it is useful to be
>     able to trap and emulate (and record the outcome of) this
>     instruction.
> 
>     This patch uses code earlier used to disable the timestamp
>     counter for the SECCOMP framework. A side-effect of this
>     patch is that the SECCOMP environment will now also disable
>     the timestamp counter on x86_64 due to the addition of the
>     TIF_NOTSC define on this platform.
> 
>     The code which enables/disables the RDTSC instruction during
>     context switches is in the __switch_to_xtra function, which
>     already handles other unusual conditions, so normal
>     performance should not have to suffer from this change.
> 
>     Signed-off-by: Erik Bosman <ejbosman@cs.vu.nl>


I like this a whole lot more than the previous version; in fact
I like how it gets rid of various ifdefs. It's a bit unfortunate that
it duplicates for 32/64 bit but this code isn't unified yet, and at least
your 2 functions are identical, making it not hard to deal with in the unification.
(so .. not your fault you did all the right things)


Acked-by: Arjan van de Ven  <arjan@linux.intel.com>



Btw one other reason I like this general approach is that we can now start to get
apps to ask for the tsc to be enabled when they use it, and then we can just say
"no" on systems without reliable tsc...
(obviously we can't do that right away but we should try to migrate to that approach)


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

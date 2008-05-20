Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbYETB5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbYETB5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 21:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYETB5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 21:57:25 -0400
Received: from mga11.intel.com ([192.55.52.93]:16530 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbYETB5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 21:57:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,513,1204531200"; 
   d="scan'208";a="330124820"
Date: Mon, 19 May 2008 18:57:24 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, andi@firstfloor.org, roland@redhat.com,
       drepper@redhat.com, Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080520015723.GD30034@linux-os.sc.intel.com>
References: <20080513011030.GA31448@linux-os.sc.intel.com> <18477.35703.679574.760417@harpo.it.uu.se> <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18481.37905.297556.288317@harpo.it.uu.se>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 04:52:01PM +0200, Mikael Pettersson wrote:
> > But we can
> >use some what similar magic, if the fxsave/fxrstor give away
> >some of the fields at the end of fxsave image (today it is reserved
> >and ignored during fxsave/fxrstor) for software use.
> >We can then use these fields at the end of fpstate, to indicate the presence of
> >xstate. But this requires some architecture changes like giving
> >away this space for SW use. We can take this to architects and
> >see what they think.
> 
> If the HW doesn't store anything valuable there, we could store
> SW flags/cookies there on signal delivery, and clear them before
> fxrstor (unless the HW is known to ignore those fields).
> But it depends on how forgiving the HW is.

Ok. CPU folks are planning to make some of the bytes at the end of fxsave
image, SW usable.

We can use some of these fields, to represent the extended state
presence with a cookie, save area size, mask of the state
stored. If needed, we can include the start address of the fpstate pointer
(also as part of the cookie), so that we can detect the situation,
where apps are just memcopying sizeof(struct _fpstate) from the fpstate
pointer (but not aware of the extended state).

we don't need any ucontext_t extensions any more and just
use the fpstate pointer to indicate the extended state aswell, right?

In addition, we need to make sure that for 32bit non-rt sigframes, we
don't modify the extramask[] offset.

thanks,
suresh

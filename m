Return-Path: <linux-kernel-owner+w=401wt.eu-S1763888AbXHDMvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763888AbXHDMvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 08:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbXHDMva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 08:51:30 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:48555 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756725AbXHDMv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 08:51:29 -0400
Date: Sat, 4 Aug 2007 21:50:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Adrian McMenamin <lkmladrian@gmail.com>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] SH: add machine-ops and Dreamcast specific fix-up
Message-ID: <20070804125043.GA26153@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net
References: <8b67d60708031226m747f142sd3ed4447fb896a94@mail.gmail.com> <20070804030624.GA20847@linux-sh.org> <1186214076.6302.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186214076.6302.4.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 04, 2007 at 08:54:36AM +0100, Adrian McMenamin wrote:
> On Sat, 2007-08-04 at 12:06 +0900, Paul Mundt wrote:
> > On Fri, Aug 03, 2007 at 08:26:17PM +0100, Adrian McMenamin wrote:
> > > +static void mach_reboot_fixups(void)
> > > +{
> > > +	if (mach_is_dreamcast()) {
> > > +		writel(0x00007611, 0xA05F6890);
> > > +	}
> > > +}
> > > +
> > Whether it's only the dreamcast or not is irrelevant, why bother adding
> > abstraction if you intend to add pointless hacks that completely
> > side-steps it?
> > 
> 
> I don't understand the point you are trying to make. Please explain with
> more clarity. What have I completely side stepped? I have followed,
> broadly, the same pattern used in i386. Just that there, afaics, they
> pick up on various PCI cards as the basis on which to modify the reboot.
> 
You've introduced infrastructure to permit different machine types to
provide their own reboot hooks, and instead of actually providing a
machine-specific implementation, you've just hacked the native
implementation ith machine-type checks. This is conceptually no different
from your previous hack of sprinkling Dreamcast hooks in process.c.

The entire point of this abstraction is so that you can push what logic
you need down in to your board directory and _not_ have to shove this
sort of pointless crap in to the common code.

> > > diff --git a/include/asm-sh/emergency-restart.h
> > > b/include/asm-sh/emergency-restart.h
> > > index 108d8c4..d6bec92 100644
> > > --- a/include/asm-sh/emergency-restart.h
> > > +++ b/include/asm-sh/emergency-restart.h
> > > @@ -1,6 +1,6 @@
> > > -#ifndef _ASM_EMERGENCY_RESTART_H
> > > -#define _ASM_EMERGENCY_RESTART_H
> > > +#ifndef _ASM_SH_EMERGENCY_RESTART_H
> > > +#define _ASM_SH_EMERGENCY_RESTART_H
> > > 
> > > -#include <asm-generic/emergency-restart.h>
> > > +extern void machine_emergency_restart(void);
> > > 
> > > -#endif /* _ASM_EMERGENCY_RESTART_H */
> > > +#endif /* _ASM_SH_EMERGENCY_RESTART_H */
> > > 
> > Pointless. Separating out machine_emergency_restart() buys us nothing,
> > leave this alone and just kill it off from the machine_ops entirely.
> > You've also ignored my earlier mail where I suggested this and killing
> > off some of the other ops we had no use for (as well as consolidating
> > machine_crash_shutdown()). I do wish you would read these things and wait
> > until there's been a resolution one way or another.
> 
> I haven't ignored it. It was just explained with your customary
> clarity :)

If there was something you were unclear about, perhaps you should have
asked for clarification instead of ignoring it? I didn't think any of
these points were terribly difficult to parse.

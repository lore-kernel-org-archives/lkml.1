Return-Path: <linux-kernel-owner+w=401wt.eu-S2992762AbXDRVYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992762AbXDRVYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992772AbXDRVYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:24:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:46137 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992762AbXDRVYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:24:43 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Robert P. J. Day" <rpjday@mindspring.com>, davej@codemonkey.org.uk
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Date: Wed, 18 Apr 2007 17:23:15 -0400
User-Agent: KMail/1.9.5
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704181524.16980.lenb@kernel.org> <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0704181615510.18034@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704181723.16241.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2007 16:23, Robert P. J. Day wrote:
> On Wed, 18 Apr 2007, Len Brown wrote:

> > Here is how it should work. CONFIG_ACPI and CONFIG_APM should both
> > available in a kernel build. However, at boot time, of ACPI is
> > active, then APM should be disabled.
> >
> > The pm_active flag used to handle this, but that method was BROKEN
> > when the CONFIG_PM_LEGACY #define was added.  Today, there are
> > systems (such as the Thinkpad T30) that will not boot if
> > CONFIG_PM_LEGACY is not defined.  The reason nobody is complaining
> > is because the distros are currently defining CONFIG_PM_LEGACY.
> > But when you nuke that option and everything under it, this bug will
> > be exposed and some systems will stop booting.
> 
> ok, i get it now and -- correct me if i'm wrong -- all my legacy PM
> removal patch was doing was exposing a design boo-boo in which
> APM/ACPI contention was being handled by a macro in a subsystem even
> older than either of them, right?

yeah, it didn't start out that way, the bug was added when the
CONFIG_PM_LEGACY #define was added.

> so all that needs to be done is add 
> back in a contention solution of some kind that doesn't rely on that
> ancient system, yes?

Yes, it is a matter of making the variable not go away when
the #define goes away.

> as for that thinkpad t30 situation, well, that's just borked, and
> should be fixed.

yes, the actual failure is that APM mode on the T30 hangs -- and that is
independent of the issue at hand.  However, there could be other
failures on other machines when both APM and ACPI think they are active.

> rday
> 
> p.s.  at the risk of repeating myself repetitively, do we now agree
> that what i was trying to remove *was* adequately ancient?  although
> it's clear that it has to be done slightly more carefully than was
> done in my initial patch.

yes, I think so.

> p.p.s.  patch improvements that will let me avoid doing any of that
> myself always welcome. :-)

well, I'm sorry that I've known about the APM issue for a long time
and done nothing about it.  I did ping davej when he broke it,
but his to-do list is probably even longer than mine.

-Len

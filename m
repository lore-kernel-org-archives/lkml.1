Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbXL1TeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbXL1TeO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbXL1Td7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:33:59 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48440 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXL1Td6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:33:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FADvedEdMROHU/2dsb2JhbACBV6s8
Date: Fri, 28 Dec 2007 14:28:55 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore blackfin HARDWARE_PM support
Message-ID: <20071228192855.GA23157@Krystal>
References: <20071228185643.GB4738@stusta.de> <20071228191404.GB21353@Krystal> <20071228192320.GI6780@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071228192320.GI6780@does.not.exist>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:27:17 up 55 days, 32 min,  4 users,  load average: 0.37, 0.90,
	0.77
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@kernel.org) wrote:
> On Fri, Dec 28, 2007 at 02:14:04PM -0500, Mathieu Desnoyers wrote:
> > * Adrian Bunk (adrian.bunk@movial.fi) wrote:
> > > This patch restores the blackfin Hardware Performance Monitor Profiling 
> > > support that was killed by
> > > commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> > > 
> > > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> > > 
> > 
> > Yep, this one too must be put back, but kernel/Kconfig.instrumentation
> > seems like the wrong spot for a blackfin-specific config option (and
> > this will break the instrumentation menu removal patches in -mm).
> > 
> > Can we put this in arch/blackfin/Kconfig instead ?
> 
> No, this is a user visible option that belongs into the same menu as
> "Profling support".
> 

Actually, I wonder why these options exist at all rather than being on
by default when profiling is enabled. There is no such thing as
"activating the performance monitor profiling" on other architectures.
What is so special about blackfin that makes it need it ?

> > > ---
> > > 
> > >  kernel/Kconfig.instrumentation |    9 +++++++++
> > >  1 file changed, 9 insertions(+)
> > > 
> > > 942996f33f81726c5edb012d61ecdad70c55884d 
> > > diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> > > index 97c76ca..e023671 100644
> > > --- a/kernel/Kconfig.instrumentation
> > > +++ b/kernel/Kconfig.instrumentation
> > > @@ -44,2 +44,11 @@ config OPROFILE_MPCORE
> > >  
> > > +config HARDWARE_PM
> > > +	tristate "Hardware Performance Monitor Profiling"
> > > +	depends on BLACKFIN && PROFILING
> > > +	help
> > > +	  take use of hardware performance monitor to profiling the kernel
> > > +	  and application.
> > > +
> > > +	  If unsure, say N.
> > > +
> > >  config KPROBES
> > > 
> > 
> > Mathieu Desnoyers
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

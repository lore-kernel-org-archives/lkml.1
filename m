Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXL1TXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXL1TXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXL1TXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:23:32 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45390 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbXL1TXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:23:31 -0500
Date: Fri, 28 Dec 2007 21:23:20 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.24 patch] restore blackfin HARDWARE_PM support
Message-ID: <20071228192320.GI6780@does.not.exist>
References: <20071228185643.GB4738@stusta.de> <20071228191404.GB21353@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071228191404.GB21353@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 02:14:04PM -0500, Mathieu Desnoyers wrote:
> * Adrian Bunk (adrian.bunk@movial.fi) wrote:
> > This patch restores the blackfin Hardware Performance Monitor Profiling 
> > support that was killed by
> > commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> > 
> > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> > 
> 
> Yep, this one too must be put back, but kernel/Kconfig.instrumentation
> seems like the wrong spot for a blackfin-specific config option (and
> this will break the instrumentation menu removal patches in -mm).
> 
> Can we put this in arch/blackfin/Kconfig instead ?

No, this is a user visible option that belongs into the same menu as
"Profling support".

> > ---
> > 
> >  kernel/Kconfig.instrumentation |    9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > 942996f33f81726c5edb012d61ecdad70c55884d 
> > diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> > index 97c76ca..e023671 100644
> > --- a/kernel/Kconfig.instrumentation
> > +++ b/kernel/Kconfig.instrumentation
> > @@ -44,2 +44,11 @@ config OPROFILE_MPCORE
> >  
> > +config HARDWARE_PM
> > +	tristate "Hardware Performance Monitor Profiling"
> > +	depends on BLACKFIN && PROFILING
> > +	help
> > +	  take use of hardware performance monitor to profiling the kernel
> > +	  and application.
> > +
> > +	  If unsure, say N.
> > +
> >  config KPROBES
> > 
> 
> Mathieu Desnoyers

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbXL2GOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbXL2GOF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 01:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbXL2GNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 01:13:54 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:29702 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXL2GNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 01:13:53 -0500
X-IronPort-AV: E=Sophos;i="4.24,219,1196658000"; 
   d="scan'208";a="59158189"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [2.6.24 patch] restore blackfin HARDWARE_PM support
Date: Sat, 29 Dec 2007 01:14:46 -0500
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
References: <20071228185643.GB4738@stusta.de> <20071228192320.GI6780@does.not.exist> <20071228192855.GA23157@Krystal>
In-Reply-To: <20071228192855.GA23157@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290114.46694.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 29 Dec 2007 06:13:51.0833 (UTC) FILETIME=[FBA39490:01C849E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 28 Dec 2007 14:28, Mathieu Desnoyers pondered:
> * Adrian Bunk (bunk@kernel.org) wrote:
> > On Fri, Dec 28, 2007 at 02:14:04PM -0500, Mathieu Desnoyers wrote:
> > > * Adrian Bunk (adrian.bunk@movial.fi) wrote:
> > > > This patch restores the blackfin Hardware Performance Monitor Profiling 
> > > > support that was killed by
> > > > commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> > > > 
> > > > Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> > > > 
> > > 
> > > Yep, this one too must be put back, but kernel/Kconfig.instrumentation
> > > seems like the wrong spot for a blackfin-specific config option (and
> > > this will break the instrumentation menu removal patches in -mm).
> > > 
> > > Can we put this in arch/blackfin/Kconfig instead ?
> > 
> > No, this is a user visible option that belongs into the same menu as
> > "Profling support".
> > 
> 
> Actually, I wonder why these options exist at all rather than being on
> by default when profiling is enabled. There is no such thing as
> "activating the performance monitor profiling" on other architectures.
> What is so special about blackfin that makes it need it ?

This is probably more historical, and you are correct - it should just be part of profiling.


> > > > ---
> > > > 
> > > >  kernel/Kconfig.instrumentation |    9 +++++++++
> > > >  1 file changed, 9 insertions(+)
> > > > 
> > > > 942996f33f81726c5edb012d61ecdad70c55884d 
> > > > diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
> > > > index 97c76ca..e023671 100644
> > > > --- a/kernel/Kconfig.instrumentation
> > > > +++ b/kernel/Kconfig.instrumentation
> > > > @@ -44,2 +44,11 @@ config OPROFILE_MPCORE
> > > >  
> > > > +config HARDWARE_PM
> > > > +	tristate "Hardware Performance Monitor Profiling"
> > > > +	depends on BLACKFIN && PROFILING
> > > > +	help
> > > > +	  take use of hardware performance monitor to profiling the kernel
> > > > +	  and application.
> > > > +
> > > > +	  If unsure, say N.
> > > > +
> > > >  config KPROBES
> > > > 
> > > 
> > > Mathieu Desnoyers
> > 
> > cu
> > Adrian
> > 
> > -- 
> > 
> >        "Is there not promise of rain?" Ling Tan asked suddenly out
> >         of the darkness. There had been need of rain for many days.
> >        "Only a promise," Lao Er said.
> >                                        Pearl S. Buck - Dragon Seed
> > 
> 

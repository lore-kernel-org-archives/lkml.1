Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0CBBkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 20:40:18 -0500
Received: from mga10.intel.com ([192.55.52.92]:32919 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752847Ab0CBBkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 20:40:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,563,1262592000"; 
   d="scan'208";a="777068023"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 4/7] xen: The entrance for PV extension of HVM
Date: Tue, 2 Mar 2010 09:41:13 +0800
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-devel" <xen-devel@lists.xensource.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com> <1267436315-24486-5-git-send-email-sheng@linux.intel.com> <4B8C6460.6020506@goop.org>
In-Reply-To: <4B8C6460.6020506@goop.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003020941.13499.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 March 2010 09:05:36 Jeremy Fitzhardinge wrote:
> On 03/01/2010 01:38 AM, Sheng Yang wrote:
> > xen_guest_init() would setup the environment.
> >
> > Cc: Ingo Molnar<mingo@elte.hu>
> > Signed-off-by: Sheng Yang<sheng@linux.intel.com>
> > ---
> >   arch/x86/kernel/setup.c |    8 ++++++++
> >   1 files changed, 8 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 5d9e40c..2b61d46 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -113,6 +113,10 @@
> >   #endif
> >   #include<asm/mce.h>
> >
> > +#ifdef CONFIG_XEN
> > +#include<xen/xen.h>
> > +#endif
> 
> No #ifdefs; put them in xen.h if necessary (which they aren't).  This
> probably isn't the right header anyway; this is specifically for testing
> the presence of Xen and/or the current domain type.  It shouldn't have
> any other prototypes in it, or include anything else (it probably
> already includes too much).  Given this is already x86-specific code,
> include asm/xen/something.h.

Would update it. Thanks.

-- 
regards
Yang, Sheng

> 
> > +
> >   /*
> >    * end_pfn only includes RAM, while max_pfn_mapped includes all e820
> > entries. * The direct mapping extends to max_pfn_mapped, so that we can
> > directly access @@ -740,6 +744,10 @@ void __init setup_arch(char
> > **cmdline_p)
> >
> >   	x86_init.oem.arch_setup();
> >
> > +#ifdef CONFIG_XEN
> > +	xen_guest_init();
> > +#endif
> 
> Again, no #ifdefs here.  Put an #ifdeffed stub in an appropriate header.
> 
>      J
> 
	

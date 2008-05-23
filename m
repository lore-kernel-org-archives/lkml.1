Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYEWBtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYEWBtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 21:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYEWBs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 21:48:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:31252 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbYEWBs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 21:48:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="251089108"
Date: Thu, 22 May 2008 18:48:55 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
       Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080523014855.GA18385@linux-os.sc.intel.com>
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <20080522212920.GC7998@linux-os.sc.intel.com> <4835E6F5.5010801@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4835E6F5.5010801@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 02:34:45PM -0700, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> >
> >can you please elaborate? even in presence of virtualization, appropriate
> >cpuid bits need to be set/visible for application, for xsave/xrstor to work
> >properly.
> >
> 
> For many paravirtualization solutions, CPUID "leak" from the hypervisor. 
>  The fact that CPUID cannot be disabled (made ring 0 only) is a major 
> flaw in the architecture.
> 
> Therefore, relying on CPUID is too dangerous.

hmm.. so the kernel needs to export all the cpuid info (that the kernel enables
and supports) to the user through some mechanism then?

atleast in the xsave case, hypervisor can completely control the
OSXSAVE flag. I am still not convinced whether I need to add prctl()
to indicate the layout. If I have to add, then it should not just
be about whether xsave information is included in _fpstate or not, it should also
be about the whole cpuid information provided by the xsave architecture. Because
the user potentially needs all that information, to make sense out of
the data layout included in the extended state area.

thanks,
suresh

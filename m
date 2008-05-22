Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbYEVV3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbYEVV3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbYEVV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:29:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:21438 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995AbYEVV3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:29:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="331376373"
Date: Thu, 22 May 2008 14:29:21 -0700
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
Message-ID: <20080522212920.GC7998@linux-os.sc.intel.com>
References: <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4835DF64.6080104@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 02:02:28PM -0700, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> >
> >hpa, What is the virtualization problem? Are you referring to perf problem?
> >As you noted, regular non-rt signal handlers won't need this cpuid check. 
> >It's
> >needed only for those who manually look at non-rt signal frames and 
> >interpret it.
> >And also, they can do this check only once and not everytime.
> >
> 
> No, relying on CPUID and vdso both have implications for virtualization.

can you please elaborate? even in presence of virtualization, appropriate
cpuid bits need to be set/visible for application, for xsave/xrstor to work
properly.

> I don't think it is ... it's not overkill but rather "underkill"... it's 
> a low-performance solution but it's guaranteed to be safe in the 
> presence of virtualization of all its various ilk.  Note that you don't 
> need to be able to *set* the format via prctl(), just *query* (get) it.
>
> Using prctl() allows us to make this personality-dependent if we ever 
> need to.
>
> >While restoring from the user, kernel also need to find out what layout
> >the user is passing. So it's bi-directional. I prefer the same mechanism
> >(using cookies/magic numbers etc inaddition to uc_flags or cpuid checks) to
> >interpret the fpstate for both user/kernel.
> 
> No, it really doesn't: the kernel only needs to be able to read the same 
> format as it itself wrote.

But user can potentially change the _fpstate pointer in sigcontext struct.

> 
> >ARM also seem to be using similar things while extending their ucontext_t,
> >with out other kernel interfaces to indicate the layout.
> >
> >BTW, how come 32bit kernel doesn't have the X86_FXSR_MAGIC checks, while 
> >restoring
> >the extended fxsave data from _fpstate?
> 
> Again, the kernel already knows the format, so it doesn't need to check.

What happens with some old applications which change the _fpstate
pointer. they may or may not be fxsave aware...

thanks,
suresh

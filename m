Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYEVVLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYEVVLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbYEVVK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:10:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290AbYEVVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:10:56 -0400
Message-ID: <4835DF64.6080104@zytor.com>
Date: Thu, 22 May 2008 14:02:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>
CC: Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
       mingo@elte.hu, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, roland@redhat.com, drepper@redhat.com,
       Hongjiu.lu@intel.com, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, rmk+lkml@arm.linux.org.uk, dan@debian.org,
       asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
References: <20080518013416.GB30034@linux-os.sc.intel.com> <18481.37905.297556.288317@harpo.it.uu.se> <20080520015723.GD30034@linux-os.sc.intel.com> <4832A173.6020203@firstfloor.org> <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com>
In-Reply-To: <20080522205619.GB7998@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> 
> hpa, What is the virtualization problem? Are you referring to perf problem?
> As you noted, regular non-rt signal handlers won't need this cpuid check. It's
> needed only for those who manually look at non-rt signal frames and interpret it.
> And also, they can do this check only once and not everytime.
> 

No, relying on CPUID and vdso both have implications for virtualization.

> To me, prtcl() just seems to be an overkill.

I don't think it is ... it's not overkill but rather "underkill"... it's 
a low-performance solution but it's guaranteed to be safe in the 
presence of virtualization of all its various ilk.  Note that you don't 
need to be able to *set* the format via prctl(), just *query* (get) it.

Using prctl() allows us to make this personality-dependent if we ever 
need to.

> While restoring from the user, kernel also need to find out what layout
> the user is passing. So it's bi-directional. I prefer the same mechanism
> (using cookies/magic numbers etc inaddition to uc_flags or cpuid checks) to
> interpret the fpstate for both user/kernel.

No, it really doesn't: the kernel only needs to be able to read the same 
format as it itself wrote.

> ARM also seem to be using similar things while extending their ucontext_t,
> with out other kernel interfaces to indicate the layout.
> 
> BTW, how come 32bit kernel doesn't have the X86_FXSR_MAGIC checks, while restoring
> the extended fxsave data from _fpstate?

Again, the kernel already knows the format, so it doesn't need to check.

	-hpa

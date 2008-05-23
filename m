Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbYEWAmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbYEWAmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 20:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759700AbYEWAmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 20:42:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:53096 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759657AbYEWAmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 20:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,526,1204531200"; 
   d="scan'208";a="284173368"
Date: Thu, 22 May 2008 17:42:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       roland@redhat.com, drepper@redhat.com, Hongjiu.lu@intel.com,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       rmk+lkml@arm.linux.org.uk, dan@debian.org, asit.k.mallick@intel.com
Subject: Re: [RFC] x86: xsave/xrstor support, ucontext_t extensions
Message-ID: <20080523004206.GD7998@linux-os.sc.intel.com>
References: <18482.53246.642835.894623@harpo.it.uu.se> <4832E705.2010900@zytor.com> <18482.60491.764019.292031@harpo.it.uu.se> <20080520175325.GE30034@linux-os.sc.intel.com> <4834BE39.2000904@zytor.com> <18485.13663.51624.694435@harpo.it.uu.se> <20080522205619.GB7998@linux-os.sc.intel.com> <4835DF64.6080104@zytor.com> <18485.62848.335125.152538@harpo.it.uu.se> <483610DA.7010606@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483610DA.7010606@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 05:33:30PM -0700, H. Peter Anvin wrote:
> Mikael Pettersson wrote:
> >
> > > > While restoring from the user, kernel also need to find out what 
> > layout
> > > > the user is passing. So it's bi-directional. I prefer the same 
> > mechanism
> > > > (using cookies/magic numbers etc inaddition to uc_flags or cpuid 
> > checks) to
> > > > interpret the fpstate for both user/kernel.
> > > 
> > > No, it really doesn't: the kernel only needs to be able to read the 
> > same > format as it itself wrote.
> >
> >The kernel needs to accept one(*) of the formats it can produce, which
> >is not necessarily what it last produced. It's not inconceivable that
> >user-space will construct sigframes on the fly (to emulate setcontext),
> >or that it will mangle sigframes (e.g. to map non-rt to rt before 
> >sigreturn).
> >
> >(*) The format is determined by which version of sys_sigreturn the
> >user invokes.
> >
> 
> No.  You CANNOT restore from a frame that doesn't have the full state - 
> you don't have enough information to do so!

What I was doing in the RFC is: restore the state what ever that was present and
init the state that was not present in the stack frame.

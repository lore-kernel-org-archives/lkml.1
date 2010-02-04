Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab0BDWGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:06:21 -0500
Received: from mga11.intel.com ([192.55.52.93]:17280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0BDWGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:06:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,407,1262592000"; 
   d="scan'208";a="537873592"
Subject: Re: [patch] x86: ptrace and core-dump extensions for xstate
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Lu, Hongjiu" <hongjiu.lu@intel.com>,
       "Lachner, Peter" <peter.lachner@intel.com>
In-Reply-To: <20100204205543.E1D11E7@magilla.sf.frob.com>
References: <1265076025.2802.194.camel@sbs-t61.sc.intel.com>
	 <20100203230817.E6529AA@magilla.sf.frob.com>
	 <1265315329.2768.167.camel@sbs-t61.sc.intel.com>
	 <20100204205543.E1D11E7@magilla.sf.frob.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 04 Feb 2010 14:05:14 -0800
Message-Id: <1265321114.2768.256.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 12:55 -0800, Roland McGrath wrote:
> Just proofread it.  I really did mean "obvious typos", i.e. spelling,
> whitespace, punctuation, nothing more.

Roland, All I found after double checking is:

> For now, only first 8 bytes of the sw_usable_bytes[464..467]

should be

> For now, only first 8 bytes of the sw_usable_bytes[464..471]

Let me know if I am overlooking something.

> 
> > This issue is not new and gets handled in the same way as for existing
> > fxsave/fxrstor, as they don't specify page alignment restrictions.
> 
> I didn't suggest it was new.  I was looking for some confirmation that
> there is in fact no permanent (i.e. compile-time) size limit.

Yes. No size limit as of now.

> I don't think this is the right way to think about it.  The regset code
> does not need to do anything different at all.  There will in future be
> other callers of the regset hooks, that's what the whole interface is there
> for.  Regardless of whether modification is full or partial, you just
> enforce the various bitmasks on the resultant buffer as you already do, and
> that's all there is to it.  If userland stores partial contents with a
> bogus format, that's its problem.  It's just like the program itself had
> used xrstor in user mode with the same bogus buffer contents.

Ok. I think I can agree, if we are ok with giving room for the ptrace
(or any other user of the API) to make a mistake and corrupt reg-state
of the process under debug, if it doesn't follow rules.

> > We probably have to extend regset infrastructure to track which NT_*
> > types are part of PTRACE_[GET|SET]REGSET and which are not.
> 
> I don't understand what you mean.  The point of the generic requests is
> that they apply to any user_regset you want.  user_regset does not need
> anything new.

Thought some of them might be only relevant to core-dump or based on
permissions etc. But I guess get/set routines of the regset should be
able to take care of this?

> > Also, I am not sure if pushing the ptrace interpretation of the user
> > pointer into the regset routines is a good idea. 
> 
> I don't understand what you mean here at all.  I did not suggest anything
> that affects what the regset routines themselves do in any way at all.
>
> It is an unacceptably bad idea to have any new ptrace interfaces for regset
> access that do anything different than exactly let you get/set all or part
> of a regset exactly as the arch's user_regset provides it.

So in the example you provided before:

        struct iovec iov = { mybuffer, mylength };
        ret = ptrace(PTRACE_GETREGSET, NT_X86_XSTATE, &iov);

You wanted to propose common data format (iov) for all of the NT_* ?

thanks,
suresh


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628AbYFRMUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbYFRMUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYFRMUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:20:01 -0400
Received: from ozlabs.org ([203.10.76.45]:40834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYFRMUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:20:01 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: 2.6.26-git: NULL pointer deref in __switch_to
Date: Wed, 18 Jun 2008 22:19:46 +1000
User-Agent: KMail/1.9.9
Cc: Simon Holm =?iso-8859-1?q?Th=F8gersen?= <odie@cs.aau.dk>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, "x86@kernel.org" <x86@kernel.org>
References: <4852B19E.4010202@trash.net> <200806181534.24085.rusty@rustcorp.com.au> <20080618062357.GC23370@linux-os.sc.intel.com>
In-Reply-To: <20080618062357.GC23370@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806182219.46892.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 16:23:57 Suresh Siddha wrote:
> hi Rusty,
>
> On Tue, Jun 17, 2008 at 10:34:23PM -0700, Rusty Russell wrote:
> >    Firstly, thanks for figuring this out.  But math_state_restore() has
> > nasty semantics now.  Currently lguest will work, because no code path
> > following this call relies on being on the same CPU.
> >
> > So, this patch is fine, but I wonder if I should just be forcing fpu
> > allocation earlier for lguest tasks, so I can avoid this altogether?
>
> Even with force fpu allocation, we need these fixes(except for the SYSENTER
> hunk)
>
> Just to clarify, dynamic fpu allocation didn't create these problems.
> Some of these problems were there before aswell, and would show up as
> fpu corruption for some of the tasks inside the lguest. With the
> dynamic fpu allocation, it showed up as host kernel oops.
>
> In future, if lguest driver code ever has a code path which relies
> on running on the same cpu after math_state_restore(), yes they
> can force allocate, by doing early math_state_restore() before
> the guest starts.
>
> But the current usage of lguest_set_ts() is clearly broken and violates
> certain behavior expected by the fpu context switch handling routines.

OK, lguest pieces Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Since this has non-lguest pieces, please send via Ingo.

Cheers,
Rusty.

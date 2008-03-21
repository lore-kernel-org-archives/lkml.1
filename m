Return-Path: <linux-kernel-owner+w=401wt.eu-S1757547AbYCUOKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547AbYCUOKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYCUOKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:10:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57352 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbYCUOKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:10:33 -0400
Date: Fri, 21 Mar 2008 15:10:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Roland McGrath <roland@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 6/8] ptrace: arch_ptrace -ENOSYS return
Message-ID: <20080321141051.GA27591@uranus.ravnborg.org>
References: <20080319211714.8B14226F995@magilla.localdomain> <20080319212024.EA03126F995@magilla.localdomain> <alpine.LFD.1.00.0803191935080.3020@woody.linux-foundation.org> <20080320081658.0B23826F995@magilla.localdomain> <alpine.LFD.1.00.0803211441180.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211441180.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 02:50:01PM +0100, Thomas Gleixner wrote:
> On Thu, 20 Mar 2008, Roland McGrath wrote:
> > > Wouldn't it be nicer to just let "arch_ptrace()" return a flag saying 
> > > whether it handled things or not?
> > 
> > It would certainly be nicer.  I would prefer:
> > 
> > extern int arch_ptrace(struct task_struct *child, long request,
> >        	    	       long addr, long data, long *retval);
> > 
> > where it returns an error code or it returns 0 and *retval is the value
> > or it returns 1 and it didn't do anything.
> >
> > So this ugliness seemed like a better bet than waiting for 20 more
> > arch sign-offs before any of it could go in.  You are certainly in a
> > position to just change the generic signature and make every arch do
> > the update (or fix your typos if you just tweak them all blind), and
> > let them grumble.  I did not presume to do so.
> 
> What about adding a CONFIG_ARCH_HAS_PTRACE2, which is set by the archs
> which are converted. For those which are not you add a fallback
> implementation:

HAVE_PTRACE2 or at least following the HAVE_* semnatic.
And then do:

config HAVE_PTRACE2
	def_bool n

In some common file.
Then arch files can do:
 config X86
	...
+	select HAVE_PTRACE2

	Sam

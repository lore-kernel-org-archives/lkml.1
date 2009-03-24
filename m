Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZCXWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZCXWtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZCXWtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:49:07 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:56687 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZCXWtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nwaUNGkbHZdV6cFe+DipqgMCa72DI2Y385+zRaiwntCoKBrwHuKps+NsV+TrDCLlD+
         oEbEnjdY8me15IjHqyMbYEGU5E6Ptggzdcl4Md2oNXF2Ie137av6YRDxzHiqLhndNlYw
         AlZ3RBIRIqm+F0cFhmywQ8QjDOOWZWGKxPfqY=
Date: Tue, 24 Mar 2009 23:48:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090324224857.GE5975@nowhere>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C95EAF.7030901@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 06:29:03PM -0400, Abhishek Sagar wrote:
> Frederic Weisbecker wrote:
> > Yes, ie:
> >
> > _Before jumping to the function entry hook, you must save
> > the arguments for the traced function on the stack.
> > On x86, its eax, edx and ecx.
> > On arm, it will be r0-r3.
> > Then you have to transmit the address of the traced function
> > (it's on r14) and it's parent (must rely on fp for that).
> > Then you call the entry hook and restore the old scratch/arg
> > registers.
> >   
> Instead of just restoring the old backed-up args, lr can be fixed up
> inside the entry hook to point to the return hook. So when the traced
> function returns, it actually returns to the return hook (where we can
> restore the original return address). This means that
> -finstrument-functions is not required at all. This is analogous to how
> kretprobes work. The only difference here is that instead of planting a
> kprobe at the function entry and redirecting the function return to the
> profiling exit routine, we can use mcount. This is slightly more
> complicated to implement but can be a very efficient alternative to
> kretprobes.
> --
> Abhishek
> 

Indeed, you need to override lr, that even the only solution.
I was still thinking in an x86 way with its on stack return address.


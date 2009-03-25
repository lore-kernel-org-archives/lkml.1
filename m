Return-Path: <linux-kernel-owner+w=401wt.eu-S1757608AbZCYInT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608AbZCYInT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 04:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbZCYInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 04:43:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46207 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbZCYInE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 04:43:04 -0400
Date: Wed, 25 Mar 2009 08:42:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>, Tim Bird <tim.bird@am.sony.com>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: Anyone working on ftrace function graph support on ARM?
Message-ID: <20090325084248.GF4697@n2100.arm.linux.org.uk>
References: <49C936CA.8070800@am.sony.com> <20090324213618.GC5975@nowhere> <49C95EAF.7030901@gmail.com> <20090324224857.GE5975@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324224857.GE5975@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 11:48:58PM +0100, Frederic Weisbecker wrote:
> On Tue, Mar 24, 2009 at 06:29:03PM -0400, Abhishek Sagar wrote:
> > Instead of just restoring the old backed-up args, lr can be fixed up
> > inside the entry hook to point to the return hook. So when the traced
> > function returns, it actually returns to the return hook (where we can
> > restore the original return address). This means that
> > -finstrument-functions is not required at all. This is analogous to how
> > kretprobes work. The only difference here is that instead of planting a
> > kprobe at the function entry and redirecting the function return to the
> > profiling exit routine, we can use mcount. This is slightly more
> > complicated to implement but can be a very efficient alternative to
> > kretprobes.
> > --
> > Abhishek
> > 
> 
> Indeed, you need to override lr, that even the only solution.
> I was still thinking in an x86 way with its on stack return address.

As pointed out in my previous mail, identifying where on the stack the
return address is stored is only possible for OABI with frame pointers.

EABI will probably be possible with the stack unwinding code, but it
probably won't be cheap.  The EABI unwinder is scheduled for merging
during the present now-open merge window.

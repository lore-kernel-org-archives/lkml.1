Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYBEEye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYBEEye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbYBEEy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:54:26 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38674 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753290AbYBEEyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:54:25 -0500
Date: Mon, 4 Feb 2008 20:54:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Phil Oester <kernel@linuxace.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-Id: <20080204205412.466a883c.akpm@linux-foundation.org>
In-Reply-To: <20080205041103.GA11240@linuxace.com>
References: <20080130011550.GA31853@elte.hu>
	<200802050436.31070.maximlevitsky@gmail.com>
	<alpine.LFD.1.00.0802041922300.3237@woody.linux-foundation.org>
	<20080205041103.GA11240@linuxace.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 20:11:03 -0800 Phil Oester <kernel@linuxace.com> wrote:

> On Mon, Feb 04, 2008 at 07:27:53PM -0800, Linus Torvalds wrote:
> > kgdb? Not so interesting. We have many more hard problems happening at 
> > user sites, not in developer hands.
> 
> FWIW, I'm not a fulltime developer by any means, but on occasion
> I have fixed a few bugs in the netfilter area of the kernel.
> And in almost all cases, I used kgdb in my debugging and testing

                                                           ^^^^^^^
> of fixes.  

yup.

> In doing so, it was a bit of a PITA to find/patch kgdb into the
> kernel, and having it as a configurable option would have saved
> me some time and effort and made the process much smoother.
> 
> So perhaps someone else out there would find it similarly useful,
> and the extra time it takes to find/patch/compile kgdb in is
> precluding them from participating?  Why would we ever want to do
> that?

I used kgdb continuously for 4-5 years until it broke.  I don't think I
ever used it much for "debugging" as such.  I used it more for general
observation of what's going on in the kernel.  And for _confirmation_ of
what's going on (ie: testing that the actual state matches the expected
state).

I'd end up doing my development with the assumption that kgdb was present. 
One example: rather than putting printks all over the place to ensure that
the right thing was happening at the right time I'd instead add code like

void foo(void)
{
}

	...
	if (expr)
		foo();

then, when the testcase was up and running and in steady state, break in
and put a breakpoint on foo().  Continue, wait for the breakpoint then go
in and observe locals, globals, data structures, etc.

It's hard to describe (and remember!).  But the presence of the debugger as
a development (not debugging) tool changes the way you do development a bit.

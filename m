Return-Path: <linux-kernel-owner+w=401wt.eu-S1752533AbZKGS7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbZKGS7w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 13:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZKGS7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 13:59:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41929 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbZKGS7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 13:59:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: Intermittent early panic in try_to_wake_up
Date: Sat, 7 Nov 2009 20:01:16 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.31.5-tst; KDE/4.3.1; x86_64; ; )
Cc: Kevin Winchester <kjwinchester@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
References: <4AE0EBBD.6090005@gmail.com> <4AF59F24.4010501@gmail.com> <1257611754.4108.12.camel@laptop>
In-Reply-To: <1257611754.4108.12.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911072001.16223.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 November 2009, Peter Zijlstra wrote:
> On Sat, 2009-11-07 at 12:24 -0400, Kevin Winchester wrote:
> > Mike Galbraith wrote:
> > > On Fri, 2009-11-06 at 19:49 -0400, Kevin Winchester wrote:
> > > 
> > >> The patch below does not apply to mainline, unless I'm doing something wrong.
> > >> It's against -tip, I assume?  Is it just as applicable to mainline?
> > > 
> > > It was mainline, but I had the scheduler pull request and another in for
> > > testing as well.  Linus has pulled, so it'll apply now, with offsets.
> > > 
> > 
> > It did end up applying, but did not have any effect.  Looking at the patch
> > again, I see that it appears to only affect CONFIG_SMP, which I am not
> > running (and in fact it adds a build warning for the !SMP case).  So there
> > was not much chance of it fixing anything, I suppose.
> > 
> > Any other ideas?  I don't have a serial console, and the trace scrolls off
> > my console, so I don't know if any debug printks would help.  Would it help
> > if I copied the entire panic message entirely, including the Code section?
> > I can try that the next time it happens.
> 
> Use vga=ask boot_delay=100 select the highest res possible.
> 
> Possibly you could use a digital (video) camera to record the output.

FWIW, I see a crash in autoremove_wake_function() during resume from suspend
to RAM that happens immediately before the thawing of tasks.  It always happens
in the "events" thread.  I can trigger it quite reliably, although not 100% of
the time.

I can only see the bottom half of the call trace, so I can't really say what
kind of a crash this is.

Also, for quite some time I've been observing a resume-from-hibernation crash
during the final switch from a VT to X that could also be explained by a
problem with "events".

Best,
Rafael

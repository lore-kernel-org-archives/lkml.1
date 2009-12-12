Return-Path: <linux-kernel-owner+w=401wt.eu-S932222AbZLMBP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222AbZLMBP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932188AbZLMBPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:15:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49875 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756577AbZLMBPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:15:18 -0500
Date: Sat, 12 Dec 2009 09:16:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <20091212023603.93768833.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Andrew Morton wrote:

> On Sat, 12 Dec 2009 11:10:32 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > Seems to be quite .config-dependent.
> > 
> > My theory is that it's a race and that it's thus timing dependent. TTY 
> > SMP details get stressed most during a particular point during bootup, 
> > when all the mingetty's are starting up all at once and race with each 
> > other.
> > 
> > If you are lucky to not hit the bug then, then the likelyhood is much 
> > lower later on.
> > 
> > It would be nice if Alan posted his TTY stress-testing code. It could 
> > potentially make this bug bisectable.
> > 
> 
> I'm surprised that lockdep didn't notice that ab/ba I thought I saw. 
> Maybe the do_tty_hangup()->tty_fasync() never happens.

The kernel lock cannot have any ABBA deadlocks.

If somebody blocks on another lock (after getting the kernel lock), the 
kernel lock will be dropped. So no ABBA.

			Linus

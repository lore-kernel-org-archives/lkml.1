Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbYB2IGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbYB2IGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 03:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbYB2IGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 03:06:03 -0500
Received: from www.tglx.de ([62.245.132.106]:52458 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbYB2IGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 03:06:01 -0500
Date: Fri, 29 Feb 2008 09:04:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Roland McGrath <roland@redhat.com>
cc: Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Consolidate send_sigqueue and send_group_sigqueue
In-Reply-To: <20080228224141.A47B12700FD@magilla.localdomain>
Message-ID: <alpine.LFD.1.00.0802290902000.3111@apollo.tec.linutronix.de>
References: <47BEC663.7050904@openvz.org> <20080222144155.GA4349@tv-sign.ru> <alpine.LFD.1.00.0802280546360.7583@apollo.tec.linutronix.de> <20080228061723.GB108@tv-sign.ru> <20080228113633.7431C2700FD@magilla.localdomain> <alpine.LFD.1.00.0802282326560.3111@apollo.tec.linutronix.de>
 <20080228224141.A47B12700FD@magilla.localdomain>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Roland McGrath wrote:

> > Right. I was working on a fix for that for a different reason. What we
> > really want is a check for such a timer on a transition from SIGIGN to
> > another state.  This would allow us to drop the ugly auto rearm code
> > for ignored timers completely. I had some working proof of concept
> > code, but got distracted. Need to find it again and dust if off.
> 
> That is certainly what came first to mind.  (Note that it's not strictly
> SIG_IGN alone, but sigaction_says_ignore.)  We'll have to contemplate a lot
> of corners to be sure we get it right.  It's not real clear to me how you
> go about finding all the affected timers sanely from sigaction.

My idea was to dequeue the timer signal and put it into some separate
"check me on unignore" queue. That's the easy part. The nasty part is
to rearm the timer without running into locking madness.

Thanks,

	tglx

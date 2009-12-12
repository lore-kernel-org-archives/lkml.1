Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZLMBPD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZLMBPD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:15:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932142AbZLMBPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:15:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36346 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932139AbZLMBO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:14:59 -0500
Date: Sat, 12 Dec 2009 15:17:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <gregkh@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
References: <20091211232805.GA10652@kroah.com> <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain> <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 12 Dec 2009, Thomas Gleixner wrote:
> > 
> > Anybody willing to be the guinea-pig?
> 
> Replaced my patch with yours and it works the same way (except for the
> PREEMPT=n case)
> 
> Acked-and-Tested-by: Thomas Gleixner <tglx@linutronix.de>

Ok, I also decided to just test it myself too (after applying the tty 
layer fix) and it doesn't seem to cause any problems, so I've committed 
it.

If there is dubious BKL usage that triggers the new might_sleep() warning 
(and it turns out that it's necessary and not really fixable), we can 
always just remove it again. But on the other hand, maybe it shows some 
other potential problems that should just be fixed.

We've had quite a bit of BKL work this merge-window. Maybe we'll even get 
rid of it one of these days. There are "only" about 600 instances of 
"lock_kernel()" in the tree right now ;)

				Linus

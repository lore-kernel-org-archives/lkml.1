Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZLMSRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZLMSRr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZLMSRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:17:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57228 "HELO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753749AbZLMSRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:17:45 -0500
Date: Sun, 13 Dec 2009 19:17:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213181726.GA14558@elte.hu>
References: <20091212101032.GB25286@elte.hu>
 <20091212023603.93768833.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
 <20091212214235.31429790@lxorguk.ukuu.org.uk>
 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
 <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
 <20091213065844.GA20244@elte.hu>
 <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 13 Dec 2009, Ingo Molnar wrote:
> > 
> > In the last ~4.5 years:
> > 
> >  earth4:~/tip> git checkout v2.6.12
> >  Date:   Fri Jun 17 12:48:29 2005 -0700
> >  earth4:~/tip> git grep -w unlock_kernel | wc -l
> >  713
> > 
> >  earth4:~/tip> git checkout linus
> >  Date:   Fri Dec 11 20:58:20 2009 -0800
> >  earth4:~/tip> git grep -w unlock_kernel | wc -l
> >  841
> 
> Git hint of the day: you don't need to check out a kernel to do "git 
> grep".
> 
> Do this:
> 
> 	git grep -w unlock_kernel v2.6.12 | wc
> 
> and it will JustWork(tm).

/me adds it to the metal toolbox

> > Also, a lot of BKL use was hidden before, and due to the BKL removal 
> > activities (by Thomas, Frederic, Jon, Alan and others) the remaining BKL using 
> > sites are a lot more well defined, a lot more isolated and thus a lot more 
> > removable than ever before.
> 
> That's the main thing. We've been pushing them down a lot.
> 
> We still have a few annoying core ones, though. I hate the execve() and file 
> locking ones.

When we did the BKL-as-a-mutex trick and let lockdep loose on it, three areas 
were particularly tricky: tty, reiser3 and NFS. tty and reiserfs should be ok 
now, but i havent seen much activity on the NFS front.

	Ingo

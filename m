Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZLMSdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZLMSdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZLMSdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:33:45 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:49442 "HELO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752561AbZLMSdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:33:43 -0500
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20091213181726.GA14558@elte.hu>
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
	 <20091213181726.GA14558@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 13:33:15 -0500
Message-Id: <1260729195.2612.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 2014 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 462FB821AA8B784339963FA3F72CCA0F4122DCB3
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 38 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 19:17 +0100, Ingo Molnar wrote: 
> When we did the BKL-as-a-mutex trick and let lockdep loose on it, three areas 
> were particularly tricky: tty, reiser3 and NFS. tty and reiserfs should be ok 
> now, but i havent seen much activity on the NFS front.

I've got a couple of NFS bkl removal patches queued up that I'll send on
to Linus today, but they will not suffice to fully remove BKL from the
NFS code.

The main remaining problem area is that of file locking (i.e. anything
that references inode->i_flock). I've started work on that, but a couple
of higher interrupts have prevented me from pulling it all together in
time for this merge window...

Trond


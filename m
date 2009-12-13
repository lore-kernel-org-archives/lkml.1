Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZLMTJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZLMTJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbZLMTJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:09:33 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:50398 "HELO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753909AbZLMTJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:09:32 -0500
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20091213190410.GA7297@nowhere>
References: <20091212023603.93768833.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
	 <20091212214235.31429790@lxorguk.ukuu.org.uk>
	 <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
	 <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
	 <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
	 <20091213065844.GA20244@elte.hu>
	 <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
	 <20091213181726.GA14558@elte.hu>  <20091213190410.GA7297@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Dec 2009 14:09:14 -0500
Message-Id: <1260731354.2612.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 9 msgs/h 1 sum rcpts/h 14 sum msgs/h 1 total rcpts 2023 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 55CC870E7E17DADA6451DDEBB53138A4DF238380
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 39 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-12-13 at 20:04 +0100, Frederic Weisbecker wrote: 
> In the above cases we have the following comment:
> 
> /* Protect inode->i_flock using the BKL */
> 
> And really it doesn't seem to protect anything else,
> fortunately it is acquired in a short path.

As I said in my reply, this is the tough one, because the BKL protection
is imposed by the VFS locking scheme used in fs/locks.c.

There is a similar dependency imposed upon fs/lockd/

I'm working on this, but I don't have anything ready for 2.6.33. 

> fs/nfs/super.c: unlock_kernel();
> fs/nfs/super.c: unlock_kernel();
> 
> Protect the mount/unmount path, a bit trickier there.
> 
> But really that looks way much easier to fix than it was
> with reiserfs.

All the other cases you list should be fixed in the GIT PULL request
that I just put out.

Trond


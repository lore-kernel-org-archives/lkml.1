Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYEKOqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYEKOqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754188AbYEKOqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:46:14 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37844 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbYEKOqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:46:14 -0400
Date: Sun, 11 May 2008 08:46:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sven Wegener <sven.wegener@stealer.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080511144611.GV19219@parisc-linux.org>
References: <20080508144316.GA9869@elte.hu> <20080508151028.GA12109@elte.hu> <20080511110306.GP19219@parisc-linux.org> <20080511114803.GA8289@parisc-linux.org> <20080511125049.GA22513@elte.hu> <20080511125216.GA25040@elte.hu> <20080511130226.GR19219@parisc-linux.org> <20080511135414.GA2328@elte.hu> <20080511142222.GU19219@parisc-linux.org> <20080511143227.GA3220@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080511143227.GA3220@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 04:32:27PM +0200, Ingo Molnar wrote:
> 
> * Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > > the gain is rather obvious: two parallel up()s (or just up()s which 
> > > come close enough after each other) will wake up two tasks in 
> > > parallel. With your patch, the first guy wakes up and then it wakes 
> > > up the second guy. I.e. your patch serializes the wakeup chain, mine 
> > > keeps it parallel.
> > 
> > Yup.  I explained why that's actually beneficial in an earlier email.
> 
> but the problem is that by serializing the wakeup chains naively you 
> introduced a more than 50% AIM7 performance regression.

That's a different issue.  The AIM7 regression is to do with whether a
task that is currently running and hits a semaphore that has no current
holder but someone else waiting should be allowed to jump the queue.
No argument there; performance trumps theoretical fairness.

This issue is whether multiple sleepers should be woken up all-at-once
or one-at-a-time.  Here, you seem to be arguing for theoretical fairness
to trump performance.

(Let's be quite clear; this issue affects *only* multiple
sleepers and multiple wakes given to those sleepers.  ie
semaphores-being-used-as-completions and true counting semaphores).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

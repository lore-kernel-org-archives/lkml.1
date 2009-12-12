Return-Path: <linux-kernel-owner+w=401wt.eu-S1761690AbZLLKgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761690AbZLLKgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761641AbZLLKgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:36:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761525AbZLLKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:36:25 -0500
Date: Sat, 12 Dec 2009 02:36:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-Id: <20091212023603.93768833.akpm@linux-foundation.org>
In-Reply-To: <20091212101032.GB25286@elte.hu>
References: <20091211232805.GA10652@kroah.com>
	<20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
	<20091212101032.GB25286@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 11:10:32 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Seems to be quite .config-dependent.
> 
> My theory is that it's a race and that it's thus timing dependent. TTY 
> SMP details get stressed most during a particular point during bootup, 
> when all the mingetty's are starting up all at once and race with each 
> other.
> 
> If you are lucky to not hit the bug then, then the likelyhood is much 
> lower later on.
> 
> It would be nice if Alan posted his TTY stress-testing code. It could 
> potentially make this bug bisectable.
> 

I'm surprised that lockdep didn't notice that ab/ba I thought I saw. 
Maybe the do_tty_hangup()->tty_fasync() never happens.

The machine I can reproduce this on is at work and I'm not, until
Monday.  I'd try removing the files_lock() calls from tty_io.c, see if
that helps.

I had

[   71.553228] Warning: dev (tty1) tty->count(7) != #fd's(6) in tty_release_dev

come out once, then it went away.


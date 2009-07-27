Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZG0MVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZG0MVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 08:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZG0MVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 08:21:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44463 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbZG0MVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 08:21:12 -0400
Subject: Re: futexes: Still infinite loop in get_futex_key() in 2.6.31-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Rosenboom <jens@mcbone.net>
Cc: Sonny Rao <sonnyrao@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1248697004.7279.31.camel@fnki-nb00130>
References: <1248681637.7279.12.camel@fnki-nb00130>
	 <1248694266.6987.1594.camel@twins>  <1248697004.7279.31.camel@fnki-nb00130>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 27 Jul 2009 14:23:29 +0200
Message-Id: <1248697409.6987.1617.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 14:16 +0200, Jens Rosenboom wrote:
> On Mon, 2009-07-27 at 13:31 +0200, Peter Zijlstra wrote:
> > On Mon, 2009-07-27 at 10:00 +0200, Jens Rosenboom wrote:
> > > We have a problem with infinitely running processes on kernels at least
> > > since 2.6.29.4. It happens on a loaded machine after running for a
> > > couple of days,
> > 
> > What kinds of machine, i386? Could you please enable
> > CONFIG_FRAME_POINTER, these backtraces are quite mangled.
> 
> i686 or AMD dualcore Opteron to be exact. CONFIG_FRAME_POINTER is
> enabled, the complete kernel-config is attached, maybe some other
> debugging options are needed? But I copied just the part pertaining to
> the stuck process, maybe the complete log has the parts you are missing?

Ah, weird. The question of course is, does an x86_64 kernel suffer the
same problem?

> > >  that a "ps ax" seems to get stuck in get_futex_key while
> > > exiting. Sadly your patch 
> > 
> > Who's patch, and which patch? 7c8fa4f04ab956076605422d5ed37410893a8a73?
> > That was only regarding huge pages.
> 
> Yes, that is the one I was talking about and the commit message seemed
> to match what I was seeing here.

Are you in fact using huge pages?

> > The only loop in get_futex_key() appears to be the one around
> > get_user_pages_fast(), and I'm not quite sure how that could get stuck
> > like this.
> > 
> > Could it be glibc loops on futex_wake() returning -EFAULT?
> 
> How would I be able to check that?

strace the struck process I think, you'd see tons of sys_futex() calls
with FUTEX_WAKE* returning -EFAULT.

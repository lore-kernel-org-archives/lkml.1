Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbXIBU3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbXIBU3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbXIBU3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:29:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbXIBU3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:29:15 -0400
Date: Sun, 2 Sep 2007 13:28:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: jkosina@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386 and x86_64: randomize brk()
Message-Id: <20070902132847.5fc968b1.akpm@linux-foundation.org>
In-Reply-To: <46D9C935.3000701@gmail.com>
References: <Pine.LNX.4.64.0708301545100.4135@jikos.suse.cz>
	<8bd0f97a0708300701r1f36bc0anc45b9cad4a11f2ef@mail.gmail.com>
	<Pine.LNX.4.64.0708301620010.4135@jikos.suse.cz>
	<8bd0f97a0708300726h563808a6j2b2ef9adf805c109@mail.gmail.com>
	<Pine.LNX.4.64.0708301708590.4135@jikos.suse.cz>
	<20070830180538.b52b802d.akpm@linux-foundation.org>
	<46D9C935.3000701@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 01 Sep 2007 22:19:01 +0200 Franck Bui-Huu <vagabon.xyz@gmail.com> wrote:
> Hello Andrew,
> 
> Andrew Morton wrote:
> > On Thu, 30 Aug 2007 17:10:03 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:
> >> Andrew, do you still strongly oppose to having ARCH_HAS_RANDOMIZE_BRK 
> >> macro instead please?
> >>
> > 
> > Not strongly, but the general opinion seems to be that ARCH_HAS_FOO is
> > sucky.  It should at least be done in Kconfig rather than in .h, but even
> > better is just to implement the thing for all architectures.
> > 
> 
> Sorry for asking again but the initial poster haven't taken time to
> answer to my feedbacks...
> 
> What about using a weak function in that case ? It actually gives a
> default implementation in _one_ place and can be changed easily from
> a nop to something more complex later.

Yeah, weak functions are by far the cleanest way of doing this - they're
most elegant.  But they do add the overhead of an empty call/return, so
some thought needs to go into the tradeoff.

> Another point is that the current prototype of arch_randomize_brk()
> could be slightly improved IMHO.
> 
> The proposed prototype is:
> 
> 		    void arch_randomize_brk(void)
> 
> and I think it could be:
> 
> 		  unsigned long randomize_brk(unsigned long brk)
> 
> Because the current code of exec syscall is rather.. hmm "tricky",
> _hiding_ "current" global usage inside this function is error prone:
> if this function is moved later, its use of "current->mm" could
> reference the old mm process and it's hard to notice/fix.

Could be..

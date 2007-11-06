Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbXKFQG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbXKFQG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbXKFQGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:06:21 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:53004 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbXKFQGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:06:21 -0500
Date: Tue, 6 Nov 2007 17:07:55 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       jdike@karaya.com, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: UML defconfig building failed again
Message-ID: <20071106160755.GA8345@uranus.ravnborg.org>
References: <20071106114602.GB7652@hacking> <20071106141143.GI8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106141143.GI8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 02:11:43PM +0000, Al Viro wrote:
> On Tue, Nov 06, 2007 at 07:46:02PM +0800, WANG Cong wrote:
> > 
> > Hi, Jeff!
> > 
> > I used today's linus-tree and defconfig to compile uml, but it failed. Error messages are
> > things like:
> > 
> > In file included from include/asm/processor-generic.h:13,
> >                  from include/asm/processor.h:77,
> >                  from include/asm/thread_info.h:11,
> >                  from include/linux/thread_info.h:21,
> >                  from include/linux/preempt.h:9,
> >                  from include/linux/spinlock.h:49,
> >                  from include/linux/seqlock.h:29,
> >                  from include/linux/time.h:8,
> >                  from include/linux/timex.h:57,
> >                  from include/linux/sched.h:53,
> >                  from arch/um/include/sysdep/kernel-offsets.h:2,
> >                  from arch/um/kernel/asm-offsets.c:1:
> > include/asm/ptrace.h:50: warning: ???struct user_fxsr_struct??? declared inside parameter list
> > include/asm/ptrace.h:50: warning: its scope is only this definition or declaration, which is probably not what you want
> > include/asm/ptrace.h:52: warning: ???struct user_fxsr_struct??? declared inside parameter list
> > In file included from include/linux/timer.h:5,
> >                  from include/linux/sched.h:87,
> >                  from arch/um/include/sysdep/kernel-offsets.h:2,
> >                  from arch/um/kernel/asm-offsets.c:1:
> > include/linux/ktime.h: In function ???ktime_set???:
> > include/linux/ktime.h:84: warning: comparison is always false due to limited range of data type
> > 
> > {snip}
> > 
> > It seems like CONFIG_X86_32 was not set. Any ideas?
> 
> Sigh...  Kbuild breakage this time...  See if %s/\<[AC]FLAGS\>/KBUILD_&/g
> in arch/um/Makefile-i386 helps.
Ups - my bad.
I have somehow overlooked those two assignments in the middle.

	Sam

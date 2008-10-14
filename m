Return-Path: <linux-kernel-owner+w=401wt.eu-S1757729AbYJNCRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbYJNCRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 22:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYJNCRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 22:17:08 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:54895 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbYJNCRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 22:17:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABid80hMQWq+/2dsb2JhbACBcrs1gWw
Date: Mon, 13 Oct 2008 22:17:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64: Optimized immediate value implementation build error
Message-ID: <20081014021704.GA15549@Krystal>
References: <20081003201007.GA16025@Krystal> <20081013.011525.31258522.davem@davemloft.net> <20081013233752.GA7866@Krystal> <20081013.183134.193695176.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081013.183134.193695176.davem@davemloft.net>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:12:30 up 131 days,  6:52,  9 users,  load average: 1.76, 0.93,
	0.79
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller (davem@davemloft.net) wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date: Mon, 13 Oct 2008 19:37:53 -0400
> 
> > * David Miller (davem@davemloft.net) wrote:
> > > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > Date: Fri, 3 Oct 2008 16:10:07 -0400
> > > 
> > > > I ran a cross-compiler on the -lttng tree
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
> > > > 
> > > > to build the sparc64 arch, and ran across this build error :
> > > > 
> > > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h: In function `do_fork':
> > > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: asm operand 1 probably doesn't match constraints
> > > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: error: impossible constraint in `asm'
> > > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: 'value' might be used uninitialized in this function
> > > > make[2]: *** [kernel/fork.o] Error 1
> > > > 
> > > > I think it's caused by :
> > > > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=c76bfa90a6eb02651368a152b3646aa672d9e625
> > > 
> > > It can't be "caused by" that commit because that's the initial
> > > immediate value sparc64 support I wrote and the tree very much compiled
> > > properly when I did test builds way back then.
> > > 
> > > I don't have time to look further into this right now, sorry.
> > 
> > Ok, I'll dig into this. I use gcc 3.4.5, that could be my problem; it's
> > broken on x86_64. I'll do some testing in this direction. Also, I see
> > that you have used .uaword and declared "int" in your sparc64
> > implementation to encode pointers. Am I missing something or should it
> > be "long" and either .word or .xword (32 or 64 bits) ?
> 
> long would be for ".uaxword", ".uaword" is 32-bit.  It means
> "UnAligned WORD"
> 

Ok, it's fixed.

If someone has access to a sparc64 gcc >= 4.0.0 compiler (native or
cross) and some spare cycles, if would be interesting to build test this
with CONFIG_IMMEDIATE=y and with CONFIG_TRACEPOINTS=y and
CONFIG_MARKERS=y :

git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
branch : 2.6.27-lttng-0.40

Regards,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753685AbYJNBcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685AbYJNBcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYJNBb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:31:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41572
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751545AbYJNBb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:31:57 -0400
Date: Mon, 13 Oct 2008 18:31:34 -0700 (PDT)
Message-Id: <20081013.183134.193695176.davem@davemloft.net>
To: mathieu.desnoyers@polymtl.ca
Cc: linux-kernel@vger.kernel.org
Subject: Re: sparc64: Optimized immediate value implementation build error
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081013233752.GA7866@Krystal>
References: <20081003201007.GA16025@Krystal>
	<20081013.011525.31258522.davem@davemloft.net>
	<20081013233752.GA7866@Krystal>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 13 Oct 2008 19:37:53 -0400

> * David Miller (davem@davemloft.net) wrote:
> > From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Date: Fri, 3 Oct 2008 16:10:07 -0400
> > 
> > > I ran a cross-compiler on the -lttng tree
> > > git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
> > > 
> > > to build the sparc64 arch, and ran across this build error :
> > > 
> > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h: In function `do_fork':
> > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: asm operand 1 probably doesn't match constraints
> > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: error: impossible constraint in `asm'
> > > /home/compudj/git/morestable/linux-2.6-lttng/include/trace/sched.h:38: warning: 'value' might be used uninitialized in this function
> > > make[2]: *** [kernel/fork.o] Error 1
> > > 
> > > I think it's caused by :
> > > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git;a=commit;h=c76bfa90a6eb02651368a152b3646aa672d9e625
> > 
> > It can't be "caused by" that commit because that's the initial
> > immediate value sparc64 support I wrote and the tree very much compiled
> > properly when I did test builds way back then.
> > 
> > I don't have time to look further into this right now, sorry.
> 
> Ok, I'll dig into this. I use gcc 3.4.5, that could be my problem; it's
> broken on x86_64. I'll do some testing in this direction. Also, I see
> that you have used .uaword and declared "int" in your sparc64
> implementation to encode pointers. Am I missing something or should it
> be "long" and either .word or .xword (32 or 64 bits) ?

long would be for ".uaxword", ".uaword" is 32-bit.  It means
"UnAligned WORD"


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYJWNiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYJWNiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJWNh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:37:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48742 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbYJWNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:37:25 -0400
Message-Id: <20081023133256.926296694@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 23 Oct 2008 09:32:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH 00/12 v3] ftrace: clean ups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
  Changes since v2:

   Typo corrections suggested by Wenji Huang.

   Removed adding notrace to init sections. Right now it should not
   be an issue. If we deem that it is, we can add the patch later.
   It's a performance patch, but I have yet to measure if the improvement
   is even measurable.
]

This is a series of patches to make ftrace more robust and clean ups.

The first couple of patches fix the recordmount.pl script and changes
it to only record the .text section functions. This means that
the init sections will not be processed.

A FTRACE_WARN_ON is added to change all WARN_ONS to not only print a
warning, but also to disable ftrace as well.

The later patches are a bit more drastic. Since the daemon is error prone,
I stripped it out. In doing so, I have to disable dynamic ftrace from all
archs that use it.  The archs can get dynamic ftrace reenabled when they
are ported to the recordmcount.pl method. (Arch maintainers, please contact
me if you want help. I can do it with some information about your arch).

Since the hash was created to work with the daemon, that too was stripped
out, making the remaining code smaller and cleaner. The kprobe hooks
in ftrace may need to be reworked.

Thanks goes to Andrew Morton for his comments on the code as well as
the spelling corrections made by Wenji Huang.

-- Steve


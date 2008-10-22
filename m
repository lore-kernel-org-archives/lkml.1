Return-Path: <linux-kernel-owner+w=401wt.eu-S1758516AbYJVSw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516AbYJVSw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758010AbYJVSvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:51:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62167 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYJVSvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:51:37 -0400
Message-Id: <20081022184313.179487464@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 14:43:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 00/11] ftrace: clean ups and fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches to make ftrace more robust and clean ups.

The first couple of patches fix the recordmount.pl script and changes
it to only record the .text section functions. This means that
the init sections will not be processed.

I still have a patch to add notrace to the init sections, and not for
safety reasons, but for perfomance. Since the init sections will not be
processed, they will still call mcount. Note, mcount is just a ret,
but why have the init code waste CPU cycles to call a stub function?

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

-- Steve


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755191AbYHPBq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbYHPBq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 21:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753175AbYHPBqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 21:46:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbYHPBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 21:46:49 -0400
Message-Id: <20080816014003.978160137@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 21:40:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 0/2] ftrace updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the new mcount recording method, the assumptions about the records
that hold the mcount locations have changed.  Now we need to protect
reading and writing of the records between module load and reading of the
debugfs files. There is not much contention here, but they need to be
protected none the less.

I simply use the ftrace_lock to accomplish this. The ftrace_lock should
never be held under interrupt context so disabling interrupts should
not be necessary. I've run this under lockdep and lockdep has not
complained.

-- Steve


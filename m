Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYJDGCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYJDGCX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 02:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYJDGCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 02:02:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60838 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYJDGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 02:02:13 -0400
Message-Id: <20081004060057.660306328@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 04 Oct 2008 02:00:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: [PATCH 0/3] ring-buffer: less locking and only disable preemption
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

These patches need to be put through the ringer. Could you add them
to your ring-buffer branch, so we can test them out before putting
them into your master branch.

The following patches bring the ring buffer closer to a lockless
solution. They move the locking only to the actual moving the
tail/write pointer from one page to the next. Interrupts are now
enabled during most of the writes.

A lot of the locking protection is still within the ftrace infrastructure.
The last patch takes some of that away.

The function tracer cannot be reentrant just due to the nature that
it traces everything, and can cause recursion issues.

-- Steve


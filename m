Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbYKSFeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbYKSFeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 00:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYKSFeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 00:34:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbYKSFeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 00:34:09 -0500
Message-Id: <20081119053335.212100883@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 19 Nov 2008 00:33:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/0] ftrace updates to tip/core/urgent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

I ported the following patches to tip/core/urgent since they are candidates
for 2.6.28.

The first two are trivial, short, and should not be an issue. The first
two handle the printing of the set_ftrace_filter file correctly.

The third is a bigger patch "108 lines changed" and is actually a
clean up and fix.  The difference is that the current logic to
determine if a function should be enabled or not is incorrect.
With different combinations of using set_ftrace_filter and
set_ftrace_notrace, incorrect functions may be traced, or not traced.

But this bug that the patch fixes is not a critical bug. It should not
cause any stability problems with the kernel. The bug will only
produce undesirable traces.

But on the other hand, adding that last patch should not cause any
stability issues as well. And it makes the complex function cleaner
and more importantly, by coupling the ENABLED flag of the record
with the enabling (or disabling) of the tracing of the function
the record represents, makes the code more robust.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

      branch: tip/urgent


Steven Rostedt (3):
      ftrace: fix set_ftrace_filter
      ftrace: make filtered functions effective on setting
      ftrace: fix dyn ftrace filter selection

----
 kernel/trace/ftrace.c |  113 +++++++++++++++++++++++-------------------------
 1 files changed, 54 insertions(+), 59 deletions(-)

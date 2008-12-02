Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYLBUeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYLBUeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYLBUe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34745 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] ftrace updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here's some more ftrace updates.

The first should help fix the bug in lockdep.

The next are changes to the ring buffer to get ready to have it
work with splice.

The last are some clean ups for function graph.


The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (5):
      ftrace: replace raw_local_irq_save with local_irq_save
      ring-buffer: move some metadata into buffer page
      ring-buffer: read page interface
      ftrace: clean up function graph asm
      ftrace: have function graph use mcount caller address

----
 arch/x86/kernel/entry_32.S  |    1 +
 arch/x86/kernel/entry_64.S  |    1 +
 arch/x86/kernel/ftrace.c    |   20 +---
 include/linux/ring_buffer.h |    5 +
 kernel/lockdep.c            |    1 +
 kernel/trace/ring_buffer.c  |  229 ++++++++++++++++++++++++++++++++++++++-----
 kernel/trace/trace.c        |   12 +-
 kernel/trace/trace_branch.c |    4 +-
 kernel/trace/trace_stack.c  |    8 +-
 9 files changed, 226 insertions(+), 55 deletions(-)
-- 

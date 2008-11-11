Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYKKUKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYKKUKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 15:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYKKUKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 15:10:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbYKKUKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 15:10:36 -0500
Message-Id: <20081111200601.147669239@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 11 Nov 2008 15:06:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
Subject: [PATCH 0/1] ring-buffer: disable tracing switch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen and Ingo,

I've been pressured into making this patch for mainline. It is a low risk
patch, but I would like to get it into linux-next.

This patch adds a way for a kernel developer to stop all tracers from
within the kernel and restart it from userspace. The previous APIs that
allowed for kernel stopping the tracer did not allow for userspace to
restart. This was mainly because the stopping could be for areas that
are dangerous to be tracing, and allowing userspace to start them could
risk the system stability.

This switch is made to let userspace interact with the kernel space
in starting and stopping tracers.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Steven Rostedt (1):
      ring-buffer: buffer record on/off switch

----
 include/linux/ring_buffer.h |    3 +
 kernel/trace/ftrace.c       |    8 +---
 kernel/trace/ring_buffer.c  |  101 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+), 6 deletions(-)

-- 

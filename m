Return-Path: <linux-kernel-owner+w=401wt.eu-S1757315AbYKUUbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315AbYKUUbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 15:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYKUUbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 15:31:04 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbYKUUbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 15:31:03 -0500
Message-Id: <20081121202932.281682721@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Nov 2008 15:29:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/5] ftrace: recordmcount for sh and arm, plus permanent disable API
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first two patches are changes to recordmcount.pl that I've tested
to make sure they do not break x86 or PPC. These are changes that are
needed for sh and ARM. I do not include the changes needed in the arch
itself, those need to go through the arch maintainers.

The other patches are for the permanent disabling of the tracer and
ring buffer.

I know you prefered having the ring buffer disable flag be 0 1 -1
for off, on, and disable respectively, but this becomes a problem
to implement safely for all archs. What I did instead was to have
two bits in the flags. On is a simple on/off bit for the users to
use, the other is a set once flag that will permantly disable the
ring buffers once set. This allows me to use the set/clear bit API
that works on all architectures nicely. And I personally find this
easier to understand.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Jim Radford (1):
      ftrace: mcountrecord.pl for arm

Matt Fleming (1):
      ftrace: Specify $alignment for sh architecture

Steven Rostedt (3):
      ring-buffer: add tracing_off_permanent
      ftrace: add ftrace_off_permanent
      trace: fix compiler warning in branch profiler

----
 include/linux/ftrace.h      |    2 +
 include/linux/ring_buffer.h |    1 +
 kernel/trace/ring_buffer.c  |   79 ++++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c        |   15 ++++++++
 kernel/trace/trace_branch.c |   10 +++---
 scripts/recordmcount.pl     |   11 +++++-
 6 files changed, 98 insertions(+), 20 deletions(-)

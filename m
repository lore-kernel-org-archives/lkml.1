Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbYKKDFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbYKKDFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYKKDFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:05:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45038 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbYKKDFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:05:20 -0500
Message-Id: <20081111025808.946638585@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 10 Nov 2008 21:58:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/2] ftrace updates for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen and Ingo,

The following patches are needed for 2.6.28. The first one solves a bug
where the resizing of the buffer array was not protected against
modifications by ftrace.

The second patch solves an issue tha Thomas Gleixner was seeing where
the tracer would detect the infinite recursion too easily by
tracing the timer code. This patch prevents the loop from happening
and still does not lose any trace entries.

The changes caused by these patches are low in risk, but I would
still like to put them through linux-next before passing them
off to Linus.

Note, these changes are based against Linus's mainline and not tip.
Also note that the branch in this tree is "devel" and not "tip/devel".

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: devel


Steven Rostedt (2):
      ftrace: disable tracing on resize
      ring-buffer: prevent infinite looping on time stamping

----
 kernel/trace/ring_buffer.c |    2 +-
 kernel/trace/trace.c       |   17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

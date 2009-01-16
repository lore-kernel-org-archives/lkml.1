Return-Path: <linux-kernel-owner+w=401wt.eu-S1764257AbZAPAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764257AbZAPAlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZAPAlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:41:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35982 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbZAPAlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:41:23 -0500
Message-Id: <20090116004050.273665842@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 15 Jan 2009 19:40:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 0/2] ftrace: updates to tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

The first patch is critical, and needs to stay with trace_output.c
Not that critical since trace_output.c is not in mainline yet.

The second patch gives the ability to stack trace functions.
I've been leery about adding this and still keep it a separate
option from the "stacktrace" that already exists. This is because
when enabled with no filtering, the lag between typing and seeing
what is typed can be up to 10 seconds or more.

I made the function stack trace an option attached to the function
tracer, so it must be enabled after the function tracer has been
set. This still needs to be updated in ftrace.txt.

The following patches are in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Lai Jiangshan (1):
      ftrace: fix trace_output

Steven Rostedt (1):
      ftrace: add stack trace to function tracer

----
 kernel/trace/trace.c           |   26 ++++++++----
 kernel/trace/trace.h           |    7 +++
 kernel/trace/trace_functions.c |   84 ++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.c    |   65 +++++++++++++++----------------
 kernel/trace/trace_output.h    |    4 +-
 5 files changed, 141 insertions(+), 45 deletions(-)

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S964979AbZLGUWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964979AbZLGUWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964930AbZLGUWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:22:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964894AbZLGUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:22:04 -0500
Message-Id: <20091207201903.864817226@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Dec 2009 15:19:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/4] [GIT PULL] tracing: fix function graph tracer output
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is rebased to latest Linus repo. As Jirka found, the function graph
tracer can lose events or show incorrectly a nested function when it
should have been a leaf. This patch series corrects the issue.

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Jiri Olsa (1):
      tracing: Fix function graph trace_pipe to properly display failed entries

Johannes Berg (1):
      tracing: Add full state to trace_seq

Steven Rostedt (2):
      tracing: Add pipe_close interface
      tracing: Buffer the output of seq_file in case of filled buffer

----
 include/linux/ftrace_event.h         |    1 +
 include/linux/trace_seq.h            |    6 +-
 kernel/trace/trace.c                 |   39 ++++++++-
 kernel/trace/trace.h                 |    2 +
 kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
 kernel/trace/trace_output.c          |   75 +++++++++++++---
 6 files changed, 235 insertions(+), 53 deletions(-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757950AbZLIUvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950AbZLIUvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 15:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbZLIUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 15:51:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32858 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864AbZLIUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 15:51:08 -0500
X-Authority-Analysis: v=1.0 c=1 a=lk2jcrLxByQA:10 a=VwQbUJbxAAAA:8 a=0-T6pB8e3dVYUkB9UW0A:9 a=DPumEe3yAB5HMH0qrgcA:7 a=H8T1JtnjYu4Cv2V7UGCEuG5TbLIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20091209204035.871524827@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 09 Dec 2009 15:40:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/5] [GIT PULL] tracing: Fixes for function graph and trace_printk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This is a rework of the patches last sent. It is based on commit:

  c521efd1700a8c0f7ce26f011f5eaecca17fabfa
  tracing: Add pipe_close interface

and starts with a fix to the cut and paste bug. I compiled each patch
with and without CONFIG_TRACING enabled.

Please pull the latest tip/tracing/core3 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core3


Carsten Emde (1):
      tracing: Remove comparing of NULL to va_list in trace_array_vprintk()

Jiri Olsa (1):
      tracing: Fix function graph trace_pipe to properly display failed entries

Johannes Berg (1):
      tracing: Add full state to trace_seq

Steven Rostedt (2):
      tracing: Only call pipe_close if pipe_close is defined
      tracing: Buffer the output of seq_file in case of filled buffer

----
 include/linux/ftrace_event.h         |    1 +
 include/linux/trace_seq.h            |    7 +-
 kernel/trace/trace.c                 |   55 +++++++++--
 kernel/trace/trace_functions_graph.c |  165 +++++++++++++++++++++++++++-------
 kernel/trace/trace_output.c          |   75 +++++++++++++---
 5 files changed, 243 insertions(+), 60 deletions(-)



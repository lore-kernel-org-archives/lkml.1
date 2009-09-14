Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZINKOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZINKOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZINKOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:14:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1673 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINKOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:14:18 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] tracing - signal tracer, support multiple pids in set_pid_ftrace
Date: Mon, 14 Sep 2009 12:14:09 +0200
Message-Id: <1252923251-6735-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was debugging some ptrace applications and got to the idea of 
tracing signals - signal tracer. There's probably possibility to 
trace more info than just signal delivery info (like ignored 
signals deliveries, queue status...).

While doing this I realized it might be worth to have ability to trace 
more independent processes via set_pid_ftrace file.

Althought I'm sending this as RFC, attached patches work for me. 
I'm open to any suggestions/comments/ideas.

1/2 - signal trace
2/2 - multiple pids support for set_pid_ftrace file

thanks,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/signaltrace.h |   22 ++++
 include/linux/tracehook.h   |   14 +++
 kernel/signal.c             |    3 +
 kernel/trace/Kconfig        |   11 ++
 kernel/trace/Makefile       |    1 +
 kernel/trace/ftrace.c       |  226 +++++++++++++++++++++++++++++++------------
 kernel/trace/trace.h        |   13 ++-
 kernel/trace/trace_signal.c |  132 +++++++++++++++++++++++++
 8 files changed, 356 insertions(+), 66 deletions(-)

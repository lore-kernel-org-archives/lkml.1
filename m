Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZG1Vzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZG1Vzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZG1Vzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:55:38 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:44231 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbZG1Vzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:55:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qrZh+5UyHd3aZnLqI7df+kqo1Ab30S/A2/d+iaB9+x5Xi026ZovYiUy9YjtKZTbztC
         cY9BGrzJXj643ikp7x5tjsaztpy9+9TYJf/zwKAONTF512uWk3PLHpOYlZUcJjrW7cqV
         BhwHuB7QSuEsuyne57aVsAa5JSjofm4r2CAPw=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 0/2] tracing/function_graph fixes for 2.6.31
Date: Tue, 28 Jul 2009 23:55:32 +0200
Message-Id: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Thomas,

Those are two fixes for the function graph tracer for .31

The first one fixes a possible race condition between a function graph trace
reader and ring buffer writers, leading to a mixup inside an event entry, or
worst.

The second one fixes some issues in the output of the function graph tracer
while using splice on the trace_pipe file or ftrace_dump().

Both fixes should also be backported on .30 for the -stable branch.

Thanks,
Frederic.

The following changes since commit 4733fd328f14280900435d9dbae1487d110a4d56:
  Benjamin Herrenschmidt (1):
        mm: Remove duplicate definitions in MIPS and SH

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/fixes

Lai Jiangshan (2):
      tracing: Fix invalid function_graph entry
      tracing: Fix missing function_graph events when we splice_read from trace_pipe

 kernel/trace/trace.c                 |   10 +++++++---
 kernel/trace/trace_functions_graph.c |   11 +++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

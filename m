Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbZIRFgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbZIRFgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 01:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZIRFgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 01:36:19 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:52211 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZIRFgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 01:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qVZYDkwP69WKiN8ra3jRAv2SD6tlVBDe5dlbWEwvfSXvoKvUmQHp4Uph0A3K5p41W1
         gt2/RXgaSVW5EtjxaIUbRI4xXAWEMwFm53W30BPBUT9hEXrH74fuS09I4zQTO+MlBEDT
         Zg/tsUF1ZqwEIVsjFPfQIwSmQ1zpQjwsugmz0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/2 v3] tracing: Tracing event profiling updates
Date: Fri, 18 Sep 2009 07:36:17 +0200
Message-Id: <1253252178-5315-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253247854-5496-1-git-send-email-fweisbec@gmail.com>
References: <1253247854-5496-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Hopefully this is my last attempt.
This new iteration fixes the syscalls events to correctly handle
the buffer. In the previous version, they did not care about interrupts.

I only resend the second patch as only this one has changed since the v2.

The new branch is in:
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/core-v3

Thanks,
	Frederic.

Frederic Weisbecker (2):
      tracing: Factorize the events profile accounting
      tracing: Allocate the ftrace event profile buffer dynamically

 include/linux/ftrace_event.h       |   10 +++-
 include/linux/syscalls.h           |   24 +++-----
 include/trace/ftrace.h             |  111 ++++++++++++++++++++---------------
 kernel/trace/trace_event_profile.c |   79 +++++++++++++++++++++++++-
 kernel/trace/trace_syscalls.c      |   97 +++++++++++++++++++++++++------
 5 files changed, 234 insertions(+), 87 deletions(-)

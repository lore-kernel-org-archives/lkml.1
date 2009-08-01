Return-Path: <linux-kernel-owner+w=401wt.eu-S1751876AbZHAHXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbZHAHXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbZHAHXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:23:32 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41469 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZHAHXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:23:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=p1fkPIGCMcF+vkTdpX47n/p3AWp5+9XMHURtDTZJr8/cmUcLbzaREJCIeHGBpcKwF9
         Mw0Aqoz7hgUeEcD7vK5Zh02I55FW30Dwz6cBB1X5zDivcLq+++MQGyAzov7yi78W2TGg
         zgz+Kx6lrE/iSAq/U2DR0I+1JiKaIWhzJY0P8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][GIT PULL] bkl ftrace events + filter regex support
Date: Sat,  1 Aug 2009 09:23:23 +0200
Message-Id: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset provides the support for bkl tracing, with the
support of regex in ftrace filters, so that one can easily filter
the bkl event traces per subsystem/directory/file.

Thanks,
Frederic.


The following changes since commit d34a4debef933061924ee17c2ede33f5c44925fb:
  jolsa@redhat.com (1):
        tracing: Remove .globl in the scripts/recordmcount.pl doc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/bkl

Frederic Weisbecker (5):
      tracing/bkl: Add bkl ftrace events
      tracing/event: Cleanup the useless dentry variable
      tracing/filters: Cleanup useless headers
      tracing/filters: Provide basic regex support
      tracing/filters: Provide support for char * pointers

 include/linux/smp_lock.h           |   19 +++-
 include/trace/events/bkl.h         |   61 +++++++++++
 kernel/trace/trace.h               |   33 ++++--
 kernel/trace/trace_events.c        |  106 +++++++++++++++-----
 kernel/trace/trace_events_filter.c |  192 +++++++++++++++++++++++++++++-------
 lib/kernel_lock.c                  |   11 +-
 6 files changed, 340 insertions(+), 82 deletions(-)
 create mode 100644 include/trace/events/bkl.h

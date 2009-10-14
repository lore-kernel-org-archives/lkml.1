Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZJNHAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZJNHAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756149AbZJNHAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:00:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:37417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756085AbZJNHAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:00:35 -0400
Date: Wed, 14 Oct 2009 06:59:27 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jolsa@redhat.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091013203426.175845614@goodmis.org>
References: <20091013203426.175845614@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Enable "__cold" functions
Message-ID: <tip-4d8289494a37e19cd7f3beacea9c957ad3debad6@git.kernel.org>
Git-Commit-ID: 4d8289494a37e19cd7f3beacea9c957ad3debad6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 06:59:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d8289494a37e19cd7f3beacea9c957ad3debad6
Gitweb:     http://git.kernel.org/tip/4d8289494a37e19cd7f3beacea9c957ad3debad6
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 13 Oct 2009 16:33:54 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Oct 2009 08:13:54 +0200

tracing: Enable "__cold" functions

Based on the commit:

  a586df06 "x86: Support __attribute__((__cold__)) in gcc 4.3"

some of the functions goes to the ".text.unlikely" section.

Looks like there's not many of them (I found printk, panic,
__ssb_dma_not_implemented, fat_fs_error), but still worth to
include I think.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20091013203426.175845614@goodmis.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 scripts/recordmcount.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 090d300..bfb8b2c 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -119,6 +119,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".text.unlikely" => 1,
 );
 
 $objdump = "objdump" if ((length $objdump) == 0);

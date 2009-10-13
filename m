Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbZJMUgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbZJMUgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761279AbZJMUgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:36:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54673 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761259AbZJMUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:36:24 -0400
Message-Id: <20091013203426.175845614@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 16:33:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5/5] [PATCH 5/5] tracing: enabling "__cold" functions
References: <20091013203349.814936710@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-enabling-__cold-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Based on the commit:

a586df06 "x86: Support __attribute__((__cold__)) in gcc 4.3"

some of the functions goes to the ".text.unlikely" section.

Looks like there's not many of them (I found printk, panic,
__ssb_dma_not_implemented, fat_fs_error), but still worth
to include I think.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1255104899-27784-1-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
-- 
1.6.3.3



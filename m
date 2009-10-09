Return-Path: <linux-kernel-owner+w=401wt.eu-S933897AbZJIQPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897AbZJIQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933828AbZJIQPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:15:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933799AbZJIQPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:15:40 -0400
From: jolsa@redhat.com
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] tracing - enabling "__cold" functions
Date: Fri,  9 Oct 2009 18:14:59 +0200
Message-Id: <1255104899-27784-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the commit:

a586df06 "x86: Support __attribute__((__cold__)) in gcc 4.3"

some of the functions goes to the ".text.unlikely" section.

Looks like there's not many of them (I found printk, panic,
__ssb_dma_not_implemented, fat_fs_error), but still worth
to include I think.

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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

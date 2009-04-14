Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZDNKEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZDNKEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbZDNKCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:02:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:45881 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755881AbZDNKCq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:02:46 -0400
Date: Tue, 14 Apr 2009 10:02:05 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E43282.1090607@kernel.org>
References: <49E43282.1090607@kernel.org>
Subject: [tip:x86/mm] x86: remove (null) in /sys kernel_page_tables
Message-ID: <tip-6424fb38667fffbbb1b90be0ffd9a0c540db6a4b@git.kernel.org>
Git-Commit-ID: 6424fb38667fffbbb1b90be0ffd9a0c540db6a4b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:02:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6424fb38667fffbbb1b90be0ffd9a0c540db6a4b
Gitweb:     http://git.kernel.org/tip/6424fb38667fffbbb1b90be0ffd9a0c540db6a4b
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 13 Apr 2009 23:51:46 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:50:22 +0200

x86: remove (null) in /sys kernel_page_tables

Impact: cleanup

%p prints out 0x000000000000000 as (null)
so use %lx instead.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49E43282.1090607@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/dump_pagetables.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index e7277cb..a725b7f 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -161,13 +161,14 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
+		int width = sizeof(unsigned long) * 2;
 
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%p-0x%p   ",
-			   (void *)st->start_address,
-			   (void *)st->current_address);
+		seq_printf(m, "0x%0*lx-0x%0*lx   ",
+			   width, st->start_address,
+			   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {

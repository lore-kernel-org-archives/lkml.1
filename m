Return-Path: <linux-kernel-owner+w=401wt.eu-S933241AbXGaSXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbXGaSXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764960AbXGaSW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:22:56 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1669 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759725AbXGaSWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:22:55 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 42] fs/jbd2/journal.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:22:54 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       sct@redhat.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312022.54957.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/jbd2/journal.c | 66771 -> 66719 (-52 bytes)
 fs/jbd2/journal.o | 199193 -> 199049 (-144 bytes)

 fs/jbd2/journal.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/jbd2/journal.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/jbd2/journal.c	2007-07-31 14:55:12.000000000 +0200
@@ -929,17 +929,16 @@ static void journal_init_stats(journal_t
 {
 	int size;

-	if (proc_jbd2_stats == NULL)
+	if (!proc_jbd2_stats)
 		return;

 	journal->j_history_max = 100;
 	size = sizeof(struct transaction_stats_s) * journal->j_history_max;
-	journal->j_history = kmalloc(size, GFP_KERNEL);
-	if (journal->j_history == NULL) {
+	journal->j_history = kzalloc(size, GFP_KERNEL);
+	if (!journal->j_history) {
 		journal->j_history_max = 0;
 		return;
 	}
-	memset(journal->j_history, 0, size);
 	spin_lock_init(&journal->j_history_lock);
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbYLVV7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbYLVV7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYLVVtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:39 -0500
Received: from cantor.suse.de ([195.135.220.2]:41657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035AbYLVVth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:37 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 28/56] jbd2: Add BH_JBDPrivateStart
Date: Mon, 22 Dec 2008 13:48:09 -0800
Message-Id: <1229982517-3455-29-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this so that file systems using JBD2 can safely allocate unused b_state
bits.

In this case, we add it so that Ocfs2 can define a single bit for tracking
the validation state of a buffer.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/jbd2.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index c7d106e..f366457 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -329,6 +329,7 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_JBDPrivateStart,	/* First bit available for private use by FS */
 };
 
 BUFFER_FNS(JBD, jbd)
-- 
1.5.6


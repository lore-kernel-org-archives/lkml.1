Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYI3HtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYI3HtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753040AbYI3Hmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:42:52 -0400
Received: from smtp.nokia.com ([192.100.105.134]:18985 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbYI3HmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:42:02 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: linux-fsdevel@vger.kernel.org
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH] UBIFS: check data CRC when in error state
Date: Tue, 30 Sep 2008 12:19:04 +0300
Message-Id: <1222766358-21886-9-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
References: <1222766358-21886-1-git-send-email-dedekind@infradead.org>
X-OriginalArrivalTime: 30 Sep 2008 07:41:36.0741 (UTC) FILETIME=[F7C7C950:01C922CF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

When UBIFS switches to R/O mode because of an error,
it is reasonable to enable data CRC checking.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/ubifs/io.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 40e2790..0168271 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -62,6 +62,7 @@ void ubifs_ro_mode(struct ubifs_info *c, int err)
 {
 	if (!c->ro_media) {
 		c->ro_media = 1;
+		c->no_chk_data_crc = 0;
 		ubifs_warn("switched to read-only mode, error %d", err);
 		dbg_dump_stack();
 	}
-- 
1.5.4.1


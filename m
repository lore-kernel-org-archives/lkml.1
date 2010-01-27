Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174Ab0A0K6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab0A0K6B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 05:58:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806Ab0A0K6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 05:58:00 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:44111 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab0A0K57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 05:57:59 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 2/2] PM / Hibernate: swap, remove useless check from swsusp_read
Date: Wed, 27 Jan 2010 11:57:55 +0100
Message-Id: <1264589875-17045-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1264589875-17045-1-git-send-email-jslaby@suse.cz>
References: <1264589875-17045-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will never reach here if the sws_resume_bdev is erratic.
swsusp_read is called only from software_resume, but after
swsusp_check which would catch the error state.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/power/swap.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 09b2b0a..1d57573 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -657,10 +657,6 @@ int swsusp_read(unsigned int *flags_p)
 	struct swsusp_info *header;
 
 	*flags_p = swsusp_header->flags;
-	if (IS_ERR(resume_bdev)) {
-		pr_debug("PM: Image device not initialised\n");
-		return PTR_ERR(resume_bdev);
-	}
 
 	memset(&snapshot, 0, sizeof(struct snapshot_handle));
 	error = snapshot_write_next(&snapshot, PAGE_SIZE);
-- 
1.6.6.1


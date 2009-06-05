Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZFEIIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZFEIIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZFEIFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:05:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37464 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZFEIFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <rgetz@blackfin.uclinux.org>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 05/62] Blackfin: allow scheduler functions to be placed into L1
Date: Fri,  5 Jun 2009 04:04:14 -0400
Message-Id: <1244189111-19639-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 arch/blackfin/kernel/vmlinux.lds.S |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 27952ae..8b67167 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -50,7 +50,9 @@ SECTIONS
 		_text = .;
 		__stext = .;
 		TEXT_TEXT
+#ifndef CONFIG_SCHEDULE_L1
 		SCHED_TEXT
+#endif
 		LOCK_TEXT
 		KPROBES_TEXT
 		*(.text.*)
@@ -180,6 +182,9 @@ SECTIONS
 		. = ALIGN(4);
 		__stext_l1 = .;
 		*(.l1.text)
+#ifdef CONFIG_SCHEDULE_L1
+		SCHED_TEXT
+#endif
 		. = ALIGN(4);
 		__etext_l1 = .;
 	}
-- 
1.6.3.1


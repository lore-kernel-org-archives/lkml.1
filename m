Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZA0Ss2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZA0Ss2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755725AbZA0SsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:48:20 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:33743 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753291AbZA0SsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:48:19 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       torvalds@linux-foundation.org, mjg@redhat.com, nicolas@boichat.ch,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] include/linux/mod_devicetable.h: fix compilation problem induced by MODULE_DEVICE_TABLE(dmi, ...)
Date: Tue, 27 Jan 2009 19:48:00 +0100
Message-Id: <1233082080-4340-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20090126225909.0937356c.akpm@linux-foundation.org>
References: <20090126225909.0937356c.akpm@linux-foundation.org>
X-Originating-IP: 83.248.192.132
X-Scan-Result: No virus found in message 1LRsyp-0006Lk-5c.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1LRsyp-0006Lk-5c f36ae73d78363b6f8a16cb6156c36549
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Bugzilla 12483:

Kernel build fails with gcc3 (not gcc4), because
MODULE_DEVICE_TABLE(dmi, ...) expands to extern const struct
dmi_device_id __mod_dmi_device_table, and struct dmi_device_id doesn't
exist.

Steps to reproduce:
Build kernel 2.6.28 or 2.6.29-rc2 on x86 with gcc 3.

This patch remedies the problem.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 include/linux/mod_devicetable.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 97b91d1..aec76e6 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -443,6 +443,7 @@ struct dmi_system_id {
 	struct dmi_strmatch matches[4];
 	void *driver_data;
 };
+#define dmi_device_id dmi_system_id
 #endif
 
 #define DMI_MATCH(a, b)	{ a, b }
-- 
1.5.6.3


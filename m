Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbZATURx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbZATURx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 15:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbZATURo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 15:17:44 -0500
Received: from mga05.intel.com ([192.55.52.89]:13423 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757088AbZATURn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 15:17:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,296,1231142400"; 
   d="scan'208";a="658676461"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: =?utf-8?q?Toralf=20F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Greg KH <greg@kroah.com>
Cc: wimax@linuxwimax.org, linux-kernel@vger.kernel.org
Subject: [PATCH] debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n
Date: Tue, 20 Jan 2009 12:17:28 -0800
Message-Id: <1232482648-2663-1-git-send-email-inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <200901200923.54060.toralf.foerster@gmx.de>
References: <200901200923.54060.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Toralf Förster <toralf.foerster@gmx.de> reported a build failure in
the WiMAX stack when CONFIG_DEBUG_FS=n

http://linuxwimax.org/pipermail/wimax/2009-January/000449.html

This is due to debugfs_create_size_t() missing an stub that returns
-ENODEV when the DEBUGFS subsystem is not configured in (like the rest
of the debugfs API).

This patch adds said stub.

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 include/linux/debugfs.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 23936b1..0f5c33b 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -162,6 +162,13 @@ static inline struct dentry *debugfs_create_x32(const char *name, mode_t mode,
 	return ERR_PTR(-ENODEV);
 }
 
+struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
+				     struct dentry *parent,
+				     size_t *value)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_bool(const char *name, mode_t mode,
 						 struct dentry *parent,
 						 u32 *value)
-- 
1.5.6.5


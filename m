Return-Path: <linux-kernel-owner+w=401wt.eu-S1763414AbZAUFWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763414AbZAUFWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 00:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbZAUFVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 00:21:12 -0500
Received: from kroah.org ([198.145.64.141]:53323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751841AbZAUFVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 00:21:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] debugfs: introduce stub for debugfs_create_size_t() when DEBUG_FS=n
Date: Tue, 20 Jan 2009 21:19:56 -0800
Message-Id: <1232515197-3974-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <20090121051855.GA3665@kroah.com>
References: <20090121051855.GA3665@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Inaky Perez-Gonzalez <inaky@linux.intel.com>

Toralf Förster <toralf.foerster@gmx.de> reported a build failure in
the WiMAX stack when CONFIG_DEBUG_FS=n

http://linuxwimax.org/pipermail/wimax/2009-January/000449.html

This is due to debugfs_create_size_t() missing an stub that returns
-ENODEV when the DEBUGFS subsystem is not configured in (like the rest
of the debugfs API).

This patch adds said stub.

Reported-by: Toralf Förster <toralf.foerster@gmx.de>
Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.0.4


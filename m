Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZFRSBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZFRSBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZFRSA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:00:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49712 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZFRSA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:00:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michal Simek <monstr@monstr.eu>
Cc: microblaze-uclinux@itee.uq.edu.au, LKML <linux-kernel@vger.kernel.org>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 01/11] ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
Date: Thu, 18 Jun 2009 19:55:25 +0200
Message-Id: <24d10c58e2739bacec05d641ab2a2c95ce6d69a9.1245347640.git.arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <cover.1245345894.git.arnd@arndb.de>
References: <cover.1245345894.git.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/sjy02fIII2fnjDVa8W1e5xc+kctrxKSqDyVQ
 hBLhQ2Ge33CCCmkoq8yGRWfWFBSK3NjCuu/n5HKs8XhOiirpKv
 yTY9NpBXRPZ454PaVHEBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of ipc_parse_version depends on
__ARCH_WANT_IPC_PARSE_VERSION, but the header file
declares it conditionally based on the architecture.

Use the macro consistently to make it easier to add
new architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 ipc/util.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ipc/util.h b/ipc/util.h
index 1187332..f9fe90e 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -128,7 +128,7 @@ void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
-#if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
+#ifndef __ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else
-- 
1.6.3.1


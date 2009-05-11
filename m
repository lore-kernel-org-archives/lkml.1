Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZEKXDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZEKXDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbZEKXDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:03:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:64731 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760427AbZEKXDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:03:18 -0400
Message-Id: <200905112302.04437.arnd@arndb.de>
References: <20090511222702.352192505@arndb.de>>
User-Agent: quilt/0.46-1
Date: Mon, 11 May 2009 23:02:04 +0000
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
Content-Disposition: inline
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19eKvz9CbcPgHxc3r2bdGBut7/HGbKG0yAiMOT
 3G+cwZM1dhEpEsO31c91tEBJCcINb9FEpwGLSRox8tc/MSOx+r
 Gk+mWAq2lQkFuAk2iKT+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The definition of ipc_parse_version depends on
__ARCH_WANT_IPC_PARSE_VERSION, but the header file
declares it conditionally based on the architecture.

Use the macro consistently to make it easier to add
new architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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
1.6.0.4

-- 



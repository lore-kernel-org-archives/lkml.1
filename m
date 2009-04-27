Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbZD0Oog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbZD0Oog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZD0Oln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:41:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbZD0Olf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:41:35 -0400
Message-Id: <20090427143739.102380235@arndb.de>
From: <arnd@arndb.de>
To: unlisted-recipients:; (no To-header on input)
Date: Mon, 27 Apr 2009 10:41:35 -0400
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From arnd@arndb.de Mon Apr 27 16:28:40 2009
References: <20090427142010.587518220@arndb.de>
User-Agent: quilt/0.46-1
Date: Mon, 27 Apr 2009 16:20:23 +0200
From: arnd@arndb.de
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com,
 monstr@monstr.eu,
 linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org,
 liqin.chen@sunplusct.com,
 Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC 13/17] ipc: use __ARCH_WANT_IPC_PARSE_VERSION in ipc/util.h
Content-Disposition: inline; filename=0022-ipc-use-__ARCH_WANT_IPC_PARSE_VERSION-in-ipc-util.h.patch
X-Provags-ID: V01U2FsdGVkX18XBt90axOy7gq1iOAvQAzmT8OJyKsN9DsrBLG
 XvqaAO+4HVxMX1CbEf9AVxb9WK26KJMD20wbAiwtaPcHCGJ+L5
 CEbxeW6qqUVXl2PjsWpKw==

The definition of ipc_parse_version depends on
__ARCH_WANT_IPC_PARSE_VERSION, but the header file
declares it conditionally based on the architecture.

Use the macro consistently to make it easier to add
new architectures.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 ipc/util.h |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/ipc/util.h
===================================================================
--- linux-2.6.orig/ipc/util.h
+++ linux-2.6/ipc/util.h
@@ -128,7 +128,7 @@ void ipc_update_perm(struct ipc64_perm *
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
 				      struct ipc64_perm *perm, int extra_perm);
 
-#if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || defined(__XTENSA__)
+#ifndef __ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else

-- 


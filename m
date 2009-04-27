Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbZD0TKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbZD0TKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 15:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760265AbZD0TJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 15:09:07 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:32792 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760222AbZD0TJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 15:09:05 -0400
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
Date: Mon, 27 Apr 2009 15:08:54 -0400
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3; KDE/4.2.2; i686; ; )
MIME-version: 1.0
Subject: Fwd:
To: linux-kernel@vger.kernel.org
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-disposition: inline
Message-id: <200904271508.54518.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----------  Forwarded Message  ----------

Subject: 
Date: Monday 27 April 2009
From: arnd@arndb.de
To: "no To-header on input" <unlisted-recipients:; @gmail-pop.l.google.com>

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
Content-Disposition: inline; filename=0022-ipc-use-
__ARCH_WANT_IPC_PARSE_VERSION-in-ipc-util.h.patch
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
 
-#if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) || 
defined(__XTENSA__)
+#ifndef __ARCH_WANT_IPC_PARSE_VERSION
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */ 
 # define ipc_parse_version(cmd)	IPC_64
 #else

-- 

--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


-------------------------------------------------------

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
"The four building blocks of the universe are fire, water, gravel and vinyl."
		-- Dave Barry


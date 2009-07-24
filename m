Return-Path: <linux-kernel-owner+w=401wt.eu-S1752045AbZGXDBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbZGXDBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbZGXDBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:01:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:47937 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbZGXDB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:01:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="535500521"
Subject: [PATCH V2 1/4] fix a problem that linux/async.h can not be
	included in another header file
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 24 Jul 2009 11:02:00 +0800
Message-Id: <1248404520.2670.109.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


include/linux/async.h:16: error: redefinition of typedef ‘async_cookie_t’
include/linux/async.h:16: error: previous declaration of ‘async_cookie_t’ was here
include/linux/async.h:17: error: redefinition of typedef ‘async_func_ptr’
include/linux/async.h:17: error: previous declaration of ‘async_func_ptr’ was here

fix a problem that include/linux/async.h can not be included in another header file

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 include/linux/async.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/include/linux/async.h
===================================================================
--- linux-2.6.orig/include/linux/async.h
+++ linux-2.6/include/linux/async.h
@@ -9,6 +9,8 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+#ifndef _ASYNC_H_
+#define _ASYNC_H_
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -25,3 +27,4 @@ extern void async_synchronize_cookie(asy
 extern void async_synchronize_cookie_domain(async_cookie_t cookie,
 					    struct list_head *list);
 
+#endif /* _ASYNC_H_ */



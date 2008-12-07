Return-Path: <linux-kernel-owner+w=401wt.eu-S1755465AbYLGXx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbYLGXx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 18:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYLGXxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 18:53:19 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35374 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbYLGXxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 18:53:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH -suspend] Hibernate: Replace unnecessary evaluation of pfn_to_page()
Date: Mon, 8 Dec 2008 00:52:49 +0100
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812080052.49604.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Hibernate: Replace unnecessary evaluation of pfn_to_page()

Replace one evaluation of pfn_to_page() in copy_data_pages() with
the value of a local variable containing the right number already.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -981,7 +981,7 @@ static void copy_data_page(unsigned long
 			 * data modified by kmap_atomic()
 			 */
 			safe_copy_page(buffer, s_page);
-			dst = kmap_atomic(pfn_to_page(dst_pfn), KM_USER0);
+			dst = kmap_atomic(d_page, KM_USER0);
 			memcpy(dst, buffer, PAGE_SIZE);
 			kunmap_atomic(dst, KM_USER0);
 		} else {

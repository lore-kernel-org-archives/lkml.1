Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbXCJWW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbXCJWW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXCJWW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:22:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbXCJWWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:22:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] swsusp: Fix resume error path in platform mode
Date: Sat, 10 Mar 2007 23:22:57 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703102322.58372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If swsusp is using the platform mode during the resume and the image cannot be
read, the platform mode should be switched off before software_resume() returns.
Make it happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/disk.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.21-rc3/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc3.orig/kernel/power/disk.c
+++ linux-2.6.21-rc3/kernel/power/disk.c
@@ -260,6 +260,7 @@ static int software_resume(void)
 	error = swsusp_read();
 	if (error) {
 		swsusp_free();
+		platform_finish();
 		goto Thaw;
 	}
 

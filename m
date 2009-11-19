Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZKSNsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZKSNsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 08:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbZKSNsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 08:48:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44040 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751598AbZKSNsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 08:48:19 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] vt: Fix use of "new" in a struct field
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 19 Nov 2009 13:30:36 +0000
Message-ID: <20091119133012.1742.61779.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this struct is exposed to user space and the API was added for this
release it's a bit of a pain for the C++ world and we still have time to
fix it. Rename the fields before we end up with that pain in an actual
release.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Olivier Goffart
---

 drivers/char/vt_ioctl.c |    6 +++---
 include/linux/vt.h      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index ed86d3b..6aa1028 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -103,8 +103,8 @@ void vt_event_post(unsigned int event, unsigned int old, unsigned int new)
 		ve->event.event = event;
 		/* kernel view is consoles 0..n-1, user space view is
 		   console 1..n with 0 meaning current, so we must bias */
-		ve->event.old = old + 1;
-		ve->event.new = new + 1;
+		ve->event.oldev = old + 1;
+		ve->event.newev = new + 1;
 		wake = 1;
 		ve->done = 1;
 	}
@@ -186,7 +186,7 @@ int vt_waitactive(int n)
 		vt_event_wait(&vw);
 		if (vw.done == 0)
 			return -EINTR;
-	} while (vw.event.new != n);
+	} while (vw.event.newev != n);
 	return 0;
 }
 
diff --git a/include/linux/vt.h b/include/linux/vt.h
index 7afca0d..7ffa11f 100644
--- a/include/linux/vt.h
+++ b/include/linux/vt.h
@@ -70,8 +70,8 @@ struct vt_event {
 #define VT_EVENT_UNBLANK	0x0004	/* Screen unblank */
 #define VT_EVENT_RESIZE		0x0008	/* Resize display */
 #define VT_MAX_EVENT		0x000F
-	unsigned int old;		/* Old console */
-	unsigned int new;		/* New console (if changing) */
+	unsigned int oldev;		/* Old console */
+	unsigned int newev;		/* New console (if changing) */
 	unsigned int pad[4];		/* Padding for expansion */
 };
 


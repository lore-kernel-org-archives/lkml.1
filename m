Return-Path: <linux-kernel-owner+w=401wt.eu-S1751798AbZAHMPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751798AbZAHMPp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZAHMOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:14:33 -0500
Received: from mercury.realtime.net ([205.238.132.86]:37581 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZAHMOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:14:32 -0500
Subject: [PATCH 4/4] hvc_console: comment mb and make it an smp_ one
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>
From: Milton Miller <miltonm@bga.com>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <hvc-console-29-3-4@bga.com>
In-Reply-To: : <hvc-console-29-3@bga.com>
Date: Thu, 08 Jan 2009 06:14:18 -0600
X-Originating-IP: 205.232.218.56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I remember some history on this barrier.  There was a race between
open via /dev/console and the tty being fully setup.  Its also why
there is a temporary variable and the global is assigned at the end
of the function.

Signed-off-by: Milton Miller <miltonm@bga.com>


Index: work.git/drivers/char/hvc_console.c
===================================================================
--- work.git.orig/drivers/char/hvc_console.c	2009-01-08 04:33:39.000000000 -0600
+++ work.git/drivers/char/hvc_console.c	2009-01-08 04:35:09.000000000 -0600
@@ -875,8 +875,11 @@ static int hvc_init(void)
 		goto stop_thread;
 	}
 
-	/* FIXME: This mb() seems completely random.  Remove it. */
-	mb();
+	/*
+	 * Make sure tty is fully registered before allowing it to be
+	 * found by hvc_console_device.
+	 */
+	smp_mb();
 	hvc_driver = drv;
 	return 0;
 

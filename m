Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbYHDCac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbYHDCac (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 22:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYHDCaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 22:30:24 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:45134 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbYHDCaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 22:30:24 -0400
Message-ID: <51542.166.70.238.45.1217815801.squirrel@webmail.wolfmountaingroup.com>
Date: Sun, 3 Aug 2008 20:10:01 -0600 (MDT)
Subject: [PATCH 2.6.26 1/25] mdb: Merkey's Kernel Debugger
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Netware Style Debugger for Linux written by Jeffrey Vernon Merkey

--- linux-2.6.26/arch/x86/kernel/reboot.c	2008-07-13 15:51:29.000000000 -0600
+++ linux-2.6.26-mdb/arch/x86/kernel/reboot.c	2008-08-03
12:49:01.000000000 -0600
@@ -425,7 +425,16 @@
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
 	 */
+#ifdef CONFIG_MDB
+        // do not stop the other processors if the debugger is active +  
     {
+           extern atomic_t inmdb;
+           if (!atomic_read(&inmdb))
+	      smp_send_stop();
+        }
+#else
 	smp_send_stop();
+#endif // CONFIG_MDB
 #endif

 	lapic_shutdown();

By making a contribution to this project, I certify that the contribution
was created in whole or in part by me and I have the right to submit it
under the open source license indicated in the file

Jeffrey Vernon Merkey






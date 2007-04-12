Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbXDLX5C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbXDLX5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:57:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbXDLX5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:57:01 -0400
Received: from mail.screens.ru ([213.234.233.54]:57289 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbXDLX4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:56:54 -0400
Date: Fri, 13 Apr 2007 03:56:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adam Belay <ambx1@neo.rr.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] pnpbios_thread_init: don't use CLONE_SIGHAND
Message-ID: <20070412235632.GA1053@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pnp_dock_thread() calls allow_signal() which plays with parent process's
->sighand.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

--- 2.6.21-rc5/drivers/pnp/pnpbios/core.c~3_pnp	2006-12-17 19:06:40.000000000 +0300
+++ 2.6.21-rc5/drivers/pnp/pnpbios/core.c	2007-04-13 03:44:34.000000000 +0400
@@ -589,7 +589,7 @@ static int __init pnpbios_thread_init(vo
 		return 0;
 #ifdef CONFIG_HOTPLUG
 	init_completion(&unload_sem);
-	if (kernel_thread(pnp_dock_thread, NULL, CLONE_KERNEL) > 0)
+	if (kernel_thread(pnp_dock_thread, NULL, CLONE_FS | CLONE_FILES) > 0)
 		unloading = 0;
 #endif
 	return 0;


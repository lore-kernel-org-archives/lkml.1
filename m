Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbZC2QMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbZC2QMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZC2QMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:12:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48397 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbZC2QMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:12:44 -0400
Date: Sun, 29 Mar 2009 17:12:22 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [PATCH] oprofile: Thou shalt not call __exit functions from __init
	functions
Message-ID: <20090329161222.GA3601@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`buffer_sync_cleanup' referenced in section `.init.text' of arch/arm/oprofile/built-in.o: defined in discarded section `.exit.text' of arch/arm/oprofile/built-in.o

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---

 drivers/oprofile/buffer_sync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index c3ea5fa..2c9aa49 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -574,7 +574,7 @@ int __init buffer_sync_init(void)
 		return 0;
 }
 
-void __exit buffer_sync_cleanup(void)
+void buffer_sync_cleanup(void)
 {
 	free_cpumask_var(marked_cpus);
 }

-- 
Russell King

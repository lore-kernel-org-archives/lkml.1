Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYLKKQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYLKKQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYLKKQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:16:25 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:8308 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbYLKKQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:16:24 -0500
Date: Thu, 11 Dec 2008 11:16:14 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jens Axboe <axboe@kernel.dk>, Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: Fix LSF default inconsistency
Message-ID: <20081211111614.493d2a62@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuration option LSF has a default which contradicts its help
text. The help text says "if unsure, say Y" but there is no explicit
default, and the default default is N.

This inconsistency was introduced by commit
88b9adb073b7a69a54b1b14423103bc24587ebdc. According to the commit
message, we want users to enable this option, so it should default to
Y.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 block/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.28-rc8.orig/block/Kconfig	2008-10-10 09:27:54.000000000 +0200
+++ linux-2.6.28-rc8/block/Kconfig	2008-12-11 11:09:33.000000000 +0100
@@ -60,6 +60,7 @@ config BLK_DEV_IO_TRACE
 config LSF
 	bool "Support for Large Single Files"
 	depends on !64BIT
+	default y
 	help
 	  Say Y here if you want to be able to handle very large files (2TB
 	  and larger), otherwise say N.


-- 
Jean Delvare

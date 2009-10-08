Return-Path: <linux-kernel-owner+w=401wt.eu-S1757825AbZJHMdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757825AbZJHMdD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 08:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757659AbZJHMdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 08:33:01 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:39139 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756771AbZJHMdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 08:33:00 -0400
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Oct 2009 08:32:55 EDT
Date: Thu, 8 Oct 2009 14:21:04 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: linux-kernel@vger.kernel.org
Cc: Simon =?ISO-8859-1?Q?K=E5gstr=F6m?= 
	<simon.kagstrom@netinsight.net>
Subject: [PATCH] Export panic_on_oops to modules
Message-ID: <20091008142104.25c81fea@marrow.netinsight.se>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent fix to the mtdoops driver on the MTD mailing list makes use
of panic_on_oops to determine if mtd->panic_write should be called to
store an oops/panic:

  http://patchwork.ozlabs.org/patch/34732/

and thereby fixes mtdoops when panic_on_oops is set. Exporting
panic_on_oops enables mtdoops to be built as a module with this
patch.

Signed-off-by: Simon Kagstrom <simon.kagstrom@netinsight.net>
---
 kernel/panic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index bcdef26..6d29be3 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -24,6 +24,8 @@
 #include <linux/dmi.h>
 
 int panic_on_oops;
+EXPORT_SYMBOL_GPL(panic_on_oops);
+
 static unsigned long tainted_mask;
 static int pause_on_oops;
 static int pause_on_oops_flag;
-- 
1.6.0.4


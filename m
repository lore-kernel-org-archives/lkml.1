Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZGGF1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZGGF1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZGGF1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:27:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:46382 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZGGF1i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:27:38 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] /dev/zero: Avoid repeated access_ok() checks
Date: Tue, 7 Jul 2009 10:59:19 +0530
User-Agent: KMail/1.11.1 (Linux/2.6.27.23-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071059.19221.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In read_zero, we check for access_ok() once for the count bytes. It is
unnecessarily checked again in clear_user. Use __clear_user, which does not
check for access_ok().

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index afa8813..3e05b48 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -690,7 +690,7 @@ static ssize_t read_zero(struct file * file, char __user * buf,
 
 		if (chunk > PAGE_SIZE)
 			chunk = PAGE_SIZE;	/* Just for latency reasons */
-		unwritten = clear_user(buf, chunk);
+		unwritten = __clear_user(buf, chunk);
 		written += chunk - unwritten;
 		if (unwritten)
 			break;


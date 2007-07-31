Return-Path: <linux-kernel-owner+w=401wt.eu-S1760202AbXGaWPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760202AbXGaWPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 18:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbXGaWO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 18:14:58 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4771 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756642AbXGaWO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 18:14:57 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 78] fs/proc/vmcore.c: kmalloc + memset conversion to kzalloc
Date: Wed, 1 Aug 2007 00:14:57 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       gregkh@suse.de
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708010014.58099.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 fs/proc/vmcore.c | 16780 -> 16727 (-53 bytes)
 fs/proc/vmcore.o | 113032 -> 112744 (-288 bytes)

 fs/proc/vmcore.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/fs/proc/vmcore.c	2007-07-26 13:07:46.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/fs/proc/vmcore.c	2007-07-31 15:51:05.000000000 +0200
@@ -178,12 +178,7 @@ const struct file_operations proc_vmcore

 static struct vmcore* __init get_new_element(void)
 {
-	struct vmcore *p;
-
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
-	if (p)
-		memset(p, 0, sizeof(*p));
-	return p;
+	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
 }

 static u64 __init get_vmcore_size_elf64(char *elfptr)

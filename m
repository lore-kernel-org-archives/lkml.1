Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbZJFVeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbZJFVeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933425AbZJFVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:34:09 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39132 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbZJFVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:34:06 -0400
Subject: [PATCH 1/7] vsprintf: fix io/mem resource width
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Tue, 06 Oct 2009 15:33:29 -0600
Message-ID: <20091006213329.4272.6694.stgit@bob.kio>
In-Reply-To: <20091006213259.4272.68068.stgit@bob.kio>
References: <20091006213259.4272.68068.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The leading "0x" consumes field width, so leave space for it in addition to
the 4 or 8 hex digits.  This means we'll print "0x0000-0x01df" rather than
"0x00-0x1df", for example.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 lib/vsprintf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 33bed5e..7830576 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -598,11 +598,11 @@ static char *resource_string(char *buf, char *end, struct resource *res,
 				struct printf_spec spec)
 {
 #ifndef IO_RSRC_PRINTK_SIZE
-#define IO_RSRC_PRINTK_SIZE	4
+#define IO_RSRC_PRINTK_SIZE	6
 #endif
 
 #ifndef MEM_RSRC_PRINTK_SIZE
-#define MEM_RSRC_PRINTK_SIZE	8
+#define MEM_RSRC_PRINTK_SIZE	10
 #endif
 	struct printf_spec num_spec = {
 		.base = 16,


Return-Path: <linux-kernel-owner+w=401wt.eu-S1759279AbZBLKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279AbZBLKll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 05:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758482AbZBLKk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 05:40:26 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60205 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757484AbZBLKkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 05:40:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] MTD: Fix a bad dependency in the Blackfin code
To: dwmw2@infradead.org, bernds_cb1@t-online.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 12 Feb 2009 10:40:15 +0000
Message-ID: <20090212104015.26766.41302.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090212104000.26766.11068.stgit@warthog.procyon.org.uk>
References: <20090212104000.26766.11068.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernd.schmidt@analog.com>

Fix a bad dependency in the Blackfin code on a RomFS config symbol that doesn't
exist upstream.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Bernd Schmidt <bernd.schmidt@analog.com>
---

 arch/blackfin/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/arch/blackfin/kernel/process.c b/arch/blackfin/kernel/process.c
index 33e2e89..7f7ce07 100644
--- a/arch/blackfin/kernel/process.c
+++ b/arch/blackfin/kernel/process.c
@@ -337,7 +337,7 @@ int _access_ok(unsigned long addr, unsigned long size)
 	if (addr >= memory_mtd_end && (addr + size) <= physical_mem_end)
 		return 1;
 
-#ifdef CONFIG_ROMFS_MTD_FS
+#ifdef CONFIG_ROMFS_ON_MTD
 	/* For XIP, allow user space to use pointers within the ROMFS.  */
 	if (addr >= memory_mtd_start && (addr + size) <= memory_mtd_end)
 		return 1;


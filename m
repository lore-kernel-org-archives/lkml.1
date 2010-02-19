Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0BST1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:27:11 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34142 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625Ab0BST1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:27:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 1/7] arm-dt: Add ATAG_DEVTREE tag
To: linux@arm.linux.org.uk, catalin.marinas@arm.com, jeremy.kerr@canonical.com,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: tim.bird@am.sony.com
Date: Fri, 19 Feb 2010 12:27:00 -0700
Message-ID: <20100219192646.15318.93865.stgit@angua>
In-Reply-To: <20100219185953.15318.4850.stgit@angua>
References: <20100219185953.15318.4850.stgit@angua>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Kerr <jeremy.kerr@canonical.com>

We'd like to provide a pointer to the device tree blob through the atags
mechanism, so add a tag type containing a physical dtb pointer.

We won't need a parser for this, as we'll need to do the devtree parsing
a little earlier than other tags.

Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

 arch/arm/include/asm/setup.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index dfa9ddf..ee77cec 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -126,6 +126,14 @@ struct tag_cmdline {
 	char	cmdline[1];	/* this is the minimum size */
 };
 
+/* flattened device tree blob pointer */
+#define ATAG_DEVTREE	0x5441000a
+
+struct tag_devtree {
+	__u32 start;	/* physical start address */
+	__u32 size;	/* size of dtb image in bytes */
+};
+
 /* acorn RiscPC specific information */
 #define ATAG_ACORN	0x41000101
 
@@ -155,6 +163,7 @@ struct tag {
 		struct tag_revision	revision;
 		struct tag_videolfb	videolfb;
 		struct tag_cmdline	cmdline;
+		struct tag_devtree	devtree;
 
 		/*
 		 * Acorn specific


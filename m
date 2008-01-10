Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbYAJWef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbYAJWef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756399AbYAJWeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:34:12 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:38770 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbYAJWeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:34:11 -0500
Date: Thu, 10 Jan 2008 14:32:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: samr <sam@ravnborg.org>, mingo@redhat.com, tglx <tglx@linutronix.de>,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] x86: discover_ebda section mismatch
Message-Id: <20080110143214.8be8bb4c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatches.  discover_ebda() can be __init.

WARNING: vmlinux.o(.text+0x738a): Section mismatch: reference to .init.data:ebda_addr (between 'discover_ebda' and 'get_model_name')
WARNING: vmlinux.o(.text+0x73c4): Section mismatch: reference to .init.data:ebda_size (between 'discover_ebda' and 'get_model_name')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kernel/setup_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7-git1.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6.24-rc7-git1/arch/x86/kernel/setup_64.c
@@ -234,7 +234,7 @@ static inline void __init reserve_crashk
 unsigned __initdata ebda_addr;
 unsigned __initdata ebda_size;
 
-static void discover_ebda(void)
+static void __init discover_ebda(void)
 {
 	/*
 	 * there is a real-mode segmented pointer pointing to the 

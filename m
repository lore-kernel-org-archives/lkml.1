Return-Path: <linux-kernel-owner+w=401wt.eu-S940068AbXHIMqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940068AbXHIMqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939661AbXHIMlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:41:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:34974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939657AbXHIMlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:41:39 -0400
From: Andi Kleen <ak@suse.de>
References: <20070809241.425881000@suse.de>
In-Reply-To: <20070809241.425881000@suse.de>
To: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/12] x86_64: Add warning in Documentation that zero-page is not a stable ABI
Message-Id: <20070809124138.1F2E114F3B@wotan.suse.de>
Date: Thu,  9 Aug 2007 14:41:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some people writing boot loaders seem to falsely belief the 32bit zero page is a 
stable interface for out of tree code like the real mode boot protocol. Add a comment 
clarifying that is not true.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/i386/zero-page.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux/Documentation/i386/zero-page.txt
===================================================================
--- linux.orig/Documentation/i386/zero-page.txt
+++ linux/Documentation/i386/zero-page.txt
@@ -1,3 +1,13 @@
+---------------------------------------------------------------------------
+!!!!!!!!!!!!!!!WARNING!!!!!!!!
+The zero page is a kernel internal data structure, not a stable ABI.  It might change
+without warning and the kernel has no way to detect old version of it.
+If you're writing some external code like a boot loader you should only use
+the stable versioned real mode boot protocol described in boot.txt. Otherwise the kernel
+might break you at any time.
+!!!!!!!!!!!!!WARNING!!!!!!!!!!!
+----------------------------------------------------------------------------
+
 Summary of boot_params layout (kernel point of view)
      ( collected by Hans Lermen and Martin Mares )
  

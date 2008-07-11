Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYGKJrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYGKJrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYGKJrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:47:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYGKJrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:47:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix pci_subsys_init() to have a return value
To: jbarnes@virtuousgeek.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 11 Jul 2008 10:46:36 +0100
Message-ID: <20080711094636.18199.94804.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix pci_subsys_init() to return a value (0) when it has finished.  All the
functions it calls currently return 0, so returning 0 here unconditionally
rather than gathering the results of its callees would seem reasonable.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/pci/legacy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 3c1d795..00e29c8 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -63,5 +63,6 @@ int __init pci_subsys_init(void)
 	pci_legacy_init();
 	pcibios_irq_init();
 	pcibios_init();
+	return 0;
 }
 subsys_initcall(pci_subsys_init);


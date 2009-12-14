Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbZLNOOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbZLNOOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757352AbZLNOOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:14:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZLNOOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:14:32 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] PCI: Global variable decls must match the defs in section
	attributes
To: torvalds@osdl.org, jbarnes@virtuousgeek.org, tj@kernel.org,
       akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Mon, 14 Dec 2009 14:13:44 +0000
Message-ID: <20091214141344.12091.43853.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global variable declarations must match the definitions in section attributes
as the compiler is at liberty to vary the method it uses to access a variable,
depending on the section it is in.

When building the FRV arch, I now see:

drivers/built-in.o: In function `pci_apply_final_quirks':
drivers/pci/quirks.c:2606: relocation truncated to fit: R_FRV_GPREL12 against symbol `pci_dfl_cache_line_size' defined in .devinit.data section in drivers/built-in.o
drivers/pci/quirks.c:2623: relocation truncated to fit: R_FRV_GPREL12 against symbol `pci_dfl_cache_line_size' defined in .devinit.data section in drivers/built-in.o
drivers/pci/quirks.c:2630: relocation truncated to fit: R_FRV_GPREL12 against symbol `pci_dfl_cache_line_size' defined in .devinit.data section in drivers/built-in.o

because the declaration of pci_dfl_cache_line_size in linux/pci.h does not
match the definition in drivers/pci/pci.c.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/linux/pci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/include/linux/pci.h b/include/linux/pci.h
index 04771b9..bf1e670 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1255,7 +1255,7 @@ extern int pci_pci_problems;
 
 extern unsigned long pci_cardbus_io_size;
 extern unsigned long pci_cardbus_mem_size;
-extern u8 pci_dfl_cache_line_size;
+extern u8 __devinitdata pci_dfl_cache_line_size;
 extern u8 pci_cache_line_size;
 
 extern unsigned long pci_hotplug_io_size;


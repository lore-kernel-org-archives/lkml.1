Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYKHKZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYKHKZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 05:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYKHKZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 05:25:20 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:53694 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbYKHKZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 05:25:20 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 1/1] x86_64: update address space documentation
Date: Sat,  8 Nov 2008 11:24:57 +0100
Message-Id: <1226139897-15070-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a6523748bddd38bcec11431f57502090b6014a96
(paravirt/x86, 64-bit: move __PAGE_OFFSET to leave a space for hypervisor)
changed address space without changing the documentation. Change it
according to the code change -- direct mapping start:
ffff810000000000 => ffff880000000000 which gives 57 TiB, something between
45 and 46 bits.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
---
 Documentation/x86/x86_64/mm.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index efce750..29b52b1 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -6,7 +6,7 @@ Virtual memory map with 4 level page tables:
 0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
 ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
-ffff810000000000 - ffffc0ffffffffff (=46 bits) direct mapping of all phys. memory
+ffff880000000000 - ffffc0ffffffffff (=57 TB) direct mapping of all phys. memory
 ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
 ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
 ffffe20000000000 - ffffe2ffffffffff (=40 bits) virtual memory map (1TB)
-- 
1.6.0.3


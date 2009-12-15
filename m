Return-Path: <linux-kernel-owner+w=401wt.eu-S932525AbZLOBUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbZLOBUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbZLOBUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:20:09 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59246 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758945AbZLOBUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:20:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B26E436.9000806@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 10:19:50 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jiri Slaby <jslaby@suse.cz>, Aristeu Sergio <arozansk@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       x86@kernel.org
Subject: [PATCH] pci: fix section mismatch on update_res()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

Remark update_res from __init to __devinit as it is called also
from __devinit functions.

This patch removes the following warning message:

  WARNING: vmlinux.o(.devinit.text+0x774a): Section mismatch
  in reference from the function pci_root_bus_res() to the
  function .init.text:update_res()
  The function __devinit pci_root_bus_res() references
  a function __init update_res().
  If update_res is only used by pci_root_bus_res then
  annotate update_res with a matching annotation.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Aristeu Sergio <arozansk@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 arch/x86/pci/bus_numa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/bus_numa.c b/arch/x86/pci/bus_numa.c
index 145df00..f939d60 100644
--- a/arch/x86/pci/bus_numa.c
+++ b/arch/x86/pci/bus_numa.c
@@ -51,7 +51,7 @@ void x86_pci_root_bus_res_quirks(struct pci_bus *b)
 	}
 }
 
-void __init update_res(struct pci_root_info *info, size_t start,
+void __devinit update_res(struct pci_root_info *info, size_t start,
 			      size_t end, unsigned long flags, int merge)
 {
 	int i;
-- 
1.6.5.6



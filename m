Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbXLHTaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbXLHTaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:30:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXLHTaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:30:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:63215 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXLHTaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=YbJsMzNR94LuLZ/8NxEmC2yroTtV6GDN+EakARAANVNzsu8hX04vnyFPz3gEVYIt4zToiMmYAg8QIB30dVCCF7NtRB0PMDqzdU3R1LFc/thMkx10wKYFpMFGdYMyZCw0fRsoKOYFKyN21epS2WyLyU1BU4exO9ZyiOHkt1708AI=
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ps3: "mm/Kconfig" fix
Date: Sat, 8 Dec 2007 20:30:11 +0100
User-Agent: KMail/1.9.7
Cc: Geoff Levand <geoffrey.levand@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712082030.11338.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparsemem-make-sparsemem-vmemmap-selectable.patch introduces a little bug.

SPARSEMEM_VMEMMAP can be enabled in an architecture that doesn't support it. If the
architecture supports SPARSEMEM_VMEMMAP, SPARSEMEM_VMEMMAP_ENABLE is enabled,
so SPARSEMEM_VMEMMAP should depend on it.

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/mm/Kconfig b/mm/Kconfig
index c0f5cbb..010a261 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -117,8 +117,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
 
 config SPARSEMEM_VMEMMAP
 	bool "Sparse Memory virtual memmap"
-	depends on SPARSEMEM
-	default y if (SPARSEMEM_VMEMMAP_ENABLE)
+	depends on SPARSEMEM_VMEMMAP_ENABLE
+	default y
 	help
 	 SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
 	 pfn_to_page and page_to_pfn operations.  This is the most


-- 
	Miguel Botón

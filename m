Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYKDQ3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYKDQ3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756649AbYKDQ3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:29:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:20358 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbYKDQ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:28:59 -0500
Message-ID: <49107844.8070509@mimas.ru>
Date: Tue, 04 Nov 2008 20:28:52 +0400
From: Constantin Baranov <const@mimas.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.17) Gecko/20080930 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28-rc3] x86: make CONFIG_SWIOTLB configurable
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it possible to enable individually the CONFIG_SWIOTLB option.
This is useful for Intel x86_64 systems without DMAR support.

Signed-off-by: Constantin Baranov <const@mimas.ru>
---
Tested on my system based on Gigabyte GA-EP45-DS3 mainboard
(P45 chipset) with 8 GiB of RAM.
Currently I need to enable either CONFIG_GART_IOMMU or
CONFIG_AMD_IOMMU for proper work. Both are AMD specific.
When the patch applied, just CONFIG_SWIOTLB is sufficient.

 arch/x86/Kconfig |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.28-rc3/arch/x86/Kconfig	2008-11-04 17:32:29.846408880 +0400
+++ linux-2.6.28-rc3-swiotlb/arch/x86/Kconfig	2008-11-04 18:11:47.796408084 +0400
@@ -566,7 +566,9 @@ config AMD_IOMMU
 
 # need this always selected by IOMMU for the VIA workaround
 config SWIOTLB
-	bool
+	bool "Support for software bounce buffers"
+	depends on X86_64 && EXPERIMENTAL
+	default n
 	help
 	  Support for software bounce buffers used on x86-64 systems
 	  which don't have a hardware IOMMU (e.g. the current generation

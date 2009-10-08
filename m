Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbZJHKAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbZJHKAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 06:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZJHKAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 06:00:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:44914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124AbZJHKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 06:00:43 -0400
Message-ID: <4ACDB819.4060606@kernel.org>
Date: Thu, 08 Oct 2009 18:59:53 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH pci-2.6#linux-next] pci: pci_dfl_cache_line_size is __devinitdata
References: <20091008152725.1351485a.sfr@canb.auug.org.au>
In-Reply-To: <20091008152725.1351485a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 09:59:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_dfl_cache_line_size is marked as __initdata but referenced by
pci_init() which is __devinit.  Make it __devinitdata instead of
__initdata.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 1ae95df..a6e22fd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -53,7 +53,7 @@ unsigned long pci_hotplug_mem_size = DEFAULT_HOTPLUG_MEM_SIZE;
  * the dfl or actual value as it sees fit.  Don't forget this is
  * measured in 32-bit words, not bytes.
  */
-u8 pci_dfl_cache_line_size __initdata = L1_CACHE_BYTES >> 2;
+u8 pci_dfl_cache_line_size __devinitdata = L1_CACHE_BYTES >> 2;
 u8 pci_cache_line_size;
 
 /**

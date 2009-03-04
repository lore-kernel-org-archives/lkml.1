Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZCDCcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZCDCcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 21:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750901AbZCDCcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 21:32:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:46012 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZCDCcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 21:32:12 -0500
Message-ID: <49ADE82D.40103@kernel.org>
Date: Wed, 04 Mar 2009 11:32:13 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, pgnet.trash@gmail.com
Subject: [PATCH 2.6.29-rc7 1/2] x86: fix iommu=nodac parameter handling
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 02:31:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nodac should forbid dac not instead of enabling it.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index b254285..69c7a8d 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -197,7 +197,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;

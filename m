Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbZJZOls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbZJZOls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 10:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbZJZOlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 10:41:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:60938 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbZJZOlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 10:41:47 -0400
Message-ID: <4AE5B52A.4050408@kernel.org>
Date: Mon, 26 Oct 2009 15:41:46 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: the arch/x86 maintainers <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, athena@fftw.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix iommu=nodac parameter handling
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nodac should forbid dac instead of enabling it.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Matteo Frigo <athena@fftw.org>
Cc: stable@kernel.org
---
This was posted several months ago in a two patch series.  The second
one was rejected by Alan and with that the first one got lost too
although it's an apparent bug fix.  Matteo hit this bug recently and
reminded me about this patch.  So, regenerated and reposting.

Thanks.

 arch/x86/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index d20009b..8cf3996 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -216,7 +216,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;

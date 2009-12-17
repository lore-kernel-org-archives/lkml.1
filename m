Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZLQBjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZLQBjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763084AbZLQBUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:23 -0500
Received: from kroah.org ([198.145.64.141]:47899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763551AbZLQBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:14 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:02 2009
Message-Id: <20091217011602.184023170@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Matteo Frigo <athena@fftw.org>, Ingo Molnar <mingo@elte.hu>
Subject: [33/90] x86: Fix iommu=nodac parameter handling
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2ae8bb75db1f3de422eb5898f2a063c46c36dba8 upstream.

iommu=nodac should forbid dac instead of enabling it. Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Matteo Frigo <athena@fftw.org>
LKML-Reference: <4AE5B52A.4050408@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -203,7 +203,7 @@ static __init int iommu_setup(char *p)
 		if (!strncmp(p, "allowdac", 8))
 			forbid_dac = 0;
 		if (!strncmp(p, "nodac", 5))
-			forbid_dac = -1;
+			forbid_dac = 1;
 		if (!strncmp(p, "usedac", 6)) {
 			forbid_dac = -1;
 			return 1;



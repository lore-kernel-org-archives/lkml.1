Return-Path: <linux-kernel-owner+w=401wt.eu-S935337AbXJSSHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935337AbXJSSHW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 14:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764852AbXJSSHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 14:07:09 -0400
Received: from slackadelic.com ([65.196.224.53]:35064 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762732AbXJSSHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 14:07:07 -0400
From: Carlos Corbacho <cathectic@slackadelic.com>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: Fix resume for nVidia and force_hpet
Date: Fri, 19 Oct 2007 19:07:43 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, Mikko Tiihonen <mikko.tiihonen@iki.fi>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
References: <200710190423.31714.cathectic@slackadelic.com> <200710191851.28639.cathectic@slackadelic.com> <alpine.LFD.0.9999.0710191957420.22770@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0710191957420.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191907.43789.cathectic@slackadelic.com>
X-slackadelic.com-MailScanner-Information: Please contact the ISP for more information
X-slackadelic.com-MailScanner: Found to be clean
X-slackadelic.com-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=0.1, required 4, RDNS_DYNAMIC 0.10)
X-slackadelic.com-MailScanner-From: cathectic@slackadelic.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carlos Corbacho <cathectic@gmail.com>

Actually set force_hpet_resume_type.
---
Whoops, just noticed I forgot to re-add this to the patch before submitting it.

 arch/x86/kernel/quirks.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index cb21bcb..df01a1e 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -344,6 +344,7 @@ static void nvidia_force_enable_hpet(struct pci_dev *dev)
 	printk(KERN_DEBUG "Force enabled HPET at base address 0x%lx\n",
 		force_hpet_address);
 	cached_dev = dev;
+	force_hpet_resume_type = NVIDIA_FORCE_HPET_RESUME;
 	return;
 }
 
-- 
1.5.2.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZJ2Nwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZJ2Nwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 09:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbZJ2Nwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 09:52:36 -0400
Received: from mail-ew0-f209.google.com ([209.85.219.209]:61913 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbZJ2Nwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 09:52:36 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 09:52:35 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=q7RUyiMf/jBqFhLQEJEy/TUKlb7vYUX5gWWjuIYnQjcK/hfCROnG+nSY1J0fmlkRxc
         RSUwYabefeLPoS0va7Hidyjh1/gfyjJ62DaQieLGWCzU73rwdHO8urh572SLUqG+QBfH
         0scKJ+xnr7UZyBcDuuOtVbw3Alv9lqGIPnwrM=
Date: Thu, 29 Oct 2009 14:45:52 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading the
 container file
Message-ID: <20091029134552.GC30802@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5183dd763c6dc9f760e29f3313e0ae3dda5228a2 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Thu, 29 Oct 2009 14:00:54 +0100
Subject: [PATCH 1/2] x86, amd-ucode: Check UCODE_MAGIC before loading the container file

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/microcode_amd.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 366baa1..f4c538b 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -317,6 +317,12 @@ static enum ucode_state request_microcode_fw(int cpu, struct device *device)
 		return UCODE_NFOUND;
 	}
 
+	if (*(u32 *)firmware->data != UCODE_MAGIC) {
+		printk(KERN_ERR "microcode: invalid UCODE_MAGIC (0x%08x)\n",
+		       *(u32 *)firmware->data);
+		return UCODE_ERROR;
+	}
+
 	ret = generic_load_microcode(cpu, firmware->data, firmware->size);
 
 	release_firmware(firmware);
-- 
1.6.5.1


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbYGJDTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbYGJDTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYGJDSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:18:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:42886 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYGJDSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:18:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=Ivjb63iKE9WIjKxKnyi7rHwczRJpYZqldMP213QXhUL93VsIxBGOhoJ8Q6czx5lqG/
         LMJXtGa6hCOOVvuth3fCwi8gALytTdw3eYut/xY6lsmgy3k+MyK56Auy14wKcG/2Vn4u
         YnjkgH1aAFbXW+IQfSYIuiI2rfzfghIOBpW5s=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make e820_end return end_of_ram again for 64bit
Date: Wed, 9 Jul 2008 20:17:50 -0700
User-Agent: KMail/1.9.9
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807092015.03004.yhlu.kernel@gmail.com> <200807092016.36490.yhlu.kernel@gmail.com>
In-Reply-To: <200807092016.36490.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807092017.51004.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


even for 64bit system with less 4G, we can use fixmap to handle
acpi sit near end of ram

change e820_end to e820_end_of_ram again?
or e820_ram_pfn?

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |    2 --
 1 file changed, 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1066,10 +1066,8 @@ unsigned long __init e820_end(void)
 		struct e820entry *ei = &e820.map[i];
 		unsigned long end_pfn;
 
-#ifdef CONFIG_X86_32
 		if (ei->type != E820_RAM)
 			continue;
-#endif
 
 		end_pfn = (ei->addr + ei->size) >> PAGE_SHIFT;
 		if (end_pfn > last_pfn)

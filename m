Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYFXCyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYFXCyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 22:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbYFXCyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 22:54:09 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:61346 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYFXCyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 22:54:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a04g7RJ+YY61sC6orwkwirlTVBsUCdpj0fCGB1wtNyhNj+F9ro4ng61EVijsKfOcuJ
         CB3uFav257Ww2uA9t1MgA7sNbhOVOJ/n1kwO9xjo0nfIrDtI6SGuguRzeEOlLQMMmrF7
         qy2H+7WLca5ql3iihsoajnoez0SExwcPo4mQ4=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: setup_arch 64bit move kvmclock_init later
Date: Mon, 23 Jun 2008 19:52:44 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806231951.10898.yhlu.kernel@gmail.com> <200806231952.04756.yhlu.kernel@gmail.com>
In-Reply-To: <200806231952.04756.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231952.44320.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup_32.c |   32 ++++++++++++++++++--------------
 arch/x86/kernel/setup_64.c |   14 +++++++-------
 2 files changed, 25 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6/arch/x86/kernel/setup_64.c
@@ -296,10 +296,6 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
-#ifdef CONFIG_KVM_CLOCK
-	kvmclock_init();
-#endif
-
 	/*
 	 * Initialize the ACPI boot-time table parser (gets the RSDP and SDT).
 	 * Call this early for SRAT node setup.
@@ -342,6 +338,9 @@ void __init setup_arch(char **cmdline_p)
 
 	reserve_ibft_region();
 
+#ifdef CONFIG_KVM_CLOCK
+	kvmclock_init();
+#endif
 	paging_init();
 	map_vsyscall();
 

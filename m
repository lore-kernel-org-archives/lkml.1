Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbYHNSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbYHNSsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756379AbYHNSq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:59579 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbYHNSqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=bakfouvTGdWTShocmEQd3qDZXf8dkWwp6K0AOu0uni4ff8z9iWFXhCku13vSIe/hLc
         oYU2i3Ej0ohDxe/V4N8rEsH8cE1L7ZPjuIJaKUnCf0pLyC3NqHw3wdO3LoYylHmkZ+eW
         kU4FotBvwzbxRzKW5mFZ9Qnxcgjc+JREf715I=
Message-Id: <20080814184651.853370625@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:04 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 4/8] x86: apic - do not clear APIC twice in lapic_shutdown
Content-Disposition: inline; filename=x86-apic-lapic_shutdown-don-t-clear-APIC-twice.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to clear APIC twice since
disable_local_APIC will clear it anyway.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-14 22:03:28.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-14 22:16:01.000000000 +0400
@@ -834,10 +834,11 @@ void lapic_shutdown(void)
 		return;
 
 	local_irq_save(flags);
-	clear_local_APIC();
 
 	if (enabled_via_apicbase)
 		disable_local_APIC();
+	else
+		clear_local_APIC();
 
 	local_irq_restore(flags);
 }

-- 

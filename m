Return-Path: <linux-kernel-owner+w=401wt.eu-S1754943AbYFVCPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbYFVCPw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 22:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYFVCPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 22:15:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:41042 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbYFVCPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 22:15:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qTOfX6LXTZxhGb89GfYgCiHLX7DM7iSs3Zra4SXLfwAWm8NfpMyd6LdQsaVJBDCJc5
         KWKxSOGMwBOBe2BfG5kUeMssbu8AvrWNpxjT+bLxCbscUtN5Cr5GToE2i2tr971DTw7k
         Pfp3trqjtVZRkTd2rmUwXSQcjWni6sEVOs+6Q=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86: remove two duplicated func in setup_32.c
Date: Sat, 21 Jun 2008 19:16:52 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806191530.32354.yhlu.kernel@gmail.com> <200806210324.20059.yhlu.kernel@gmail.com>
In-Reply-To: <200806210324.20059.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806211916.52949.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


early_cpu_init is declcared in processor.h
memory_setup is defined in e820.c

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

--- a/arch/x86/kernel/setup_32.c	2008-06-21 17:17:02.000000000 -0700
+++ b/arch/x86/kernel/setup_32.c	2008-06-21 17:17:51.000000000 -0700
@@ -207,7 +207,6 @@ struct ist_info ist_info;
 EXPORT_SYMBOL(ist_info);
 #endif
 
-extern void early_cpu_init(void);
 extern int root_mountflags;
 
 unsigned long saved_video_mode;
@@ -607,12 +606,6 @@ static void set_mca_bus(int x)
 static void set_mca_bus(int x) { }
 #endif
 
-/* Overridden in paravirt.c if CONFIG_PARAVIRT */
-char * __init __attribute__((weak)) memory_setup(void)
-{
-	return machine_specific_memory_setup();
-}
-
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
  * passed the efi memmap, systab, etc., so we should use these data structures

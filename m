Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbXCLW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbXCLW6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXCLW6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:58:10 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:34791 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbXCLW6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:58:09 -0400
Message-ID: <45F5DB00.1070506@vmware.com>
Date: Mon, 12 Mar 2007 14:58:08 -0800
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Fix vmi time header bug
Content-Type: multipart/mixed;
 boundary="------------000801000006060704070302"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000801000006060704070302
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Some gcc put this function in .init.text because the header didn't 
match.  For 2.6.21-rc.

Zach

--------------000801000006060704070302
Content-Type: text/plain;
 name="vmi-devinit-header-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vmi-devinit-header-fix.patch"



Index: linux-2.6.21/include/asm-i386/vmi_time.h
===================================================================
--- linux-2.6.21.orig/include/asm-i386/vmi_time.h	2007-03-06 18:56:03.000000000 -0800
+++ linux-2.6.21/include/asm-i386/vmi_time.h	2007-03-12 13:55:16.000000000 -0800
@@ -54,7 +54,7 @@ extern unsigned long vmi_cpu_khz(void);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 extern void __init vmi_timer_setup_boot_alarm(void);
-extern void __init vmi_timer_setup_secondary_alarm(void);
+extern void __devinit vmi_timer_setup_secondary_alarm(void);
 extern void apic_vmi_timer_interrupt(void);
 #endif
 

--------------000801000006060704070302--

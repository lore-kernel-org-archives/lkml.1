Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbYGNC7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbYGNC7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 22:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756603AbYGNC6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 22:58:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:49563 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbYGNC6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 22:58:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,356,1212390000"; 
   d="scan'208";a="416814008"
Subject: Re: [mmotm] pm-acpi-hibernation-utilize-hardware-signature.patch
	causes build error
From: Shaohua Li <shaohua.li@intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
In-Reply-To: <38256.1215938644@turing-police.cc.vt.edu>
References: <38256.1215938644@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 11:05:43 +0800
Message-Id: <1216004743.22586.1.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-07-13 at 04:44 -0400, Valdis.Kletnieks@vt.edu wrote:
> Patch pm-acpi-hibernation-utilize-hardware-signature.patch in the 07/11 mmotm
> causes a link error:
> 
>   LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `acpi_sleep_setup':
> sleep.c:(.init.text+0x6854): undefined reference to `acpi_no_s4_hw_signature'
> 
> Not at all surprising, since the patch doesn't actually include a body
> for the function, only references.  Did a (hopefully) previous patch that
> added the body get lost along the way?
this should fix it.

---
 arch/x86/kernel/acpi/sleep.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-next/arch/x86/kernel/acpi/sleep.c
===================================================================
--- linux-next.orig/arch/x86/kernel/acpi/sleep.c	2008-07-14 11:02:28.000000000 +0800
+++ linux-next/arch/x86/kernel/acpi/sleep.c	2008-07-14 11:03:08.000000000 +0800
@@ -140,8 +140,10 @@ static int __init acpi_sleep_setup(char 
 			acpi_realmode_flags |= 2;
 		if (strncmp(str, "s3_beep", 7) == 0)
 			acpi_realmode_flags |= 4;
+#ifdef CONFIG_HIBERNATION
 		if (strncmp(str, "s4_nohwsig", 10) == 0)
 			acpi_no_s4_hw_signature();
+#endif
 		if (strncmp(str, "old_ordering", 12) == 0)
 			acpi_old_suspend_ordering();
 		str = strchr(str, ',');



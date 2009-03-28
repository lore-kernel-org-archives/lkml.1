Return-Path: <linux-kernel-owner+w=401wt.eu-S1760922AbZC1BZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760922AbZC1BZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 21:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbZC1BZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 21:25:35 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18988 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZC1BZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 21:25:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=lYS5whpfwyxkz5DvlHvREQdbQVK1111vsLSZmb/faNXuQ1xkzG5aLd0GBHukndW5wB
         c3aR9LOZVY6il5SiJMHa3or4xwxzwjLSPlpmaksY4xAgugqVDcLXN+rN7uVHzU1yhvlD
         s01u+xhT8AHOrK2ahsNwCBKXCVo8J747OpXqw=
MIME-Version: 1.0
Date: Sat, 28 Mar 2009 07:25:32 +0600
Message-ID: <b9df5fa10903271825g62b95e62p6e7006f0594e2c4b@mail.gmail.com>
Subject: [PATCH] x86,apic: Checking kernel option before detect_init_APIC()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Impact: cleanup

Before calling detect_init_APIC(), check whether apic is disabled from
kernel option or not.

Thanks.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linus/arch/x86/kernel/apic.c	2009-03-26 06:26:31.000000000 +0600
+++ rakib/arch/x86/kernel/apic.c	2009-03-26 20:47:50.116376200 +0600
@@ -1429,10 +1429,6 @@ static int __init detect_init_APIC(void)
 {
 	u32 h, l, features;

-	/* Disabled by kernel option? */
-	if (disable_apic)
-		return -1;
-
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
 		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model > 1) ||
@@ -1543,8 +1539,9 @@ void __init init_apic_mappings(void)
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
 	 * one for the IO-APIC.
+	 * Check apic is disabled from kernel option or not.
 	 */
-	if (!smp_found_config && detect_init_APIC()) {
+	if (!smp_found_config && (disable_apic || detect_init_APIC())) {
 		apic_phys = (unsigned long) alloc_bootmem_pages(PAGE_SIZE);
 		apic_phys = __pa(apic_phys);
 	} else

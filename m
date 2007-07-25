Return-Path: <linux-kernel-owner+w=401wt.eu-S1760244AbXGYGSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760244AbXGYGSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 02:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbXGYGRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 02:17:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:2074 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbXGYGRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 02:17:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZAQUg6RsYCEeujo8/RJJ+mkUCL2lLUmTYqE1s71ubJWar4t+kgQyY4xklz4zVWocF6C3RsqU21urhaWyn6s0z+Gaj+GPsPYUMB7wNtfYx8Xq/6wDTF4152w2eejxhxvOsVbmg/Ns60IeCRp0i8WNMc7g4X/ALpKgNC7OFoBdHJs=
Date: Wed, 25 Jul 2007 14:19:05 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]gx-suspmod.c use boot_cpu_data instead of current_cpu_data
Message-ID: <20070725141905.GA4567@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
in preemptible kernel will report BUG: using smp_processor_id() in preemptible, so use boot_cpu_data instead of current_cpu_data.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    4 ++--
1 file changed, 2 insertions(+), 2 deletions(-)

diff -pur linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c linux.new/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c
--- linux/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c	2007-07-25 14:11:06.000000000 +0000
+++ linux.new/arch/i386/kernel/cpu/cpufreq/gx-suspmod.c	2007-07-25 13:57:29.000000000 +0000
@@ -181,8 +181,8 @@ static __init struct pci_dev *gx_detect_
 	struct pci_dev *gx_pci = NULL;
 
 	/* check if CPU is a MediaGX or a Geode. */
-	if ((current_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
-	    (current_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
+	if ((boot_cpu_data.x86_vendor != X86_VENDOR_NSC) &&
+	    (boot_cpu_data.x86_vendor != X86_VENDOR_CYRIX)) {
 		dprintk("error: no MediaGX/Geode processor found!\n");
 		return NULL;
 	}

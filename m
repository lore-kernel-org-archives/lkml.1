Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbXJQFsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbXJQFsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 01:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXJQFs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 01:48:29 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:22605 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXJQFs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 01:48:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oGJ6MO79rWYNuMBYEqPeZVKS+CtkYkug5E2/arEpYJ/FAq14hwyNChpkMIVaCC2gvmXqXC2Umj/W0AGSHe1EUW5SVPSnpvd4aMzsgmKP1brtSqyOk1uNonKPpMGErAM0mE3LFXd6qt4ybMGgKeM1lxzrb4e9zHU4ZD75SqyfKFI=
Date: Wed, 17 Oct 2007 13:47:30 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
Cc: linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk
Subject: [PATCH][resend]gx-suspmod.c use boot_cpu_data instead of current_cpu_data
Message-ID: <20071017054729.GA7741@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

in preemptible kernel will report BUG: using smp_processor_id() in
preemptible, so use boot_cpu_data instead of current_cpu_data.

discussion in :
http://lkml.org/lkml/2007/7/25/32

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

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997Ab0AWLeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab0AWLeJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754745Ab0AWLeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:34:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43462 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab0AWLeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:34:06 -0500
Date: Sat, 23 Jan 2010 12:33:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, tglx@linutronix.de,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to mce_cpu_specific_poll
Message-ID: <20100123113359.GA29555@one.firstfloor.org>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100123051717.GA26471@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI, this commit triggered a -tip test failure:
> 
>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c: In function 'xeon75xx_mce_init':
>  arch/x86/kernel/cpu/mcheck/mce-xeon75xx.c:340: error: implicit declaration of function 'pci_match_id'

Does this patch fix it? (I assume your config is missing CONFIG_PCI)

-Andi

---

commit 748e9c041da32f173f20289c71ef0462b8e97234
Author: Andi Kleen <ak@linux.intel.com>
Date:   Sat Jan 23 12:34:10 2010 +0100

    Make xeon75xx memory driver dependent on PCI
    
    Found by Ingo Molnar's automated tester
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f62db24..ab2d0a8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -834,7 +834,7 @@ config X86_MCE_INTEL
 
 config X86_MCE_XEON75XX
 	tristate "Intel Xeon 7500 series corrected memory error driver"
-	depends on X86_MCE_INTEL
+	depends on X86_MCE_INTEL && PCI
 	---help---
 	   Add support for a Intel Xeon 7500 series specific memory error driver.
 	   This allows to report the DIMM and physical address on a corrected

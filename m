Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbZG3N4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbZG3N4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 09:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZG3N4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 09:56:39 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:28071 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750925AbZG3N4i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 09:56:38 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432R15bfO98dNzz1202hzzz32i6bh203h6di43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNLLDX-03-X5E-01
Date: Thu, 30 Jul 2009 15:56:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Sachin Sant <sachinp@in.ibm.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090730135623.GB16659@aftab>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au>
 <4A718338.6050907@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A718338.6050907@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 30 Jul 2009 13:56:20.0329 (UTC) FILETIME=[84354D90:01CA111D]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 30, 2009 at 04:55:44PM +0530, Sachin Sant wrote:
> Today's Next failed to boot on a x86_64 box with following traces
> 
> ACPI: Core revision 20090625
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353

I can't trigger it here, please send me your .config. In the meantime,
you could try the following:

--
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3ede593..5fd57fe 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1070,6 +1070,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	for_each_possible_cpu(i) {
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
-- 
1.6.3.3


-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


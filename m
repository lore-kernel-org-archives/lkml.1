Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbXKMUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbXKMUXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXKMUXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:23:13 -0500
Received: from gw.goop.org ([64.81.55.164]:37488 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818AbXKMUXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:23:12 -0500
Message-ID: <473A073C.2020201@goop.org>
Date: Tue, 13 Nov 2007 12:21:16 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Tobias Powalowski <t.powa@gmx.de>
CC: linux-kernel@vger.kernel.org, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86/paravirt: revert exports to restore old behaviour
References: <200711131139.42791.t.powa@gmx.de>
In-Reply-To: <200711131139.42791.t.powa@gmx.de>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: x86/paravirt: revert exports to restore old behaviour

Subdividing the paravirt_ops structure caused a regression in certain
non-GPL modules which try to use mmu_ops and cpu_ops.  This restores
the old behaviour, and makes it consistent with the
non-CONFIG_PARAVIRT case.

Tobias's mail:
> commit to .24 tree:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=93b1eab3d29e7ea32ee583de3362da84db06ded8
> 
> introduces:
> +EXPORT_SYMBOL_GPL(pv_mmu_ops);
> +EXPORT_SYMBOL_GPL(pv_cpu_ops);
> 
> pv_cpu_ops is for nvidia
> pv_mmu_ops' is for amd(ati)
> 
> which will break 32bit systems with paravirt enabled and trying to compile
> the binary graphic drivers from amd(ati) and nvidia.

[ Tobias: It would be nice to know exactly which operations the
  modules you're trying to compile are using. ]

Signed-off-by: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Tobias Powalowski <t.powa@gmx.de>
Cc: Zach Amsden <zach@vmware.com>

---
 arch/x86/kernel/paravirt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -440,8 +440,8 @@ struct pv_mmu_ops pv_mmu_ops = {
 };
 
 EXPORT_SYMBOL_GPL(pv_time_ops);
-EXPORT_SYMBOL_GPL(pv_cpu_ops);
-EXPORT_SYMBOL_GPL(pv_mmu_ops);
+EXPORT_SYMBOL    (pv_cpu_ops);
+EXPORT_SYMBOL    (pv_mmu_ops);
 EXPORT_SYMBOL_GPL(pv_apic_ops);
 EXPORT_SYMBOL_GPL(pv_info);
 EXPORT_SYMBOL    (pv_irq_ops);


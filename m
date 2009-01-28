Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZA1XjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZA1XjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbZA1XjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:39:00 -0500
Received: from gw.goop.org ([64.81.55.164]:38749 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZA1Xi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:38:59 -0500
Message-ID: <4980EC90.60105@goop.org>
Date: Wed, 28 Jan 2009 15:38:56 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC WIP] x86/paravirt: add register-saving thunks to	reduce
 caller register pressure
References: <4980A07D.3010008@goop.org> <1233183903.16317.242.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1233183903.16317.242.camel@bodhitayantram.eng.vmware.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Enable/Disable have no clobbers at all.
> Save clobbers only return value, %eax
> Restore also clobbers nothing.
>
> The patching code has gotten quite complex with the 32/64 union; let me
> apply it first and see before I comment on the patch.
>   

This gets it to compile.

diff -r 452b0aa6f629 arch/x86/kernel/vmi_32.c
--- a/arch/x86/kernel/vmi_32.c	Wed Jan 28 14:18:52 2009 -0800
+++ b/arch/x86/kernel/vmi_32.c	Wed Jan 28 15:37:54 2009 -0800
@@ -670,10 +670,11 @@
 	para_fill(pv_mmu_ops.write_cr2, SetCR2);
 	para_fill(pv_mmu_ops.write_cr3, SetCR3);
 	para_fill(pv_cpu_ops.write_cr4, SetCR4);
-	para_fill(pv_irq_ops.save_fl, GetInterruptMask);
-	para_fill(pv_irq_ops.restore_fl, SetInterruptMask);
-	para_fill(pv_irq_ops.irq_disable, DisableInterrupts);
-	para_fill(pv_irq_ops.irq_enable, EnableInterrupts);
+
+	para_fill(pv_irq_ops.save_fl.func, GetInterruptMask);
+	para_fill(pv_irq_ops.restore_fl.func, SetInterruptMask);
+	para_fill(pv_irq_ops.irq_disable.func, DisableInterrupts);
+	para_fill(pv_irq_ops.irq_enable.func, EnableInterrupts);
 
 	para_fill(pv_cpu_ops.wbinvd, WBINVD);
 	para_fill(pv_cpu_ops.read_tsc, RDTSC);

    J

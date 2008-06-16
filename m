Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYFPGbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYFPGbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757992AbYFPGad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:33 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50804 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757457AbYFPGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:30:07 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:30:06 -0700
Message-Id: <20080616063006.14597.73386.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 5/8] x86 boot: remap efi systab runtime from phys to virt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

One more efi entry needs its address converted from physical
to virtual during boot: efi.systab->runtime.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/arch/x86/kernel/efi.c	2008-06-13 00:53:10.053599898 -0700
+++ linux/arch/x86/kernel/efi.c	2008-06-13 00:53:21.762309008 -0700
@@ -486,6 +486,7 @@ void __init efi_enter_virtual_mode(void)
 		if (md->phys_addr <= systab && systab < end) {
 			systab += md->virt_addr - md->phys_addr;
 			efi.systab = (efi_system_table_t *) (unsigned long) systab;
+			efi.systab->runtime = __va(efi.systab->runtime);
 		}
 	}
 

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373

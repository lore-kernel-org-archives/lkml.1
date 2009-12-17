Return-Path: <linux-kernel-owner+w=401wt.eu-S936309AbZLQELZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936309AbZLQELZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936190AbZLQEFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:48 -0500
Received: from kroah.org ([198.145.64.141]:56007 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936183AbZLQEFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:44 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:57:00 2009
Message-Id: <20091217035700.108658513@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:57:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: [132/151] ACPI: Use the ARB_DISABLE for the CPU which model id is less than 0x0f.
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhao Yakui <yakui.zhao@intel.com>

commit 03a05ed1152944000151d57b71000de287a1eb02 upstream.

Currently, ARB_DISABLE is a NOP on all of the recent Intel platforms.
For such platforms, reduce contention on c3_lock by skipping the fake
ARB_DISABLE.

The cpu model id on one laptop is 14. If we disable ARB_DISABLE on this box,
the box can't be booted correctly. But if we still enable ARB_DISABLE on this
box, the box can be booted correctly.

So we still use the ARB_DISABLE for the cpu which mode id is less than 0x0f.

http://bugzilla.kernel.org/show_bug.cgi?id=14700

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Acked-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/acpi/cstate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -48,7 +48,7 @@ void acpi_processor_power_init_bm_check(
 	 * P4, Core and beyond CPUs
 	 */
 	if (c->x86_vendor == X86_VENDOR_INTEL &&
-	    (c->x86 > 0xf || (c->x86 == 6 && c->x86_model >= 14)))
+	    (c->x86 > 0xf || (c->x86 == 6 && c->x86_model >= 0x0f)))
 			flags->bm_control = 0;
 }
 EXPORT_SYMBOL(acpi_processor_power_init_bm_check);



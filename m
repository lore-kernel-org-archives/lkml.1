Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbZJIXSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbZJIXSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbZJIXSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:18:12 -0400
Received: from kroah.org ([198.145.64.141]:36868 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761736AbZJIXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:18:09 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Oct  9 16:10:03 2009
Message-Id: <20091009231003.396030841@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 09 Oct 2009 16:09:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhao Yakui <yakui.zhao@intel.com>, Len Brown <len.brown@intel.com>
Subject: [patch 26/26] ACPI: fix Compaq Evo N800c (Pentium 4m) boot hang regression
References: <20091009230836.316410305@mini.kroah.org>
Content-Disposition: inline; filename=acpi-fix-compaq-evo-n800c-boot-hang-regression.patch
In-Reply-To: <20091009231249.GA31084@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhao Yakui <yakui.zhao@intel.com>

commit 3e2ada5867b7e9fa0b296d30fa8f3726ebd0a8b7 upstream.

Don't disable ARB_DISABLE when the familary ID is 0x0F.

http://bugzilla.kernel.org/show_bug.cgi?id=14211

This was a 2.6.31 regression, and so this patch
needs to be applied to 2.6.31.stable

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
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
-	    (c->x86 > 0x6 || (c->x86 == 6 && c->x86_model >= 14)))
+	    (c->x86 > 0xf || (c->x86 == 6 && c->x86_model >= 14)))
 			flags->bm_control = 0;
 }
 EXPORT_SYMBOL(acpi_processor_power_init_bm_check);



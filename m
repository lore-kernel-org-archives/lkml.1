Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab0AOSJO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:09:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924Ab0AOSJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:09:13 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60518 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757779Ab0AOSJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:09:12 -0500
Date: Fri, 15 Jan 2010 12:09:09 -0600
From: Russ Anderson <rja@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [BUGFIX] x86, UV: ensure hub revision set for all ACPI modes.
Message-ID: <20100115180908.GB7757@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that UV hub revision is set for all ACPI modes.

Signed-off-by: Russ Anderson <rja@sgi.com>

---
Patch requires "Add function retrieving node controller revision number" patch.

 arch/x86/kernel/apic/x2apic_uv_x.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2010-01-15 10:47:54.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2010-01-15 10:48:44.000000000 -0600
@@ -67,7 +67,10 @@ static int early_get_nodeid(void)
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
+	int nodeid;
+
 	if (!strcmp(oem_id, "SGI")) {
+		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
@@ -75,7 +78,7 @@ static int __init uv_acpi_madt_oem_check
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
+				nodeid << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}
-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com

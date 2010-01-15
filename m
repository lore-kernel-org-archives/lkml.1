Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab0AOTZ3 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080Ab0AOTZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:25:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:37623 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758056Ab0AOTZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:25:20 -0500
Date: Fri, 15 Jan 2010 19:24:58 GMT
From: tip-bot for Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20100115180908.GB7757@sgi.com>
References: <20100115180908.GB7757@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, uv: Ensure hub revision set for all ACPI modes.
Message-ID: <tip-1d2c867c941d635e53e8ad7bf37d060bb5b25ec5@git.kernel.org>
Git-Commit-ID: 1d2c867c941d635e53e8ad7bf37d060bb5b25ec5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 15 Jan 2010 19:24:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1d2c867c941d635e53e8ad7bf37d060bb5b25ec5
Gitweb:     http://git.kernel.org/tip/1d2c867c941d635e53e8ad7bf37d060bb5b25ec5
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Fri, 15 Jan 2010 12:09:09 -0600
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 15 Jan 2010 11:09:04 -0800

x86, uv: Ensure hub revision set for all ACPI modes.

Ensure that UV hub revision is set for all ACPI modes.

Signed-off-by: Russ Anderson <rja@sgi.com>
LKML-Reference: <20100115180908.GB7757@sgi.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/apic/x2apic_uv_x.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 0e48de9..21db3cb 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -66,7 +66,10 @@ static int early_get_nodeid(void)
 
 static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
+	int nodeid;
+
 	if (!strcmp(oem_id, "SGI")) {
+		nodeid = early_get_nodeid();
 		x86_platform.is_untracked_pat_range =  uv_is_untracked_pat_range;
 		if (!strcmp(oem_table_id, "UVL"))
 			uv_system_type = UV_LEGACY_APIC;
@@ -74,7 +77,7 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
 			__get_cpu_var(x2apic_extra_bits) =
-				early_get_nodeid() << (UV_APIC_PNODE_SHIFT - 1);
+				nodeid << (UV_APIC_PNODE_SHIFT - 1);
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			return 1;
 		}

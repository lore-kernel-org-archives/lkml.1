Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXFCUuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXFCUuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753960AbXFCUr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:47:56 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:56377 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbXFCUrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:47:55 -0400
Date: Sun, 3 Jun 2007 22:48:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 16/19] kbuild: remove hardcoded apic_es7000 from modpost
Message-ID: <20070603204856.GQ9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 16/19] kbuild: remove hardcoded apic_es7000 from modpost
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2007 00:05:10 +0200

Replace the hardcoded variable name apic_es7000 in modpost
with a __initdata_refok marker.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/i386/mach-generic/es7000.c |    2 +-
 scripts/mod/modpost.c           |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/i386/mach-generic/es7000.c b/arch/i386/mach-generic/es7000.c
index b47f951..4742626 100644
--- a/arch/i386/mach-generic/es7000.c
+++ b/arch/i386/mach-generic/es7000.c
@@ -66,4 +66,4 @@ static int __init acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 }
 #endif
 
-struct genapic apic_es7000 = APIC_INIT("es7000", probe_es7000);
+struct genapic __initdata_refok apic_es7000 = APIC_INIT("es7000", probe_es7000);
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0f9130f..877ed0c 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -657,7 +657,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		"_probe",
 		"_probe_one",
 		"_console",
-		"apic_es7000",
 		NULL
 	};
 
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----

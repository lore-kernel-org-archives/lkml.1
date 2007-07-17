Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbXGQOLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbXGQOLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762550AbXGQOIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:08:00 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:35924 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761236AbXGQOHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:07:51 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 19/33] kbuild: remove hardcoded apic_es7000 from modpost
Date: Tue, 17 Jul 2007 16:08:48 +0200
Message-Id: <11846813443187-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11846813442297-git-send-email-sam@ravnborg.org>
References: 20070717140622.GA25846@uranus.ravnborg.org <11846813423231-git-send-email-sam@ravnborg.org> <11846813432423-git-send-email-sam@ravnborg.org> <1184681343138-git-send-email-sam@ravnborg.org> <11846813433593-git-send-email-sam@ravnborg.org> <11846813432300-git-send-email-sam@ravnborg.org> <11846813432072-git-send-email-sam@ravnborg.org> <11846813431389-git-send-email-sam@ravnborg.org> <1184681343412-git-send-email-sam@ravnborg.org> <11846813432249-git-send-email-sam@ravnborg.org> <1184681343297-git-send-email-sam@ravnborg.org> <11846813432231-git-send-email-sam@ravnborg.org> <1184681343423-git-send-email-sam@ravnborg.org> <11846813432234-git-send-email-sam@ravnborg.org> <11846813441521-git-send-email-sam@ravnborg.org> <11846813443387-git-send-email-sam@ravnborg.org> <1184681344594-git-send-email-sam@ravnborg.org> <11846813444176-git-send-email-sam@ravnborg.org> <11846813442297-git-send-email-sam@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 7f5ff7e..1921c43 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -647,7 +647,6 @@ static int secref_whitelist(const char *modname, const char *tosec,
 		"_probe",
 		"_probe_one",
 		"_console",
-		"apic_es7000",
 		NULL
 	};
 
-- 
1.5.0.6


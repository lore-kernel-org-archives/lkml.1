Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZKQWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZKQWLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756003AbZKQWLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 17:11:21 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:43835 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738AbZKQWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:19 -0500
Subject: [PATCH 2/3] ACPI: do not define acpi_processor_get_bios_limit() in
	processor.h
To: davej@redhat.com
From: Alex Chiang <achiang@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Date: Tue, 17 Nov 2009 15:11:25 -0700
Message-ID: <20091117221125.25933.71150.stgit@bob.kio>
In-Reply-To: <20091117220729.25933.57884.stgit@bob.kio>
References: <20091117220729.25933.57884.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we provide a definition for acpi_processor_get_bios_limit(), we will
encounter build errors (multiple definitions of the function) when we
do not have CONFIG_CPU_FREQ configured.

We've already changed the modules that depend on this function to only
get built when CONFIG_CPU_FREQ is configured, so removing the definition
when unconfigured is safe.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 include/acpi/processor.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/include/acpi/processor.h b/include/acpi/processor.h
index c94f9f0..9db2159 100644
--- a/include/acpi/processor.h
+++ b/include/acpi/processor.h
@@ -318,11 +318,6 @@ static inline int acpi_processor_ppc_has_changed(struct acpi_processor *pr,
 	}
 	return 0;
 }
-int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
-{
-	return -ENODEV;
-}
-
 #endif				/* CONFIG_CPU_FREQ */
 
 /* in processor_throttling.c */


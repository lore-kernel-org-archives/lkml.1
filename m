Return-Path: <linux-kernel-owner+w=401wt.eu-S1758425AbYBQMYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758425AbYBQMYd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755825AbYBQMXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:23:00 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55049 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbYBQMW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:22:56 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Len Brown <len.brown@intel.com>
Subject: [PATCH 11/27] acpi: fix section mismatch in processor_core.c:acpi_processor_hotplug_notify
Date: Sun, 17 Feb 2008 13:22:48 +0100
Message-Id: <1203250984-11285-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080217121255.GA10519@uranus.ravnborg.org>
References: <20080217121255.GA10519@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warning:
WARNING: vmlinux.o(.text+0x55586c): Section mismatch in reference from the function acpi_processor_hotplug_notify() to the function .cpuinit.text:acpi_processor_start()

acpi_processor_hotplug_notify() may safely reference __cpuinit
stuff as it ids defined inside an ACPI_HOTPLUG_CPU block.
So annotate it __ref to silence the warning.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index 75ccf5d..d3cc07f 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -881,8 +881,8 @@ int acpi_processor_device_add(acpi_handle handle, struct acpi_device **device)
 	return 0;
 }
 
-static void
-acpi_processor_hotplug_notify(acpi_handle handle, u32 event, void *data)
+static void __ref acpi_processor_hotplug_notify(acpi_handle handle,
+						u32 event, void *data)
 {
 	struct acpi_processor *pr;
 	struct acpi_device *device = NULL;
-- 
1.5.4.rc3.14.g44397


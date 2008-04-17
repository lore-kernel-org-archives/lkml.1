Return-Path: <linux-kernel-owner+w=401wt.eu-S933991AbYDQB3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933991AbYDQB3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762062AbYDQBJs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:09:48 -0400
Received: from sous-sol.org ([216.99.217.87]:59015 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769AbYDQBJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:09:46 -0400
Message-Id: <20080417010356.315553878@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alok Kataria <akataria@vmware.com>, Dan Arai <arai@vmware.com>,
       Len Brown <lenb@kernel.org>
Subject: acpi: fix "buggy BIOS check" when CPUs are hot removed
Content-Disposition: inline; filename=acpi-fix-buggy-bios-check-when-cpus-are-hot-removed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alok Kataria <akataria@vmware.com>

upstream commit: ba62b077871a5255e271f4fdae57167651839277

Fixes a BUG in ACPI hotplugging.

processor_device_array[pr->id] needs to be set to NULL when removing a CPU.
Else the "buggy BIOS check" in acpi_processor_start mistakenly fires when a
CPU is removed from the system and then later re-added.

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Signed-off-by: Dan Arai <arai@vmware.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/acpi/processor_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -792,7 +792,7 @@ static int acpi_processor_remove(struct 
 	acpi_processor_remove_fs(device);
 
 	processors[pr->id] = NULL;
-
+	processor_device_array[pr->id] = NULL;
 	kfree(pr);
 
 	return 0;

-- 

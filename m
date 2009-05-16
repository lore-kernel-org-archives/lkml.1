Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbZEPCeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbZEPCeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 22:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbZEPCed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 22:34:33 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:39936 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbZEPCed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 22:34:33 -0400
Date: Fri, 15 May 2009 22:34:15 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Bob Copeland <me@bobcopeland.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Lin Ming <ming.m.lin@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, yakui_zhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>
Subject: [PATCH] ACPI: resume: re-enable SCI-enable workaround
In-reply-to: <b6c5339f0905130830k3549095dv3eee08d7d3155a37@mail.gmail.com>
Message-id: <alpine.LFD.2.00.0905152233180.4571@localhost.localdomain>
References: <20090507105821.GA5864@hash.localnet>
 <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
 <1242192968.14626.40.camel@minggr.sh.intel.com>
 <200905131015.45635.rjw@sisk.pl>
 <b6c5339f0905130830k3549095dv3eee08d7d3155a37@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

The BIOS bug workaround mistakenly got disabled
when we followed the ACPI specification more closely
by ignoring OS updates to that bit.

(The BIOS is supposed to update SCI_EN, not the OS)

http://bugzilla.kernel.org/show_bug.cgi?id=13289

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---

as-applied.
thanks,
-Len

 drivers/acpi/acpica/aclocal.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 772ee5c..2ec394a 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -787,7 +787,12 @@ struct acpi_bit_register_info {
 
 /* For control registers, both ignored and reserved bits must be preserved */
 
-#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0201	/* Bits 9, 0(SCI_EN) */
+/*
+ * The ACPI spec says to ignore PM1_CTL.SCI_EN (bit 0)
+ * but we need to be able to write ACPI_BITREG_SCI_ENABLE directly
+ * as a BIOS workaround on some machines.
+ */
+#define ACPI_PM1_CONTROL_IGNORED_BITS           0x0200	/* Bits 9 */
 #define ACPI_PM1_CONTROL_RESERVED_BITS          0xC1F8	/* Bits 14-15, 3-8 */
 #define ACPI_PM1_CONTROL_PRESERVED_BITS \
 	       (ACPI_PM1_CONTROL_IGNORED_BITS | ACPI_PM1_CONTROL_RESERVED_BITS)
-- 
1.6.3.1.9.g95405b



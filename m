Return-Path: <linux-kernel-owner+w=401wt.eu-S1762271AbZBDTFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762271AbZBDTFP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:05:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761451AbZBDStr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:47 -0500
Received: from kroah.org ([198.145.64.141]:32986 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761422AbZBDSth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:37 -0500
Date: Wed, 4 Feb 2009 10:47:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <len.brown@intel.com>, Thomas Renninger <trenn@suse.de>
Subject: [patch 37/41] ACPI: Do not modify SCI_EN directly
Message-ID: <20090204184702.GL25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-do-not-modify-sci_en-directly.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Rafael J. Wysocki <rjw@sisk.pl>

commit 11e93130c7ce5228d484fd5e86f3984835d4256b upstream.

According to the ACPI specification the SCI_EN flag is controlled by
the hardware, which sets this flag to inform the kernel that ACPI is
enabled.  For this reason, we shouldn't try to modify SCI_EN
directly.  Also, we don't need to do it in irqrouter_resume(), since
lower-level resume code takes care of enabling ACPI in case it hasn't
been enabled by the BIOS before passing control to the kernel (which
by the way is against the ACPI specification).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/pci_link.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/acpi/pci_link.c
+++ b/drivers/acpi/pci_link.c
@@ -796,10 +796,6 @@ static int irqrouter_resume(struct sys_d
 	struct list_head *node = NULL;
 	struct acpi_pci_link *link = NULL;
 
-
-	/* Make sure SCI is enabled again (Apple firmware bug?) */
-	acpi_set_register(ACPI_BITREG_SCI_ENABLE, 1);
-
 	list_for_each(node, &acpi_link.entries) {
 		link = list_entry(node, struct acpi_pci_link, node);
 		if (!link) {


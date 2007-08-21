Return-Path: <linux-kernel-owner+w=401wt.eu-S1761392AbXHUGyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761392AbXHUGyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbXHUGxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:53:15 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44190 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333AbXHUGxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:53:13 -0400
Date: Mon, 20 Aug 2007 23:54:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>, Bob Moore <robert.moore@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 08/20] ACPICA: Fixed possible corruption of global GPE list
Message-ID: <20070821065450.GI5275@kroah.com>
References: <20070821064251.972690753@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-fixed-possible-corruption-of-global-gpe-list.patch"
In-Reply-To: <20070821065210.GA5275@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bob Moore <robert.moore@intel.com>

ACPICA: Fixed possible corruption of global GPE list

Fixed a problem in acpi_ev_delete_gpe_xrupt where the global interrupt
list could be corrupted if the interrupt being removed was at
the head of the list. Reported by Linn Crosetto.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/events/evgpeblk.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/events/evgpeblk.c
+++ b/drivers/acpi/events/evgpeblk.c
@@ -586,6 +586,10 @@ acpi_ev_delete_gpe_xrupt(struct acpi_gpe
 	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next = gpe_xrupt->next;
+	} else {
+		/* No previous, update list head */
+
+		acpi_gbl_gpe_xrupt_list_head = gpe_xrupt->next;
 	}
 
 	if (gpe_xrupt->next) {

-- 

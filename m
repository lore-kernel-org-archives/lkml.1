Return-Path: <linux-kernel-owner+w=401wt.eu-S933918AbXKOHK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbXKOHK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:10:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932589AbXKOGsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43798 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbXKOGs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:29 -0500
Date: Wed, 14 Nov 2007 22:46:03 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 40/40] ACPI: suspend: Wrong order of GPE restore.
Message-ID: <20071115064603.GO19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-suspend-wrong-order-of-gpe-restore.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 1dbc1fda5d8ca907f320b806005d4a447977d26a in mainline.

ACPI: suspend: Wrong order of GPE restore.

acpi_leave_sleep_state() should have correct list of wake and
runtime GPEs, which is available only after disable_wakeup_device()
is called.

[cebbert@redhat.com: backport to 2.6.23]

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -170,8 +170,8 @@ static int acpi_pm_finish(suspend_state_
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
-	acpi_leave_sleep_state(acpi_state);
 	acpi_disable_wakeup_device(acpi_state);
+	acpi_leave_sleep_state(acpi_state);
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
@@ -256,8 +256,8 @@ static int acpi_hibernation_enter(void)
 
 static void acpi_hibernation_finish(void)
 {
-	acpi_leave_sleep_state(ACPI_STATE_S4);
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
+	acpi_leave_sleep_state(ACPI_STATE_S4);
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);

-- 

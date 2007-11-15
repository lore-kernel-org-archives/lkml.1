Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXKOHKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXKOHKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932533AbXKOGsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:48:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43788 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbXKOGs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:48:27 -0500
Date: Wed, 14 Nov 2007 22:46:00 -0800
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
Subject: [patch 39/40] ACPI: sleep: Fix GPE suspend cleanup
Message-ID: <20071115064600.GN19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-sleep-fix-gpe-suspend-cleanup.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alexey Starikovskiy <astarikovskiy@suse.de>

patch is 9c1c6a1ba786d58bd03e27ee49f89a5685e8e07b in mainline.

ACPI: sleep: Fix GPE suspend cleanup

Commit 9b039330808b83acac3597535da26f47ad1862ce removed
acpi_gpe_sleep_prepare(), the only function used at S5 transition
Add call to generic acpi_enable_wake_device().

Reference: https://bugzilla.novell.com/show_bug.cgi?id=299882

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep/main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -389,6 +389,7 @@ static void acpi_power_off(void)
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk("%s called\n", __FUNCTION__);
 	local_irq_disable();
+	acpi_enable_wakeup_device(ACPI_STATE_S5);
 	acpi_enter_sleep_state(ACPI_STATE_S5);
 }
 

-- 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761195AbYKDX5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195AbYKDX5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbYKDXlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:41:06 -0500
Received: from mail.suse.de ([195.135.220.2]:47928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756947AbYKDXlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:41:05 -0500
Date: Tue, 4 Nov 2008 15:33:27 -0800
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
       alan@lxorguk.ukuu.org.uk, Len Brown <len.brown@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: [patch 52/57] ACPI: Clear WAK_STS on resume
Message-ID: <20081104233327.GA659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-clear-wak_sts-on-resume.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Matthew Garrett <mjg59@srcf.ucam.org>

Subject: [patch 52/57] ACPI: Clear WAK_STS on resume

commit a68823ee5285e65b51ceb96f8b13a5b4f99a6888 upstream.

ACPI: Clear WAK_STS on resume

The leading other brand OS appears to clear the WAK_STS flag on resume.
When rebooted, certain BIOSes assume that the system is actually
resuming if it's still set and so fail to reboot correctly. Make sure
that it's cleared at resume time.

Comment clarified as suggested by Bob Moore

http://bugzilla.kernel.org/show_bug.cgi?id=11634

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Romano Giannetti <romano.giannetti@gmail.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/hardware/hwsleep.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -612,6 +612,13 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	}
 	/* TBD: _WAK "sometimes" returns stuff - do we want to look at it? */
 
+	/*
+	 * Some BIOSes assume that WAK_STS will be cleared on resume and use
+	 * it to determine whether the system is rebooting or resuming. Clear
+	 * it for compatibility.
+	 */
+	acpi_set_register(ACPI_BITREG_WAKE_STATUS, 1);
+
 	acpi_gbl_system_awake_and_running = TRUE;
 
 	/* Enable power button */

-- 

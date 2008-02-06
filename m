Return-Path: <linux-kernel-owner+w=401wt.eu-S1765930AbYBGAKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765930AbYBGAKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764888AbYBFX5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:40 -0500
Received: from ns.suse.de ([195.135.220.2]:46021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764884AbYBFX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:38 -0500
Date: Wed, 6 Feb 2008 15:52:57 -0800
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
       Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: [patch 35/73] ACPICA: fix acpi_serialize hang regression
Message-ID: <20080206235257.GJ13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpica-fix-acpi_serialize-hang-regression.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Bob Moore <robert.moore@intel.com>

patch 014d433f35d7f34b55dcc7b57c7635aaefc3757f in mainline.

http://bugzilla.kernel.org/show_bug.cgi?id=8171

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/events/evregion.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/acpi/events/evregion.c
+++ b/drivers/acpi/events/evregion.c
@@ -344,7 +344,7 @@ acpi_ev_address_space_dispatch(union acp
 		 * setup will potentially execute control methods
 		 * (e.g., _REG method for this region)
 		 */
-		acpi_ex_relinquish_interpreter();
+		acpi_ex_exit_interpreter();
 
 		status = region_setup(region_obj, ACPI_REGION_ACTIVATE,
 				      handler_desc->address_space.context,
@@ -352,7 +352,7 @@ acpi_ev_address_space_dispatch(union acp
 
 		/* Re-enter the interpreter */
 
-		acpi_ex_reacquire_interpreter();
+		acpi_ex_enter_interpreter();
 
 		/* Check for failure of the Region Setup */
 
@@ -405,7 +405,7 @@ acpi_ev_address_space_dispatch(union acp
 		 * exit the interpreter because the handler *might* block -- we don't
 		 * know what it will do, so we can't hold the lock on the intepreter.
 		 */
-		acpi_ex_relinquish_interpreter();
+		acpi_ex_exit_interpreter();
 	}
 
 	/* Call the handler */
@@ -426,7 +426,7 @@ acpi_ev_address_space_dispatch(union acp
 		 * We just returned from a non-default handler, we must re-enter the
 		 * interpreter
 		 */
-		acpi_ex_reacquire_interpreter();
+		acpi_ex_enter_interpreter();
 	}
 
 	return_ACPI_STATUS(status);

-- 

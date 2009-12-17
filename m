Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbZLQBWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbZLQBWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:22:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763747AbZLQBVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:21:22 -0500
Received: from kroah.org ([198.145.64.141]:41530 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763721AbZLQBVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:10 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:09 2009
Message-Id: <20091217011609.499502645@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [88/90] thinkpad-acpi: fix default brightness_mode for R50e/R51
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit a9f8eacca4e9e8693de9b896c1fa7aadaa9402e8 upstream.

According to a report, the R50e wants EC-based brightness control,
even if it uses an Intel GPU.  The current driver default was reported
to not work at all.

This bug can be worked around by the "brightness_mode=3" module
parameter.

Change the default of the R50e and R51 2xxx models (which use the same
EC firmware, 1V) to TPACPI_BRGHT_Q_EC, but keep TPACPI_BRGHT_Q_ASK set
for now, as I'd like to get more reports.

This fixes a regression caused by commit
59fe4fe34d7afdf63208124f313be9056feaa2f4,
"thinkpad-acpi: fix incorrect use of TPACPI_BRGHT_MODE_ECNVRAM"

Kernel 2.6.31 also needs this fix.

Reported-by: Ferenc Wagner <wferi@niif.hu>
Tested-by: Ferenc Wagner <wferi@niif.hu>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: stable@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5663,8 +5663,8 @@ static const struct tpacpi_quirk brightn
 
 	/* Models with Intel Extreme Graphics 2 */
 	TPACPI_Q_IBM('1', 'U', TPACPI_BRGHT_Q_NOEC),
-	TPACPI_Q_IBM('1', 'V', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
-	TPACPI_Q_IBM('1', 'W', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
+	TPACPI_Q_IBM('1', 'V', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
+	TPACPI_Q_IBM('1', 'W', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
 
 	/* Models with Intel GMA900 */
 	TPACPI_Q_IBM('7', '0', TPACPI_BRGHT_Q_NOEC),	/* T43, R52 */



Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbZJBBcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbZJBBcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZJBBcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:33 -0400
Received: from kroah.org ([198.145.64.141]:32900 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbZJBBcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.357362216@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Len Brown <len.brown@intel.com>
Subject: [011/136] thinkpad-acpi: dont ask about brightness_mode for fw. 1V and 1R
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=thinkpad-acpi-don-t-ask-about-brightness_mode-for-fw.-1v-and-1r.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 6da25bf51689a5cc60370d30275dbb9e6852e0cb upstream.

X40 (firmware 1V) and T41 (firmware 1R) have been confirmed to work
well with the new defaults, so we can stop pestering people to confirm
that fact.

For now, whitelist just these two firmware types.  It is best to have
at least one more firmware type confirmed for Radeon 9xxx and Intel
GMA-2 ThinkPads before removing the confirmation requests entirely.

Reported-by: Robert de Rooy <robert.de.rooy@gmail.com>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5655,16 +5655,16 @@ static const struct tpacpi_quirk brightn
 	/* Models with ATI GPUs known to require ECNVRAM mode */
 	TPACPI_Q_IBM('1', 'Y', TPACPI_BRGHT_Q_EC),	/* T43/p ATI */
 
-	/* Models with ATI GPUs (waiting confirmation) */
-	TPACPI_Q_IBM('1', 'R', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
+	/* Models with ATI GPUs that can use ECNVRAM */
+	TPACPI_Q_IBM('1', 'R', TPACPI_BRGHT_Q_EC),
 	TPACPI_Q_IBM('1', 'Q', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
 	TPACPI_Q_IBM('7', '6', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
 	TPACPI_Q_IBM('7', '8', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_EC),
 
-	/* Models with Intel Extreme Graphics 2 (waiting confirmation) */
+	/* Models with Intel Extreme Graphics 2 */
+	TPACPI_Q_IBM('1', 'U', TPACPI_BRGHT_Q_NOEC),
 	TPACPI_Q_IBM('1', 'V', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
 	TPACPI_Q_IBM('1', 'W', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
-	TPACPI_Q_IBM('1', 'U', TPACPI_BRGHT_Q_ASK|TPACPI_BRGHT_Q_NOEC),
 
 	/* Models with Intel GMA900 */
 	TPACPI_Q_IBM('7', '0', TPACPI_BRGHT_Q_NOEC),	/* T43, R52 */



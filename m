Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbYIIDa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbYIIDa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbYIIDaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:30:20 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:55678 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207AbYIIDaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:30:20 -0400
X-Sasl-enc: NHAQrwoTU0ZEvfFUKJeGBop3HbjpOpUnEBc+q6PLAgLZ 1220931018
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>,
       Andi Kleen <ak@linux.intel.com>
Subject: [stable 2.6.26 PATCH] ACPI: Fix thermal shutdowns
Date: Tue,  9 Sep 2008 00:30:16 -0300
Message-Id: <1220931016-9557-1-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Milan Broz <mbroz@redhat.com>

Do not use unsigned int if there is test for negative number...

See drivers/acpi/processor_perflib.c
  static unsigned int ignore_ppc = -1;
...
  if (event == CPUFREQ_START && ignore_ppc <= 0) {
       ignore_ppc = 0;
...

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 cherry-picked from mainline 9f497bcc695fb828da023d74ad3c966b1e58ad21

 Let's see if this time it will make it for 2.6.26.6?  Without this
 patch, anything that needs passive cooling will just heat up until
 it either suffers an emergency thermal shutdown, or burns to cinders.

 PLEASE apply to 2.6.26 stable.  Thank you very much.

 drivers/acpi/processor_perflib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 8c06a53..6f4a5e1 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -70,7 +70,7 @@ static DEFINE_MUTEX(performance_mutex);
  *  0 -> cpufreq low level drivers initialized -> consider _PPC values
  *  1 -> ignore _PPC totally -> forced by user through boot param
  */
-static unsigned int ignore_ppc = -1;
+static int ignore_ppc = -1;
 module_param(ignore_ppc, uint, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");
-- 
1.5.6.5


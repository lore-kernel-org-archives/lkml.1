Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbYBKT75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbYBKT75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYBKT7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:59:40 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:33606 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390AbYBKT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:59:38 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/2]  tc1100-wmi - Fail gracefully if ACPI is disabled
Date: Mon, 11 Feb 2008 19:55:45 +0000
User-Agent: KMail/1.9.7
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200802080145.16774.lenb@kernel.org> <20080211091743.GA16459@elte.hu> <200802111923.31736.carlos@strangeworlds.co.uk>
In-Reply-To: <200802111923.31736.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802111955.46199.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 11 Feb 2008 19:55:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tc1100-wmi - Fail gracefully if ACPI is disabled

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

WMI drivers, like their ACPI counterparts, should also check if ACPI is
disabled or not, and bail out if so, otherwise we cause a crash.

Spotted by Ingo Molnar.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>
---

 drivers/misc/tc1100-wmi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/misc/tc1100-wmi.c b/drivers/misc/tc1100-wmi.c
index f25e4c9..cb8f79f 100644
--- a/drivers/misc/tc1100-wmi.c
+++ b/drivers/misc/tc1100-wmi.c
@@ -263,6 +263,9 @@ static int __init tc1100_init(void)
 {
 	int result = 0;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	if (!wmi_has_guid(GUID))
 		return -ENODEV;
 

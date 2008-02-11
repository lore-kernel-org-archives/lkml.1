Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYBKT7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYBKT7k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760833AbYBKT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:59:12 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:33605 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759093AbYBKT7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:59:08 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/2] acer-wmi - Fail gracefully if ACPI is disabled
Date: Mon, 11 Feb 2008 19:55:03 +0000
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
Message-Id: <200802111955.04562.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Mon, 11 Feb 2008 19:55:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acer-wmi - Fail gracefully if ACPI is disabled

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

 drivers/misc/acer-wmi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/misc/acer-wmi.c b/drivers/misc/acer-wmi.c
index d7aea93..6e81027 100644
--- a/drivers/misc/acer-wmi.c
+++ b/drivers/misc/acer-wmi.c
@@ -1029,6 +1029,9 @@ static int __init acer_wmi_init(void)
 {
 	int err;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	printk(ACER_INFO "Acer Laptop ACPI-WMI Extras version %s\n",
 			ACER_WMI_VERSION);
 

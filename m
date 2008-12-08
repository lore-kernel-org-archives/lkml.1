Return-Path: <linux-kernel-owner+w=401wt.eu-S1751794AbYLHSb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbYLHSb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 13:31:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYLHSbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 13:31:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYLHSbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 13:31:20 -0500
Date: Mon, 8 Dec 2008 13:31:18 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20081208183127.20608.27645.sendpatchset@prarit.bos.redhat.com>
Subject: [PATCH]: Implement nopmtmr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have notsc and nohpet. Add nopmtmr for consistency.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index c201710..94246c9 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -248,3 +248,10 @@ static int __init parse_pmtmr(char *arg)
 	return 1;
 }
 __setup("pmtmr=", parse_pmtmr);
+
+static int __init disable_pmtmr(char *str)
+{
+	pmtmr_ioport = 0;
+	return 1;
+}
+__setup("nopmtmr", disable_pmtmr);

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbZEVIXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbZEVIXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:23:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZEVIXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:23:44 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:59335 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757221AbZEVIXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:23:41 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI processor: remove spurious newline from warning message
Date: Fri, 22 May 2009 10:23:40 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
       Len Brown <len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905221023.41843.elendil@planet.nl>
X-OriginalArrivalTime: 22 May 2009 08:23:42.0341 (UTC) FILETIME=[9DD14350:01C9DAB6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI processor: remove spurious newline from warning message

Commit 4973b22a ("ACPI processor: reset the throttling state once it's
invalid") introduced a new warning which prints a spurious newline.
    
The ACPI_WARNING macro that is used already takes care of adding a
newline, after adding ACPI_CA_VERSION to the message. Remove the newline
to avoid the message getting split into two lines.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 7f16f5f..2275437 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -840,7 +840,7 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 		state = acpi_get_throttling_state(pr, value);
 		if (state == -1) {
 			ACPI_WARNING((AE_INFO,
-				"Invalid throttling state, reset\n"));
+				"Invalid throttling state, reset"));
 			state = 0;
 			ret = acpi_processor_set_throttling(pr, state);
 			if (ret)

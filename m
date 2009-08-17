Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZHQMpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZHQMpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 08:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZHQMpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 08:45:41 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:55393 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbZHQMpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 08:45:40 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org
Subject: [PATCH 2/2] ACPI processor: remove superfluous warning message
Date: Mon, 17 Aug 2009 14:45:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, lenb@intel.com,
       rui.zhang@intel.com
References: <200908171443.35622.elendil@planet.nl>
In-Reply-To: <200908171443.35622.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908171445.40785.elendil@planet.nl>
X-OriginalArrivalTime: 17 Aug 2009 12:45:40.0550 (UTC) FILETIME=[A089DE60:01CA1F38]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This failure is very common on many platforms.
Handling it in the ACPI processor driver is enough, and we don't
need a warning message unless CONFIG_ACPI_DEBUG is set.

Based on a patch from Zhang Rui.

http://bugzilla.kernel.org/show_bug.cgi?id=13389

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 841be4e..ae39797 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -840,8 +840,8 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 	if (ret >= 0) {
 		state = acpi_get_throttling_state(pr, value);
 		if (state == -1) {
-			ACPI_WARNING((AE_INFO,
-				"Invalid throttling state, reset"));
+			ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+				"Invalid throttling state, reset\n"));
 			state = 0;
 			ret = acpi_processor_set_throttling(pr, state, true);
 			if (ret)

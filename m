Return-Path: <linux-kernel-owner+w=401wt.eu-S1750934AbXCOHRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750934AbXCOHRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 03:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXCOHRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 03:17:03 -0400
Received: from smtp108.sbc.mail.mud.yahoo.com ([68.142.198.207]:47514 "HELO
	smtp108.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750865AbXCOHRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 03:17:01 -0400
X-YMail-OSG: 2Qe2WQcVM1nr0FEoOrfd_5uauHLK6toRdCNXdIQAZ5suulPTsLxi8C1xDTKxrg.tSkW7GzAj_m7FfqmL0Y36F1TIXfPdyAauhvT9biyXhzuMs6T0ZcS5.iWKanlGbxHuguv_kyB66URhl_E-
Date: Thu, 15 Mar 2007 00:10:19 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Len Brown <lenb@kernel.org>, ibm-acpi@hmh.eng.br
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI_IBM_BAY can not coexist with ACPI_BAY
Message-ID: <20070315071019.GA22613@tuatara.stupidest.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI_IBM_BAY cannot coexist with ACPI_BAY --- it causes the IBM ACPI
code to fail to initialize so all the IBM ACPI functionality is
missing.  The simplest fix is to just make sure the Kconfig magic
disallows ACPI_IBM_BAY when ACPI_BAY is enabled.

Signed-off-by: Chris Wedgwood <cw@f00f.org>

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index e2ce4a9..1a83fc6 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -246,7 +246,7 @@ config ACPI_IBM_DOCK
 
 config ACPI_IBM_BAY
 	bool "Legacy Removable Bay Support"
-	depends on ACPI_IBM
+	depends on ACPI_IBM && !ACPI_BAY
 	default y
 	---help---
 	  Allows the ibm_acpi driver to handle removable bays.  It will allow


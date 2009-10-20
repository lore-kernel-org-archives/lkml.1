Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbZJTUM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbZJTUM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbZJTUM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:12:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46006 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZJTUM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:12:56 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH] ima: remove ACPI dependency
Date: Tue, 20 Oct 2009 16:12:38 -0400
Message-Id: <1256069558-4222-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ACPI dependency on systems without a TPM enabled.

Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/ima/Kconfig |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 53d9764..3ca39e7 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -2,14 +2,12 @@
 #
 config IMA
 	bool "Integrity Measurement Architecture(IMA)"
-	depends on ACPI
 	select SECURITYFS
 	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select TCG_TPM
-	select TCG_TIS
+	select ACPI if TCG_TPM
 	help
 	  The Trusted Computing Group(TCG) runtime Integrity
 	  Measurement Architecture(IMA) maintains a list of hash
@@ -18,12 +16,12 @@ config IMA
 	  to change the contents of an important system file
 	  being measured, we can tell.
 
-	  If your system has a TPM chip, then IMA also maintains
-	  an aggregate integrity value over this list inside the
-	  TPM hardware, so that the TPM can prove to a third party
-	  whether or not critical system files have been modified.
-	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
-	  to learn more about IMA.
+	  If your system has a TPM chip, and it is enabled, then
+	  IMA also maintains an aggregate integrity value over
+	  this list inside the TPM hardware, so that the TPM can
+	  prove to a third party whether or not critical system
+	  files have been modified. To learn more about IMA, read
+	  <http://www.usenix.org/events/sec04/tech/sailer.html>
 	  If unsure, say N.
 
 config IMA_MEASURE_PCR_IDX
-- 
1.6.0.6


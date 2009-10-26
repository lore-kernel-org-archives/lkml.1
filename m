Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbZJZN0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbZJZN0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754796AbZJZN0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:26:42 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54686 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbZJZN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:26:41 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
       Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Stable Kernel <stable@kernel.org>
Subject: [PATCH] ima: remove ACPI dependency
Date: Mon, 26 Oct 2009 09:26:19 -0400
Message-Id: <1256563579-11014-2-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove ACPI dependency on systems without a TPM enabled.

Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Acked-by: Jean-Christophe Dubois <jcd@tribudubois.net>
Cc: Stable Kernel <stable@kernel.org>
---
 security/integrity/ima/Kconfig |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 3d7846d..3ca39e7 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -2,15 +2,12 @@
 #
 config IMA
 	bool "Integrity Measurement Architecture(IMA)"
-	depends on ACPI
-	depends on SECURITY
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
@@ -19,12 +16,12 @@ config IMA
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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZJYSSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZJYSSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 14:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZJYSSC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 14:18:02 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:45949 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953AbZJYSSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 14:18:00 -0400
From: "Jean-Christophe Dubois" <jcd@tribudubois.net>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ima: remove ACPI dependency
Date: Sun, 25 Oct 2009 20:17:51 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.28-15-generic; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
References: <1256069558-4222-1-git-send-email-zohar@linux.vnet.ibm.com>
In-Reply-To: <1256069558-4222-1-git-send-email-zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QZJ5KuSKy0sxqRy"
Message-Id: <200910251917.52284.jcd@tribudubois.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QZJ5KuSKy0sxqRy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

le mardi 20 octobre 2009 Mimi Zohar a =E9crit
> Remove ACPI dependency on systems without a TPM enabled.
>
> Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

This patch requires that another patch is first applied (as reported by Mim=
i in=20
the attached email).

Tested on top of 2.6.30 and 2.6.31 on armv5 platform (versatilePB) with bot=
h=20
patches applied.

Acked-by: Jean-Christophe Dubois <jcd@tribudubois.net>

> ---
>  security/integrity/ima/Kconfig |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/security/integrity/ima/Kconfig
> b/security/integrity/ima/Kconfig index 53d9764..3ca39e7 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -2,14 +2,12 @@
>  #
>  config IMA
>  	bool "Integrity Measurement Architecture(IMA)"
> -	depends on ACPI
>  	select SECURITYFS
>  	select CRYPTO
>  	select CRYPTO_HMAC
>  	select CRYPTO_MD5
>  	select CRYPTO_SHA1
> -	select TCG_TPM
> -	select TCG_TIS
> +	select ACPI if TCG_TPM
>  	help
>  	  The Trusted Computing Group(TCG) runtime Integrity
>  	  Measurement Architecture(IMA) maintains a list of hash
> @@ -18,12 +16,12 @@ config IMA
>  	  to change the contents of an important system file
>  	  being measured, we can tell.
>
> -	  If your system has a TPM chip, then IMA also maintains
> -	  an aggregate integrity value over this list inside the
> -	  TPM hardware, so that the TPM can prove to a third party
> -	  whether or not critical system files have been modified.
> -	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
> -	  to learn more about IMA.
> +	  If your system has a TPM chip, and it is enabled, then
> +	  IMA also maintains an aggregate integrity value over
> +	  this list inside the TPM hardware, so that the TPM can
> +	  prove to a third party whether or not critical system
> +	  files have been modified. To learn more about IMA, read
> +	  <http://www.usenix.org/events/sec04/tech/sailer.html>
>  	  If unsure, say N.
>
>  config IMA_MEASURE_PCR_IDX



--Boundary-00=_QZJ5KuSKy0sxqRy
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Mimi Zohar <zohar@linux.vnet.ibm.com>: Re: [Fwd: [PATCH] ima: remove ACPI dependency]
Content-Disposition: inline

Return-Path: zohar@linux.vnet.ibm.com
X-Spam-Checker-Version: SpamAssassin 3.2.5 (2008-06-10) on jcd-desktop
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
	autolearn=ham version=3.2.5
Received: from mx1.w4a.fr (LHLO mx1.w4a.fr) (91.121.53.100) by mx1.w4a.fr
 with LMTP; Fri, 23 Oct 2009 18:55:01 +0200 (CEST)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mx1.w4a.fr (Postfix) with ESMTP id 394FB13E4B
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 18:54:59 +0200 (CEST)
X-Virus-Scanned: amavisd-new at srv-05.w4a.fr
Received: from mx1.w4a.fr ([127.0.0.1])
	by localhost (mx1.w4a.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5QlDyb71qEtZ for <jcd@tribudubois.net>;
	Fri, 23 Oct 2009 18:54:54 +0200 (CEST)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by mx1.w4a.fr (Postfix) with ESMTP id 57F2C13E28
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 18:54:54 +0200 (CEST)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n9NGj2ci026599
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 12:45:02 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9NGsu1O1200322
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 12:54:57 -0400
Received: from d01av01.pok.ibm.com (d03av01 [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id n9NGsu0b015395
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 12:54:56 -0400
Received: from [9.65.108.78] (sig-9-65-108-78.mts.ibm.com [9.65.108.78])
	by d01av01.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVin) with ESMTP id n9NGsuRD015374
	for <jcd@tribudubois.net>; Fri, 23 Oct 2009 12:54:56 -0400
Subject: Re: [Fwd: [PATCH] ima: remove ACPI dependency]
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jean-Christophe Dubois <jcd@tribudubois.net>
In-Reply-To: <1256243034.12894.5.camel@dyn9002018117.watson.ibm.com>
References: <1256243034.12894.5.camel@dyn9002018117.watson.ibm.com>
Content-Type: multipart/mixed;
  boundary="=-vkxNFLbosZ64Ia/E6s/R"
Date: Fri, 23 Oct 2009 12:54:56 -0400
Message-Id: <1256316896.4059.5.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
X-UID: 


--=-vkxNFLbosZ64Ia/E6s/R
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

JC,

Sorry, this patch requires changes in the include/linux/tpm.h.  Attached
is a TPM patch.

Mimi

On Thu, 2009-10-22 at 16:23 -0400, Mimi Zohar wrote:
> JC,
> 
> It seems that James is waiting for an ACK or some type of
> acknowledgement from you.  Would you mind giving it a try?
> 
> Thanks!
> 
> Mimi
> 
> -------- Forwarded Message --------
> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
> To: linux-kernel@vger.kernel.org
> Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Jean-Christophe Dubois
> <jcd@tribudubois.net>, James Morris <jmorris@namei.org>, David Safford
> <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
> Subject: [PATCH] ima: remove ACPI dependency
> Date: Tue, 20 Oct 2009 16:12:38 -0400
> 
> Remove ACPI dependency on systems without a TPM enabled.
> 
> Reported-by: Jean-Christophe Dubois <jcd@tribudubois.net>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  security/integrity/ima/Kconfig |   16 +++++++---------
>  1 files changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
> index 53d9764..3ca39e7 100644
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -2,14 +2,12 @@
>  #
>  config IMA
>  	bool "Integrity Measurement Architecture(IMA)"
> -	depends on ACPI
>  	select SECURITYFS
>  	select CRYPTO
>  	select CRYPTO_HMAC
>  	select CRYPTO_MD5
>  	select CRYPTO_SHA1
> -	select TCG_TPM
> -	select TCG_TIS
> +	select ACPI if TCG_TPM
>  	help
>  	  The Trusted Computing Group(TCG) runtime Integrity
>  	  Measurement Architecture(IMA) maintains a list of hash
> @@ -18,12 +16,12 @@ config IMA
>  	  to change the contents of an important system file
>  	  being measured, we can tell.
> 
> -	  If your system has a TPM chip, then IMA also maintains
> -	  an aggregate integrity value over this list inside the
> -	  TPM hardware, so that the TPM can prove to a third party
> -	  whether or not critical system files have been modified.
> -	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
> -	  to learn more about IMA.
> +	  If your system has a TPM chip, and it is enabled, then
> +	  IMA also maintains an aggregate integrity value over
> +	  this list inside the TPM hardware, so that the TPM can
> +	  prove to a third party whether or not critical system
> +	  files have been modified. To learn more about IMA, read
> +	  <http://www.usenix.org/events/sec04/tech/sailer.html>
>  	  If unsure, say N.
> 
>  config IMA_MEASURE_PCR_IDX

--=-vkxNFLbosZ64Ia/E6s/R
Content-Disposition: attachment; filename="tpm-add-default-definitions.patch"
Content-Type: text/x-patch; name="tpm-add-default-definitions.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

tpm add default function definitions

Add default tpm_pcr_read/extend function definitions required
by IMA/Kconfig changes.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>

Index: security-testing-2.6/include/linux/tpm.h
===================================================================
--- security-testing-2.6.orig/include/linux/tpm.h
+++ security-testing-2.6/include/linux/tpm.h
@@ -31,5 +31,12 @@
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
 extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
+#else
+static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
+	return -ENODEV;
+}
+static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
+	return -ENODEV;
+}
 #endif
 #endif

--=-vkxNFLbosZ64Ia/E6s/R--


--Boundary-00=_QZJ5KuSKy0sxqRy--

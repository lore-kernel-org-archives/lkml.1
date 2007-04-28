Return-Path: <linux-kernel-owner+w=401wt.eu-S1031125AbXD1Wf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031125AbXD1Wf3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031138AbXD1Wf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:35:29 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33544 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031125AbXD1Wf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:35:27 -0400
Date: Sat, 28 Apr 2007 15:37:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herbert@gondor.apana.org.au
Subject: Re: [PATCH] crypto: Use padlock.ko only as a module
Message-Id: <20070428153707.50f1644a.randy.dunlap@oracle.com>
In-Reply-To: <463379FA.9080004@simon.arlott.org.uk>
References: <463379FA.9080004@simon.arlott.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 17:44:42 +0100 Simon Arlott wrote:

> The padlock.ko module is completely useless when compiled in 
> because it can't do anything and gets run too early to output 
> anything useful:
> 
> [    6.052000] padlock: No VIA PadLock drivers have been loaded.
> [    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
> [    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/crypto/Makefile |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 6059cf8..f0f7a73 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -1,4 +1,6 @@
> -obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
> +ifeq ($(CONFIG_CRYPTO_DEV_PADLOCK),m)
> +obj-m += padlock.o
> +endif
>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
>  obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
>  obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
> -- 

I think that we prefer to enforce config symbols in Kconfig files,
not in Makefiles.  E.g.,

---
 drivers/crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2621-pv.orig/drivers/crypto/Kconfig
+++ linux-2621-pv/drivers/crypto/Kconfig
@@ -2,7 +2,7 @@ menu "Hardware crypto devices"
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32
+	depends on X86_32 && m
 	select CRYPTO_ALGAPI
 	default m
 	help


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***

Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXK3LD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXK3LD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbXK3LDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:03:21 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:13635 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661AbXK3LDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q+mpc3/lTuSTWjyNWYN3yB0U2oOb8GfQV6rTE+fiE/lurQEUAguvfqi0CYT0+jvS6RjwNVt55WKUiVMoY8nTWKUrXL1bbqYrqz+CVFtM01oYAImgE+pO3a6DpKWLvCKwSM2uLJ5FI3nuh6mNkkfSYMiGA1mNi41Fiw7yk6bCbAk=
Message-ID: <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com>
Date: Fri, 30 Nov 2007 16:33:19 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
In-Reply-To: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes s390 dependency for x86

Signed-off-by: Jaswinder Singh <jaswinderlinux@gmail.com>


diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 1330061..b699ed5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -537,4 +537,6 @@ source "security/Kconfig"

 source "crypto/Kconfig"

+source "arch/s390/crypto/Kconfig"
+
 source "lib/Kconfig"
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5fd6688..5c2c7eb 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -48,8 +48,6 @@ config CRYPTO_DEV_PADLOCK_SHA
 	  If unsure say M. The compiled module will be
 	  called padlock-sha.ko

-source "arch/s390/crypto/Kconfig"
-
 config CRYPTO_DEV_GEODE
 	tristate "Support for the Geode LX AES engine"
 	depends on X86_32 && PCI
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 6972f26..529be08 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -1,6 +1,8 @@
 #include <linux/stat.h>
 #include <linux/sysctl.h>
+#ifdef CONFIG_S390
 #include "../arch/s390/appldata/appldata.h"
+#endif
 #include "../fs/xfs/linux-2.6/xfs_sysctl.h"
 #include <linux/sunrpc/debug.h>
 #include <linux/string.h>


On 11/30/07, Jaswinder Singh <jaswinderlinux@gmail.com> wrote:
> 2.6.24-rc3 git kernel's x86 make depends on s390 arch:
>
> 1.   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86/Kconfig
> drivers/crypto/Kconfig:51: can't open file "arch/s390/crypto/Kconfig"
> make[2]: *** [silentoldconfig] Error 1
> make[1]: *** [silentoldconfig] Error 2
>
> 2.  CC      kernel/sysctl_check.o
> kernel/sysctl_check.c:3:44: error: ../arch/s390/appldata/appldata.h:
> No such file or directory
> make[1]: *** [kernel/sysctl_check.o] Error 1
> make: *** [kernel] Error 2
>
> Thank you,
>
> Jaswinder Singh.
>

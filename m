Return-Path: <linux-kernel-owner+w=401wt.eu-S1754066AbZJAPLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066AbZJAPLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZJAPL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:11:29 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:52748 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZJAPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:11:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=b1goYtj+Fpwx6JC9st5KEIntRl8jVmcWb9WJ0yk509aZQ/k6dMZkplT9rtskm5/ZLz
         gHi4fHkvRXjLZ4NfqCtuH37hUgZvkW185H+X7yk2dc+tn9K0EJXzX4OyoUxcllE1eE4K
         6WBeuX3H+1qtNfmOvmWM3an0TyfbnIaHWP8q0=
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Thu, 1 Oct 2009 17:11:10 +0200
Message-ID: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com>
Subject: [PATCH] AMD Geode LX optimizations
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
i found that we can optimize a bit the kernel for the AMD Geode LX.
I made this simple patch against a 2.6.31 kernel.
Tested, compiles and works fine.

Signed-off-by: Matteo Croce <technoboy85@gmail.com>

--- a/arch/x86/Makefile_32.cpu	2009-09-10 21:16:53.198243207 +0200
+++ b/arch/x86/Makefile_32.cpu	2009-09-10 21:21:28.434245121 +0200
@@ -39,7 +39,7 @@

 # Geode GX1 support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
-
+cflags-$(CONFIG_MGEODE_LX)	+= $(call cc-option,-march=geode,-march=pentium-mmx)
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
--- a/arch/x86/Kconfig.cpu	2009-10-01 16:51:56.567771217 +0200
+++ b/arch/x86/Kconfig.cpu	2009-10-01 16:52:25.936010648 +0200
@@ -397,7 +397,7 @@
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || X86_64)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM ||
MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE ||
MEFFICEON || MGEODE_LX || X86_64)

 config X86_MINIMUM_CPU_FAMILY
 	int

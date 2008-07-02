Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbYGBX4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbYGBX4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbYGBX4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:56:16 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:41796 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYGBX4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:56:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=tbV8RUeuzSsg04mMPtCVlWcUg1thBwglGhk9BOg3OrZI8sw8Zy500pUFyfqM3Piw9K
         KYhkk5jOEERAoAaLt/YyExuq52B2dJ9y/RplZ0G+hNVr31QtJ2FwoiHqmPcP3WBIYDXv
         la+kIBp/BxfcEl9wR/J+Hdmtbmm2NI/NQmrac=
Message-ID: <486C159C.4020108@gmail.com>
Date: Wed, 02 Jul 2008 16:56:12 -0700
From: Khem Raj <raj.khem@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, lethal@linux-sh.org
Subject: sh-asm/unistd.h userspace cleanup
X-Enigmail-Version: 0.95.0
OpenPGP: id=A57A7A6E;
	url=pool.sks-keyservers.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

CONFIG_SUPERH32 is currently trickling into userspace unistd.h. Attached patch uses __SH5__define  in userspace.

Thanks

-Khem

Signed-off-by: Khem Raj <raj.khem@gmail.com>

diff --git a/include/asm-sh/unistd.h b/include/asm-sh/unistd.h
index 4b21f36..65be656 100644
--- a/include/asm-sh/unistd.h
+++ b/include/asm-sh/unistd.h
@@ -1,5 +1,13 @@
-#ifdef CONFIG_SUPERH32
-# include "unistd_32.h"
+#ifdef __KERNEL__
+# ifdef CONFIG_SUPERH32
+#  include "unistd_32.h"
+# else
+#  include "unistd_64.h"
+# endif
 #else
-# include "unistd_64.h"
+# ifdef __SH5__
+#  include "unistd_64.h"
+# else
+#  include "unistd_32.h"
+# endif
 #endif


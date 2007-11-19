Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbXKSW7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbXKSW7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:59:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKSW7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:59:00 -0500
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:43979 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbXKSW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:58:59 -0500
Date: Mon, 19 Nov 2007 23:58:57 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: correctly set UTS_MACHINE for "make ARCH=x86"
Message-ID: <20071119225857.GA5129@devil>
References: <20071117143731.GA7129@uranus.ravnborg.org> <20071119093437.GA5104@devil> <20071119104129.GA10731@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119104129.GA10731@uranus.ravnborg.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Upon request I have updated the patch description
and hope it is now more explanatory.

IMHO this should go into 2.6.24.
BTW, the patch was tested with v2.6.24-rc3-19-g2ffbb83.


Regards,

Andreas

--
x86: correctly set UTS_MACHINE for "make ARCH=x86"

For a kernel built with "make ARCH=x86" the following system
information is displayed when running the new kernel

    $ uname -m
    x86

On some i386 systems (e.g. K7) we even have the following information

    $ uname -m
    x66

This is weird. The usual information for "uname -m" should be "x86_64"
on 64-bit and "i386" or "i686" on 32-bit.

This patch fixes the issue by setting UTS_MACHINE to "i386" for 32-bit
kernel builds and to "x86_64" for 64-bit kernel builds. I.e., "x86"
won't be used for UTS_MACHINE anymore.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andreas Herrmann <aherrman@arcor.de>

---
 arch/x86/Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 116b03a..7aa1dc6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -11,10 +11,9 @@ endif
 $(srctree)/arch/x86/Makefile%: ;
 
 ifeq ($(CONFIG_X86_32),y)
+        UTS_MACHINE := i386
         include $(srctree)/arch/x86/Makefile_32
 else
+        UTS_MACHINE := x86_64
         include $(srctree)/arch/x86/Makefile_64
 endif
-
-
-
-- 
1.5.3.4



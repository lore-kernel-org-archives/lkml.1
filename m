Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbXKSJet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbXKSJet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 04:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXKSJem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 04:34:42 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:45680 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752504AbXKSJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 04:34:41 -0500
Date: Mon, 19 Nov 2007 10:34:37 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: fix UTS_MACHINE to be i386 for 32-bit build and x86_64 for 64-bit build
Message-ID: <20071119093437.GA5104@devil>
References: <20071117143731.GA7129@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117143731.GA7129@uranus.ravnborg.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 03:37:31PM +0100, Sam Ravnborg wrote:
> 
> Note: This patch does not fix the uname -m issue - to do so
> Andreas' patch is needed.
> 
> 	Sam

Linus,

The issue Sam refers to is that UTS_MACHINE is set to "x86" instead of
"i386" or "x86_64" when building with ARCH=x86. Thus the new kernel
when booted will give either "x86" on x86_64 and many i386 systems or
even "x66" on other i386 systems for 'uname -m'.

Many tools rely on the usual values of "x86_64", "i366" and "i686"
here. So we shouldn't change this.

Attached patch fixes that issue. Please apply.


Regards,

Andreas

--
x86: fix UTS_MACHINE to be i386 for 32-bit build and x86_64 for 64-bit build

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
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



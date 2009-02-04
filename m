Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbZBDO26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbZBDO26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 09:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZBDO2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 09:28:50 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:49890 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZBDO2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 09:28:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Pdc2gSGC5yIerMXVk2GFIQVHaYpZ/JHBw4d9saevOdSm85QH9HORPKt767ZKlMgDoM
         iNI8l6rRRlVeGos5kUJ/zw0+YM+ODjSfmEKSHzzavj1U2GGSVs+6Ba++NoUVyGkXWaYb
         69Y2Zj3pPgunLsMBawy+r3dByhRfZvC34faoc=
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 15:28:47 +0100
Message-ID: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
Subject: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Floris Kraak <randakar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some distributions have enabled the gcc flag -Wformat-security by default.*
This results in a number of warnings about format arguments to
functions, sometimes in cases where fixing the warning is not likely
to actually fix a bug.
Instead of hand patching a dozens of places (possibly more) that
produce warnings that get ignored anyway we just turn off the flag in
the Makefile.

Note: Regardless of any discussion surrounding the value of this
particular type of warning, having this show up in a few distributions
but not in the
vast majority of them means that this warning won't be seen by most of
the developers who introduce the new warnings in the first place. If
the
kernel decides it cares about format arguments it should do so
globally regardless of distribution. In which case I'd gladly whip up
a patch to do
the reverse thing and turn this thing on by default. However, such a
patch would have to produce a follow up patch(set) which fixes each
individual
warning.

See also:
http://kerneltrap.org/mailarchive/linux-kernel/2008/11/20/4215134

*) The ubuntu manpage for gcc states:

      -Wformat-security
          If -Wformat is specified, also warn about uses of format
functions that represent possible security problems.  At present, this
warns about
          calls to "printf" and "scanf" functions where the format
string is not a string literal and there are no format arguments, as
in "printf
          (foo);".  This may be a security hole if the format string
came from untrusted input and contains %n.  (This is currently a
subset of what
          -Wformat-nonliteral warns about, but in future warnings may
be added to -Wformat-security that are not included in
-Wformat-nonliteral.)

          NOTE: In Ubuntu 8.10 and later versions this option is
enabled by default for C, C++, ObjC, ObjC++.  To disable, use
-Wno-format-security, or
          disable all format warnings with -Wformat=0.  To make format
security warnings fatal, specify -Werror=format-security.

Signed-off-by: Floris Kraak <randakar@gmail.com>
---
diff --git a/Makefile b/Makefile
index 7715b2c..9ee766c 100644
--- a/Makefile
+++ b/Makefile
@@ -346,7 +346,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__

 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
-		   -Werror-implicit-function-declaration
+		   -Werror-implicit-function-declaration \
+		   -Wno-format-security
 KBUILD_AFLAGS   := -D__ASSEMBLY__

 # Read KERNELRELEASE from include/config/kernel.release (if it exists)

---
"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."
  -- Ben Franklin

"The course of history shows that as a government grows, liberty
decreases."
  -- Thomas Jefferson

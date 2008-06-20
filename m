Return-Path: <linux-kernel-owner+w=401wt.eu-S1756649AbYFTNp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756649AbYFTNp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 09:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYFTNpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 09:45:19 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:49233 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754212AbYFTNpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 09:45:18 -0400
Date: Fri, 20 Jun 2008 15:45:12 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Sam Ravnborg <sam@ravnborg.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>
cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] kbuild: sparse needs CF not CHECKFLAGS
Message-ID: <Pine.LNX.4.64.0806201542200.27182@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-805383586-1213969512=:27182"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-805383586-1213969512=:27182
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Documentation/sparse.txt tells to use:

    make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"

However, this still doesn't enable endian checks. The correct syntax is:

    make C=2 CF="-D__CHECK_ENDIAN__"

This documentation bug was introduced by the following commit:

    commit 1c7bafe7206d928eaccbcbd08d868733e0fb7054
    Author: Robert P. J. Day <rpjday@mindspring.com>
    Date:   Wed Sep 13 07:57:50 2006 -0400

	kbuild: clarify "make C=" build option
	    
	Clarify the use of "make C=" in the top-level Makefile, and fix a
	typo in the Documentation file.

	Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

This `typo' was not a typo, as `CF' had been introduced much earlier, by:

    commit 7b49bb9aff8b14d15da58111d8908c877c0a525e
    Author: viro@ZenIV.linux.org.uk <viro@ZenIV.linux.org.uk>
    Date:   Fri Sep 9 21:14:35 2005 +0100

	[PATCH] kbuild: CF=<arguments> passes arguments to sparse
	
	Allows to add to sparse arguments without mutilating makefiles - just
	pass CF=<arguments> and they will be added to CHECKFLAGS.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Documentation/sparse.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/sparse.txt
+++ b/Documentation/sparse.txt
@@ -73,10 +73,10 @@ recompiled, or use "make C=2" to run spa
 be recompiled or not.  The latter is a fast way to check the whole tree if you
 have already built it.
 
-The optional make variable CHECKFLAGS can be used to pass arguments to sparse.
-The build system passes -Wbitwise to sparse automatically.  To perform
-endianness checks, you may define __CHECK_ENDIAN__:
+The optional make variable CF can be used to pass arguments to sparse.  The
+build system passes -Wbitwise to sparse automatically.  To perform endianness
+checks, you may define __CHECK_ENDIAN__:
 
-        make C=2 CHECKFLAGS="-D__CHECK_ENDIAN__"
+        make C=2 CF="-D__CHECK_ENDIAN__"
 
 These checks are disabled by default as they generate a host of warnings.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-805383586-1213969512=:27182--

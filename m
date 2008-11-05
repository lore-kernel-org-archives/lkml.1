Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYKEQkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYKEQkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYKEQj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:39:58 -0500
Received: from lazybastard.de ([212.112.238.170]:48785 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYKEQj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:39:57 -0500
Date: Wed, 5 Nov 2008 17:39:41 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [Patch] Always include <linux/types.h>
Message-ID: <20081105163941.GB6561@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817069-5969-1-git-send-email-bharrosh@panasas.com> <20081104180347.GA9818@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081104180347.GA9818@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardly any file in the kernel can be compiled without including
<linux/types.h>, directly or indirectly.  And I'd wager a beer that
noone can find a non-trivial example.  I couldn't.

So instead of sprinkling even more #include <linux/types.h> everywhere -
140 headers in include/linux/ would need that to compile standalone -
let us just pass it automatically.

The existing 4000 odd includes for types.h, plus some 300 each for
compiler.h and stddef.h, which get pulled through types.h, can get
removed at leasure.

diff --git a/Makefile b/Makefile
index 6192922..8a3fb66 100644
--- a/Makefile
+++ b/Makefile
@@ -326,7 +326,8 @@ AFLAGS_KERNEL	=
 # Needed to be compatible with the O= option
 LINUXINCLUDE    := -Iinclude \
                    $(if $(KBUILD_SRC),-Iinclude2 -I$(srctree)/include) \
-		   -include include/linux/autoconf.h
+		   -include include/linux/autoconf.h \
+		   -include include/linux/types.h
 
 KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXINCLUDE)
 

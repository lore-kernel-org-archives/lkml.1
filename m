Return-Path: <linux-kernel-owner+w=401wt.eu-S1422958AbXBHMMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422958AbXBHMMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 07:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422960AbXBHMMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 07:12:32 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38734
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1422958AbXBHMMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 07:12:30 -0500
Date: Thu, 08 Feb 2007 04:12:29 -0800 (PST)
Message-Id: <20070208.041229.18308943.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: checker-shell still hosed...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070208.041004.07457320.davem@davemloft.net>
References: <20070208.030531.112264703.davem@davemloft.net>
	<20070208.041004.07457320.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 08 Feb 2007 04:10:04 -0800 (PST)

> Removing them makes the spaces go away.

FWIW, this patch below seems to fix the sparc64 build for me.

Paul, does it work for you on powerpc too?

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 8d7eabf..a1880e8 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -60,16 +60,15 @@ endef
 # Usage: option = $(call checker-shell,$(CC)...-o $$OUT,option-ok,otherwise)
 # Exit code chooses option. $$OUT is safe location for needless output.
 define checker-shell
- $(strip
-  $(shell set -e; \
-    DIR=$(KBUILD_EXTMOD); \
-    cd $${DIR:-$(objtree)}; \
-    OUT=$$PWD/.$$$$.null; \
-    if $(1) >/dev/null 2>&1; \
-      then echo "$(2)"; \
-      else echo "$(3)"; \
-    fi; \
-    rm -f $$OUT))
+$(shell set -e; \
+  DIR=$(KBUILD_EXTMOD); \
+  cd $${DIR:-$(objtree)}; \
+  OUT=$$PWD/.$$$$.null; \
+  if $(1) >/dev/null 2>&1; \
+    then echo "$(2)"; \
+    else echo "$(3)"; \
+  fi; \
+  rm -f $$OUT)
 endef
 
 # as-option

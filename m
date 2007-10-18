Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbXJRTCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbXJRTCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 15:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759244AbXJRTC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 15:02:26 -0400
Received: from sccrmhc13.comcast.net ([204.127.200.83]:33974 "EHLO
	sccrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104AbXJRTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 15:02:25 -0400
Date: Thu, 18 Oct 2007 11:01:57 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, Armin Kuster <akuster@mvista.com>
Subject: [PATCH] kbuild: Disable depmod in cross-compile kernel build
Message-ID: <20071018180157.GA11408@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When building embedded systems in a cross-compile environment and
populating a target's file system image, we don't want to run the 
depmod on the host as we may be building for a completely different
architecture. Since there's no such thing as a cross-depmod, we
just disable running depmod in the cross-compile case and we just
run depmod on the target at bootup.

Signed-off-by: Armin Kuster <akuster@mvista.com>
Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

diff --git a/Makefile b/Makefile
index 529b904..1705a91 100644
--- a/Makefile
+++ b/Makefile
@@ -1032,7 +1032,11 @@ depmod_opts	:= -b $(INSTALL_MOD_PATH) -r
 endif
 PHONY += _modinst_post
 _modinst_post: _modinst_
-	if [ -r System.map -a -x $(DEPMOD) ]; then $(DEPMOD) -ae -F System.map $(depmod_opts) $(KERNELRELEASE); fi
+	@if [ "$(CROSS_COMPILE)" = "" ]; then \
+		if [ -r System.map -a -x $(DEPMOD) ]; then \
+			$(DEPMOD) -ae -F System.map $(depmod_opts) $(KERNELRELEASE); \
+		fi \
+	fi
 
 else # CONFIG_MODULES
 

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net 

"He who sacrifices freedom for security deserves neither" - Ben Franklin

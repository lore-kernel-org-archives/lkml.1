Return-Path: <linux-kernel-owner+w=401wt.eu-S1765920AbXGaQ2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765920AbXGaQ2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 12:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759866AbXGaQ16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 12:27:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56196 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588AbXGaQ15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 12:27:57 -0400
Date: Tue, 31 Jul 2007 22:10:16 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David Woodhouse <dwmw2@infradead.org>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Make headers_check less chatty for success cases
Message-ID: <alpine.LFD.0.999.0707312206140.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Sam,

"make headers_check" is too verbose. It likes to chat even if it has
just _successfully_ checked a header, and not just on seeing errors.
What is worse, even if you touch just one little header in some corner
(or possibly none) and type "make" on an "already-made" tree,
headers_check still feels obliged to check all the headers.

Both the above things combined mean that when you're working on your own
little subsystem, and simply "make" an already-made tree, and turn around
to speak to a colleague, then by the time you look back at the screen, it
does not contain any useful warnings from the actual compilation stage.
If you're unlucky, the entire scroll-back history of the xterm would have
also got polluted with headers_check's "CHECK include/linux/foo.h" spam.

As a result I've been totally put off by it and have CONFIG_HEADERS_CHECK=n
set in my .config -- but that could lead to breakages. Hence:


[PATCH] Make headers_check less chatty for success cases

We still echo verbosely (and fail, obviously) for any errors encountered.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

[ just removing that line also works, but that loses symmetry with others ]

 scripts/Makefile.headersinst |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.headersinst b/scripts/Makefile.headersinst
index 53dae3e..0a23dd9 100644
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -96,7 +96,7 @@ quiet_cmd_unifdef	  = UNIFDEF $(patsubst $(INSTALL_HDR_PATH)/%,%,$@)
       cmd_unifdef	  = $(UNIFDEF) $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/%,$(srctree)/$(obj)/%,$@) \
 				   | $(HDRSED) > $@ || :
 
-quiet_cmd_check		  = CHECK   $(patsubst $(INSTALL_HDR_PATH)/$(_dst)/.check.%,$(_dst)/%,$@)
+quiet_cmd_check		  =
       cmd_check		  = $(CONFIG_SHELL) $(srctree)/scripts/hdrcheck.sh \
                               $(INSTALL_HDR_PATH)/include $(subst /.check.,/,$@) $@
 

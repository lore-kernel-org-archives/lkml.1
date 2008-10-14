Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYJNIgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYJNIgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJNIgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:36:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:41348 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYJNIgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:36:37 -0400
Subject: [patch] fix not working KBUILD_EXTRA_SYMBOLS
From: Peter Volkov <pva@gentoo.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-CctLecU9x5b3S5z0298B"
Date: Tue, 14 Oct 2008 12:34:22 +0400
Message-Id: <1223973262.16586.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CctLecU9x5b3S5z0298B
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


If you even define KBUILD_EXTRA_SYMBOLS in Makefile it will not be
expanded into command line argument for modpost. Patch in a

Note: this bug was reported and kernel bugzilla:
http://bugzilla.kernel.org/show_bug.cgi?id=11567
and patch was included in -mm tree.

The patch was generated against 2.6.26 kernel but I suppose it should
work applies to the linux/kernel/git/torvalds/linux-2.6.git too.

-- 
Peter.

--=-CctLecU9x5b3S5z0298B
Content-Disposition: attachment; filename=linux-2.6-KBUILD_EXTRA_SYMBOLS.patch
Content-Type: text/x-patch; name=linux-2.6-KBUILD_EXTRA_SYMBOLS.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- scripts/Makefile.modpost.orig	2008-09-14 13:34:16.000000000 +0400
+++ scripts/Makefile.modpost	2008-09-14 13:34:41.000000000 +0400
@@ -82,7 +82,7 @@
  $(if $(CONFIG_MODULE_SRCVERSION_ALL),-a,)       \
  $(if $(KBUILD_EXTMOD),-i,-o) $(kernelsymfile)   \
  $(if $(KBUILD_EXTMOD),-I $(modulesymfile))      \
- $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(EXTRA_SYMBOLS))) \
+ $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
  $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
  $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
  $(if $(CONFIG_MARKERS),-K $(kernelmarkersfile)) \

--=-CctLecU9x5b3S5z0298B--


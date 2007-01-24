Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXAXAo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXAXAo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965471AbXAXAo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:44:56 -0500
Received: from raven.upol.cz ([158.194.120.4]:42858 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbXAXAoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:44:55 -0500
Date: Wed, 24 Jan 2007 00:53:06 +0000
To: Linus Torvalds <torvalds@osdl.org>, Sam Ravnborg <sam@ravnborg.org>
Cc: kbuild <kbuild-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] kbuild: create KBUILD_OUTPUT
Message-ID: <20070124005305.GA30155@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kbuild: create KBUILD_OUTPUT

 When requesting build to another directory, try to create it first.

Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Oleg Verych <olecom@flower.upol.cz>
---

,-*- bash -*-
|olecom@deen:~/kernel.org/_work/src/linux-2.6.20-rc5$
|olecom@deen:~/kernel.org/_work/src/linux-2.6.20-rc5$ make O=/tmp/build
|cd: 1: can't cd to /tmp/build
|Makefile:116: *** output directory "/tmp/build" does not exist.  Stop.
|olecom@deen:~/kernel.org/_work/src/linux-2.6.20-rc5$ patch -p1 <../../va-patch/
|kbuild-create-output-dir.patch
|patching file Makefile
|olecom@deen:~/kernel.org/_work/src/linux-2.6.20-rc5$ make O=/tmp/build
|HOSTCC scripts/basic/fixdep HOSTCC scripts/basic/docproc make[3]: ***
|[scripts/basic/docproc] Interrupt make[2]: *** [scripts_basic] Interrupt
|make: *** [_all] Interrupt
|
|olecom@deen:~/kernel.org/_work/src/linux-2.6.20-rc5$
`-*-

--- linux-2.6.20-rc5/Makefile~orig	2007-01-12 19:54:26.000000000 +0100
+++ linux-2.6.20-rc5/Makefile	2007-01-24 00:59:55.926951750 +0100
@@ -113,5 +113,5 @@
 # check that the output directory actually exists
 saved-output := $(KBUILD_OUTPUT)
-KBUILD_OUTPUT := $(shell cd $(KBUILD_OUTPUT) && /bin/pwd)
+KBUILD_OUTPUT := $(shell d=$(KBUILD_OUTPUT) ; mkdir -p $$d && cd $$d && pwd)
 $(if $(KBUILD_OUTPUT),, \
      $(error output directory "$(saved-output)" does not exist))

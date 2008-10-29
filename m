Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYJ2SVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYJ2SVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYJ2SVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:21:39 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39876 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbYJ2SVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:21:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: include localarch for simple cross overrides
Date: Wed, 29 Oct 2008 14:21:35 -0400
Message-Id: <1225304495-28079-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For people banging on kernel trees which are dedicated to a specific arch,
it'd be nice to allow the repo itself to declare the default ARCH (and
CROSS_COMPILE) easily.  Just like the "localversion-*" files, people can
just do:
echo 'ARCH ?= blackfin' > localarch
and the tree will default to 'blackfin' all the time rather than whatever
the build machine happens to be.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index a7f2068..7fa1f81 100644
--- a/Makefile
+++ b/Makefile
@@ -180,6 +180,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # make ARCH=ia64
 # Another way is to have ARCH set in the environment.
 # The default ARCH is the host where make is executed.
+-include localarch
 
 # CROSS_COMPILE specify the prefix used for all executables used
 # during compilation. Only gcc and related bin-utils executables
-- 
1.6.0.2


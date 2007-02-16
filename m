Return-Path: <linux-kernel-owner+w=401wt.eu-S1946105AbXBPVwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946105AbXBPVwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 16:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946074AbXBPVwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 16:52:04 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46151 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599AbXBPVwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 16:52:02 -0500
Date: Fri, 16 Feb 2007 22:52:13 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Andrew Morton <akpm@osdl.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] override build timestamp
Message-ID: <20070216215213.GA10732@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Pass a timestamp to kbuild via an enviroment variable.

    TZ=UTC BUILD_TIMESTAMP=2007-01-01 make -kj O=../O vmlinux

This can be used when the kernel source is in a SCM and uname -v
is supposed to give the commit date and not the package build time.

Signed-off-by: Olaf Hering <olaf@aepfle.de>

---
 scripts/mkcompile_h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/scripts/mkcompile_h
===================================================================
--- linux-2.6.orig/scripts/mkcompile_h
+++ linux-2.6/scripts/mkcompile_h
@@ -30,7 +30,12 @@ UTS_VERSION="#$VERSION"
 CONFIG_FLAGS=""
 if [ -n "$SMP" ] ; then CONFIG_FLAGS="SMP"; fi
 if [ -n "$PREEMPT" ] ; then CONFIG_FLAGS="$CONFIG_FLAGS PREEMPT"; fi
-UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS `LC_ALL=C LANG=C date`"
+if [ -n "$BUILD_TIMESTAMP" ]; then
+  TIMESTAMP="`LC_ALL=C LANG=C date -d "$BUILD_TIMESTAMP"`"
+else
+  TIMESTAMP="`LC_ALL=C LANG=C date`"
+fi
+UTS_VERSION="$UTS_VERSION $CONFIG_FLAGS $TIMESTAMP"
 
 # Truncate to maximum length
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZAJD4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZAJD4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 22:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZAJD4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 22:56:38 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36492 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZAJD4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 22:56:37 -0500
Date: Sat, 10 Jan 2009 04:56:13 +0100
From: Andi Kleen <andi@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] KBUILD: Create the source symlink earlier in the objdir
Message-ID: <20090110035613.GA7225@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KBUILD: Create the source symlink earlier in the objdir

It's useful to already have the source symlink in a 
objdir when one just runs make *config. Then one
can do 

mkdir obj-allyes
cd obj-allyes
make -C ../sourcedir O=$(pwd) allyesconfig
./source/scripts/config --disable debug_info
make CC=icecc -j18

without having to interrupt the make first just to
get the source symlink.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)


Index: linux-2.6.28-kbuild/Makefile
===================================================================
--- linux-2.6.28-kbuild.orig/Makefile	2009-01-07 22:16:49.000000000 +0100
+++ linux-2.6.28-kbuild/Makefile	2009-01-10 04:50:53.000000000 +0100
@@ -383,6 +383,7 @@
 # output directory.
 outputmakefile:
 ifneq ($(KBUILD_SRC),)
+	@ln -fsn $(srctree) $(objtree)/source
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/mkmakefile \
 	    $(srctree) $(objtree) $(VERSION) $(PATCHLEVEL)
 endif

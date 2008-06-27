Return-Path: <linux-kernel-owner+w=401wt.eu-S1763411AbYF0VTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763411AbYF0VTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbYF0VS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:18:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:38522 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYF0VS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:18:57 -0400
Date: Fri, 27 Jun 2008 23:19:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: David Woodhouse <david.woodhouse@intel.com>
Subject: [GIT PULL] one fix for -rc
Message-ID: <20080627211943.GA3726@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

A simple headers_install fix.
It will manifest itself only when you use "make O=... headers_install"

Please pull from:

    ssh://master.kernel.org/pub/scm/linux/kernel/git/sam/kbuild-fixes.git master

	Sam


 include/asm-generic/Kbuild.asm |    2 +-
 include/asm-powerpc/Kbuild     |    1 -
 include/linux/Kbuild           |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

commit 7026103a24c2c6a264e7fcc5dfe614094f0c1b43
Author: David Woodhouse <david.woodhouse@intel.com>
Date:   Fri Jun 27 14:39:42 2008 +0100

    kbuild: fix a.out.h export to userspace with O= build.

    We need to check for existence of the a.out.h header in the source tree,
    not the object tree, if we want it to get the right answer with O=.

    Signed-off-by: David Woodhouse <david.woodhouse@intel.com>
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>


diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 92a6d91..7cd25b8 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,6 +1,6 @@
 header-y  += kvm.h
 
-ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += auxvec.h
diff --git a/include/asm-powerpc/Kbuild b/include/asm-powerpc/Kbuild
index 7381916..bca352e 100644
--- a/include/asm-powerpc/Kbuild
+++ b/include/asm-powerpc/Kbuild
@@ -1,6 +1,5 @@
 include include/asm-generic/Kbuild.asm
 
-header-y += a.out.h
 header-y += auxvec.h
 header-y += ioctls.h
 header-y += mman.h
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index b6fbb25..71d70d1 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -166,7 +166,7 @@ unifdef-y += acct.h
 unifdef-y += adb.h
 unifdef-y += adfs_fs.h
 unifdef-y += agpgart.h
-ifeq ($(wildcard include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
 endif
 unifdef-y += apm_bios.h

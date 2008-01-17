Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYAQN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYAQN4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752856AbYAQN4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:56:37 -0500
Received: from free-electrons.com ([88.191.23.47]:48192 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYAQN4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:56:35 -0500
X-Greylist: delayed 1137 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jan 2008 08:56:35 EST
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86: clean arch/[i386|x86_64] in make mrproper
Date: Thu, 17 Jan 2008 14:37:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171437.25038.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies to: 2.6.24-rc8-git1

For backward compatibility with earlier (< 2.6.24) kernels,
arch/i386/boot/bzImage or arch/x86_64/boot/bzImage
symbolic links to arch/x86/boot/bzImage
are created when you build an x86 kernel.
The arch/i386 or arch/x86_64 directories are then
created for this only purpose.

Issue: these generated directories and symbolic
links are *not cleaned up* when you run
"make mrproper" (and thus "make distclean").
This disturbs the production of patches,
because the source tree is left with generated files
and directories.

Proposed fix: add arch/i386 and arch/x86_84 to
the list of directories cleaned by "make mrproper"

Cleaner solution: stop creating these symbolic
links, but this could cause issues with scripts
still expecting bzImage in arch/i386/boot/bzImage
or in arch/x86_64/boot/bzImage.

What do you think? I can submit another patch for
the second option.

Michael.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
--- linux-2.6.24-rc8-git1/Makefile	2008-01-17 09:54:22.000000000 +0100
+++ linux-2.6.24-rc8-git1-mrproper-x86/Makefile	2008-01-17 10:49:19.000000000 +0100
@@ -1088,7 +1088,7 @@
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
+MRPROPER_DIRS  += include/config include2 usr/include arch/i386 arch/x86_64
 MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \


-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

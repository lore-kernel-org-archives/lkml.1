Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZJBCCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZJBCCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZJBCCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 22:02:00 -0400
Received: from kroah.org ([198.145.64.141]:32886 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbZJBBca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:30 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012407.066667319@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Magnus Granberg <zorry@ume.nu>, "Jory A. Pratt" <anarchy@gentoo.org>,
       Fredric Johansson <johansson_fredric@hotmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [009/136] kbuild: fix cc1 options check to ensure we do not use -fPIC when compiling
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=kbuild-fix-cc1-options-check-to-ensure-we-do-not-use-fpic-when-compiling.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jory A. Pratt <anarchy@gentoo.org>

commit c47efe5548abbf53c2f66e06dcb46183b11d6b22 upstream.

The arch/*/boot/Makefile use cc-options to check for GCC command options
and cc-options use the hardened specs when checking for GCC command
options.  When -fPIE is pass to cc1 it can't use -ffreestanding or
-fno-toplevel-reorder.  Then it fail to build stuff with -ffreestanding
and -fno-toplevel-reorder.

Thanks to Fredric Johansson for finding the main problem behind a failed
build using a hardened toolchain.

Signed-off-by: Magnus Granberg <zorry@ume.nu>
Signed-off-by: Jory A. Pratt <anarchy@gentoo.org>
Cc: Fredric Johansson <johansson_fredric@hotmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/Kbuild.include |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -105,12 +105,12 @@ as-instr = $(call try-run,\
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
 
 cc-option = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",$(1),$(2))
 
 # cc-option-yn
 # Usage: flag := $(call cc-option-yn,-march=winchip-c6)
 cc-option-yn = $(call try-run,\
-	$(CC) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) $(1) -c -xc /dev/null -o "$$TMP",y,n)
 
 # cc-option-align
 # Prefix align with either -falign or -malign



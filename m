Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZGQUlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZGQUlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZGQUlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:41:50 -0400
Received: from kroah.org ([198.145.64.141]:50671 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbZGQUlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:41:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Jul 17 13:38:25 2009
Message-Id: <20090717203825.073449115@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 17 Jul 2009 13:37:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [patch 8/8] Dont use -fwrapv compiler option: its buggy in gcc-4.1.x
References: <20090717203718.637372453@mini.kroah.org>
Content-Disposition: inline; filename=don-t-use-fwrapv-compiler-option-it-s-buggy-in-gcc-4.1.x.patch
In-Reply-To: <20090717203935.GA5641@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit a137802ee839ace40079bebde24cfb416f73208a upstream.

This causes kernel images that don't run init to completion with certain
broken gcc versions.

This fixes kernel bugzilla entry:
	http://bugzilla.kernel.org/show_bug.cgi?id=13012

I suspect the gcc problem is this:
	http://gcc.gnu.org/bugzilla/show_bug.cgi?id=28230

Fix the problem by using the -fno-strict-overflow flag instead, which
not only does not exist in the known-to-be-broken versions of gcc (it
was introduced later than fwrapv), but seems to be much less disturbing
to gcc too: the difference in the generated code by -fno-strict-overflow
are smaller (compared to using neither flag) than when using -fwrapv.

Reported-by: Barry K. Nathan <barryn@pobox.com>
Pushed-by: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -557,7 +557,7 @@ KBUILD_CFLAGS += $(call cc-option,-Wdecl
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
 # disable invalid "can't wrap" optimzations for signed / pointers
-KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
+KBUILD_CFLAGS	+= $(call cc-option,-fno-strict-overflow)
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so



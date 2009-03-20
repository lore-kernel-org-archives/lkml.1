Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZCTXOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZCTXOh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:14:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbZCTXNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:36 -0400
Received: from kroah.org ([198.145.64.141]:53012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754734AbZCTXNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:09 2009
Message-Id: <20090320222709.381022572@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 03/32] Move cc-option to below arch-specific setup
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=move-cc-option-to-below-arch-specific-setup.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit d0115552cdb0b4d4146975889fee2e9355515c4b upstream.

Sam Ravnborg says:
 "We have several architectures that plays strange games with $(CC) and
  $(CROSS_COMPILE).

  So we need to postpone any use of $(call cc-option..) until we have
  included the arch specific Makefile so we try with the correct $(CC)
  version."

Requested-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -341,7 +341,6 @@ KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXI
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration
-KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)
@@ -556,6 +555,9 @@ KBUILD_CFLAGS += $(call cc-option,-Wdecl
 # disable pointer signed / unsigned warnings in gcc 4.0
 KBUILD_CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 
+# disable invalid "can't wrap" optimzations for signed / pointers
+KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
+
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
 # But warn user when we do so
 warn-assign = \



Return-Path: <linux-kernel-owner+w=401wt.eu-S1760013AbZCTXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013AbZCTXOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754599AbZCTXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:34 -0400
Received: from kroah.org ([198.145.64.141]:52992 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754199AbZCTXNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:33 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:09 2009
Message-Id: <20090320222709.233703776@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:13 -0700
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
Subject: [patch 02/32] Add -fwrapv to gcc CFLAGS
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=add-fwrapv-to-gcc-cflags.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 68df3755e383e6fecf2354a67b08f92f18536594 upstream.

This makes sure that gcc doesn't try to optimize away wrapping
arithmetic, which the kernel occasionally uses for overflow testing, ie
things like

	if (ptr + offset < ptr)

which technically is undefined for non-unsigned types. See

	http://bugzilla.kernel.org/show_bug.cgi?id=12597

for details.

Not all versions of gcc support it, so we need to make it conditional
(it looks like it was introduced in gcc-3.4).

Reminded-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -341,6 +341,7 @@ KBUILD_CPPFLAGS := -D__KERNEL__ $(LINUXI
 KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
 		   -fno-strict-aliasing -fno-common \
 		   -Werror-implicit-function-declaration
+KBUILD_CFLAGS	+= $(call cc-option,-fwrapv)
 KBUILD_AFLAGS   := -D__ASSEMBLY__
 
 # Read KERNELRELEASE from include/config/kernel.release (if it exists)



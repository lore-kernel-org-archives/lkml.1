Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565AbXJVUZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbXJVUZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 16:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXJVUY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 16:24:59 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:57788 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbXJVUY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 16:24:59 -0400
Date: Mon, 22 Oct 2007 16:24:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Nix <nix@esperi.org.uk>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
Message-ID: <20071022202406.GA9556@c2.user-mode-linux.org>
References: <200710111754.46854.rob@landley.net> <200710200252.37919.p.giarrusso@gmail.com> <87y7dyhv2u.fsf@hades.wkstn.nix> <20071021114854.GF2455@hacking> <20071021130848.GA4621@c2.user-mode-linux.org> <20071021132031.GI2455@hacking> <20071021154346.GW8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021154346.GW8181@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 04:43:46PM +0100, Al Viro wrote:
> Fallout continues; I've got a preliminary patch for it.  Basically, we
> need to stop doing -U__i386__ et.al.

Thanks, Al.  You need the patch below in order to get a working UML -
feel free to fold it into this.

				Jeff

-- 
Work email - jdike at linux dot intel dot com


KERNEL_DEFINES needs whitespace trimmed, otherwise this whitespace
crunching done by make fools the patsubst which is used to remove
KERNEL_DEFINES from USER_CFLAGS.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/um/Makefile
===================================================================
--- linux-2.6.orig/arch/um/Makefile	2007-10-22 16:19:38.000000000 -0400
+++ linux-2.6/arch/um/Makefile	2007-10-22 16:19:44.000000000 -0400
@@ -70,9 +70,12 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 # in KBUILD_CFLAGS.  Otherwise, it would cause ld to complain about the two different
 # errnos.
 # These apply to kernelspace only.
+#
+# strip leading and trailing whitespace to make the USER_CFLAGS removal of these
+# defines more robust
 
-KERNEL_DEFINES = -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
-	-Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES)
+KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
+			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
 KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 

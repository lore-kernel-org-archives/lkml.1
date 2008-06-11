Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbYFKPXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbYFKPXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYFKPX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:23:27 -0400
Received: from [198.99.130.12] ([198.99.130.12]:43749 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbYFKPX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:23:26 -0400
Date: Wed, 11 Jun 2008 11:23:18 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080611152318.GA8099@c2.user-mode-linux.org>
References: <20080610190307.GA15983@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610190307.GA15983@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 09:03:07PM +0200, Sam Ravnborg wrote:
> Hi Jeff.
> 
> In an attempt to make the final link of vmlinux
> readable/hackable I have broken um build.
> 
> um used a special rule so it could use gcc as linker.
> With my changes we need to use ld to link vmlinux and
> ld now fails to locate util.
> 
> I hope you have a clue why. I tried various things but
> did not find out why ld cannot locate util.

This little patch fixes the -lutil problem linking vmlinux.o, but on
the final link, I get what appears to be every libc symbol
undefined...

Index: linux-2.6-git/arch/um/Makefile
===================================================================
--- linux-2.6-git.orig/arch/um/Makefile	2008-06-11 10:46:03.000000000 -0400
+++ linux-2.6-git/arch/um/Makefile	2008-06-11 11:19:05.000000000 -0400
@@ -104,7 +104,7 @@ archprepare: $(ARCH_SYMLINKS) $(ARCH_DIR
 prepare: $(ARCH_DIR)/include/kern_constants.h
 
 LINK-$(CONFIG_LD_SCRIPT_STATIC) += -static
-LINK-$(CONFIG_LD_SCRIPT_DYN) += -rpath /lib -rpath /usr/lib
+LINK-$(CONFIG_LD_SCRIPT_DYN) += -L/lib -L/usr/lib
 
 CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,) \
 	$(call cc-option, -fno-stack-protector,) \

	       		  	Jeff

-- 
Work email - jdike at linux dot intel dot com

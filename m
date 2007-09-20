Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbXITISO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbXITISO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761915AbXITIPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:15:55 -0400
Received: from ozlabs.org ([203.10.76.45]:58764 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761788AbXITIPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:15:53 -0400
From: Michael Neuling <mikey@neuling.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: Drop support for redundant "keepinitrd" boot-time param. 
In-reply-to: <20070920072233.GA10410@flint.arm.linux.org.uk> 
References: <Pine.LNX.4.64.0709191203460.30041@localhost.localdomain> <20070920072233.GA10410@flint.arm.linux.org.uk>
Comments: In-reply-to Russell King <rmk+lkml@arm.linux.org.uk>
   message dated "Thu, 20 Sep 2007 08:22:33 +0100."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Thu, 20 Sep 2007 18:15:48 +1000
Message-ID: <2261.1190276148@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> NAK.  "keepinitrd" is what people expect on ARM.
> 
> I'm frustrated that whoever invented "retain_initrd" didn't look
> around in the documentation to see if there was any existing
> implementation first.  The generic implementation should be fixed
> IMHO, or at least the option string moved into init/initramfs.c.

Sorry about that.  I'm happy to change retain_initrd to keep keepinitrd.
I don't think many people are using retain_initrd anyway (other than me
and some people I work with).

Otherwise we can support both for a while with something like (and
Robert's patch)....


From: Michael Neuling <mikey@neuling.org>

Make keepinitrd the same as retain_initrd for backwards compatibility
with ARM/AVR32 

Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 init/initramfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6-ozlabs/init/initramfs.c
===================================================================
--- linux-2.6-ozlabs.orig/init/initramfs.c
+++ linux-2.6-ozlabs/init/initramfs.c
@@ -502,6 +502,13 @@ static int __init retain_initrd_param(ch
 }
 __setup("retain_initrd", retain_initrd_param);
 
+/* for backwards compatibility with ARM/AVR32 */
+static int __init keepinitrd_param(char *str)
+{
+	return retain_initrd_param(str);
+}
+__setup("keepinitrd", keepinitrd_param);
+
 extern char __initramfs_start[], __initramfs_end[];
 #ifdef CONFIG_BLK_DEV_INITRD
 #include <linux/initrd.h>


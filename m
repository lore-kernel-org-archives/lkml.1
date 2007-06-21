Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXFUVQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXFUVQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbXFUVQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:16:22 -0400
Received: from verein.lst.de ([213.95.11.210]:35175 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286AbXFUVQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:16:20 -0400
Date: Thu, 21 Jun 2007 23:15:17 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drop obsolete sys_ioctl export
Message-ID: <20070621211517.GA25268@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sys_ioctl was only exported for our first version of compat ioctl
handling.  Now that the whole compat ioctl handling mess is more or
less sorted out there are no more modular users left and we can kill it.

There's one exception and that's sparc64's solaris compat module, but
sparc64 has it's own export predating the generic one by years for that
which this patch leaves untouched.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/ioctl.c
===================================================================
--- linux-2.6.orig/fs/ioctl.c	2007-06-21 22:09:38.000000000 +0200
+++ linux-2.6/fs/ioctl.c	2007-06-21 22:10:39.000000000 +0200
@@ -182,11 +182,3 @@ asmlinkage long sys_ioctl(unsigned int f
  out:
 	return error;
 }
-
-/*
- * Platforms implementing 32 bit compatibility ioctl handlers in
- * modules need this exported
- */
-#ifdef CONFIG_COMPAT
-EXPORT_SYMBOL(sys_ioctl);
-#endif

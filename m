Return-Path: <linux-kernel-owner+w=401wt.eu-S1760777AbXGAU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760777AbXGAU3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759124AbXGAUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:23:32 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46920 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759480AbXGAUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:23:31 -0400
Date: Sun, 1 Jul 2007 22:23:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] remove security/selinux/hooks.c:enabled_mmap_min_addr
Message-ID: <20070701202357.GA10869@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2007 at 03:43:21AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc4-mm2:
>...
> +git-selinux-disable-mmap_min_addr-by-default.patch
> 
>  Fix git-selinux
>...


This became dead code.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 security/selinux/hooks.c |    7 -------
 1 file changed, 7 deletions(-)

--- linux-2.6.22-rc6-mm1/security/selinux/hooks.c.old	2007-07-01 21:35:36.000000000 +0200
+++ linux-2.6.22-rc6-mm1/security/selinux/hooks.c	2007-07-01 21:35:48.000000000 +0200
@@ -112,9 +112,6 @@
 /* Original (dummy) security module. */
 static struct security_operations *original_ops = NULL;
 
-/* Did we enable minimum mmap address checking? */
-static int enabled_mmap_min_addr;
-
 /* Minimal support for a secondary security module,
    just to allow the use of the dummy or capability modules.
    The owlsm module can alternatively be used as a secondary
@@ -5079,10 +5076,6 @@
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	/* Disable minimum mmap address check only if we enabled it */
-	if (enabled_mmap_min_addr)
-		mmap_min_addr = 0;
-
 	/* Reset security_ops to the secondary module, dummy or capability. */
 	security_ops = secondary_ops;
 


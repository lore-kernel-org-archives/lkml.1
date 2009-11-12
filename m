Return-Path: <linux-kernel-owner+w=401wt.eu-S1752013AbZKLHsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbZKLHsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:48:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbZKLHsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:48:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47001 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZKLHsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:48:14 -0500
Date: Thu, 12 Nov 2009 18:48:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: rr tree build failure
Message-Id: <20091112184816.367affc8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Today's linux-next build (powerpc allnoconfig) failed like this:

scripts/mod/modpost.c:18:42: error: ../../include/linux/autoconf.h: No such file or directory

Caused by commit acd9e0c7d0b4a1cc02c27088a2b2322acc6d0793 ("module: make
MODULE_SYMBOL_PREFIX into a CONFIG option") interacting with commit
cf1320106e706875e6e14db8d5299f1d552f565e ("kbuild: move autoconf.h to
include/generated") from the kbuild tree.

I have applied the following patch for today (and will continue to use
it):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 12 Nov 2009 18:33:17 +1100
Subject: [PATCH] modpost: autoconf.h has moved to include/generated

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 scripts/mod/modpost.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f6be2e9..769ea95 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -15,7 +15,7 @@
 #include <stdio.h>
 #include <ctype.h>
 #include "modpost.h"
-#include "../../include/linux/autoconf.h"
+#include "../../include/generated/autoconf.h"
 #include "../../include/linux/license.h"
 
 /* Some toolchains use a `_' prefix for all user symbols. */
-- 
1.6.5.2

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

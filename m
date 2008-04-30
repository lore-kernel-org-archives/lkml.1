Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYD3BUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYD3BUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757095AbYD3BUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:20:03 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60914 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756618AbYD3BUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:20:00 -0400
Date: Wed, 30 Apr 2008 11:19:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Olof Johansson <olof@lixom.net>
Subject: linux-next: upstream build failure: pasemi_edac
Message-Id: <20080430111949.fc148fac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (just Linus' tree, powercp ppc64_defconfig)
fails like this:

drivers/edac/pasemi_edac.c: In function 'pasemi_edac_init':
drivers/edac/pasemi_edac.c:288: error: implicit declaration of function 'opstate_init'
drivers/edac/pasemi_edac.c: In function '__check_edac_op_state':
drivers/edac/pasemi_edac.c:304: error: 'edac_op_state' undeclared (first use in this function)
drivers/edac/pasemi_edac.c:304: error: (Each undeclared identifier is reported only once
drivers/edac/pasemi_edac.c:304: error: for each function it appears in.)
drivers/edac/pasemi_edac.c: At top level:
drivers/edac/pasemi_edac.c:304: error: 'edac_op_state' undeclared here (not in a function)

Caused by commit c3c52bce6993c6d37af2c2de9b482a7013d646a7 ("edac: fix
module initialization on several modules 2nd time") which added a call to
opstate_init but did not include linux/edac.h that declares it.

Patch below.

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Apr 2008 11:16:16 +1000
Subject: [PATCH] pasemi_edac needs to include linux/edac.h

Commit c3c52bce6993c6d37af2c2de9b482a7013d646a7 ("edac: fix module
initialization on several modules 2nd time") added a call to opstate_init
but did not include linux/edac.h that declares it.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/edac/pasemi_edac.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/pasemi_edac.c b/drivers/edac/pasemi_edac.c
index 3fd65a5..8e6b91b 100644
--- a/drivers/edac/pasemi_edac.c
+++ b/drivers/edac/pasemi_edac.c
@@ -26,6 +26,7 @@
 #include <linux/pci.h>
 #include <linux/pci_ids.h>
 #include <linux/slab.h>
+#include <linux/edac.h>
 #include "edac_core.h"
 
 #define MODULE_NAME "pasemi_edac"
-- 
1.5.5.1


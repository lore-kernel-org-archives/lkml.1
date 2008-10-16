Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYJPKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYJPKfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYJPKee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:34:34 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50184 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYJPKed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:34:33 -0400
Date: Thu, 16 Oct 2008 20:47:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mfd/wm8350: don't export static functions
Message-Id: <20081016204754.a41646e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/mfd/wm8350-core.c:1131: error: __ksymtab_wm8350_create_cache causes a section type conflict

Caused by commit 89b4012befb1abca5e86d232bc0e2a797b0d9825 ("mfd: Core
support for the WM8350 AudioPlus PMIC"). wm8350_create_cache is not used
elsewhere, so remove the EXPORT_SYMBOL.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/wm8350-core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index bf87f67..fbe22fb 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1128,7 +1128,6 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int mode)
 out:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(wm8350_create_cache);
 
 /*
  * Register a client device.  This is non-fatal since there is no need to
-- 
1.5.6.5

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

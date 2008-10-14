Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYJNW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYJNW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbYJNW70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:59:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47988 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbYJNW7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:59:25 -0400
Date: Wed, 15 Oct 2008 09:59:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: linux-next: origin tree build failure
Message-Id: <20081015095916.f30c0979.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Mark,

Today's linux-next build (just Linus' tree) (x86_64 allmodconfig) failed
like this:

drivers/mfd/wm8350-core.c: In function 'wm8350_device_init':
drivers/mfd/wm8350-core.c:1220: error: 'NO_IRQ' undeclared (first use in this function)

Caused by commit ebccec0fa4e35dff0c18663a492a65f4dc6cad7a ("mfd: Add
WM8350 interrupt support").

I applied the following (probably incorrect) patch.  Maybe this driver
needs to be restricted to certain architectures?  (NO_IRQ appears to only
be defined for arm, blackfin, powerpc, mn10300 and parisc)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 15 Oct 2008 09:57:33 +1100
Subject: [PATCH] wm8350-core needs NO_IRQ

and that is not defined for most architectures.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/mfd/wm8350-core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index 25a7a5d..6e3a509 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1156,6 +1156,10 @@ static void wm8350_client_dev_register(struct wm8350 *wm8350,
 	}
 }
 
+#ifndef NO_IRQ
+#define NO_IRQ	0
+#endif
+
 int wm8350_device_init(struct wm8350 *wm8350, int irq,
 		       struct wm8350_platform_data *pdata)
 {
-- 
1.5.6.5


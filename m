Return-Path: <linux-kernel-owner+w=401wt.eu-S1762269AbZD3Xtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762269AbZD3Xtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761045AbZD3Xs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:48:26 -0400
Received: from ru.mvista.com ([213.79.90.228]:5196 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761501AbZD3XsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:48:25 -0400
Date: Fri, 1 May 2009 03:48:24 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] spi_mpc83xx: Add small delay after asserting
	chip-select line
Message-ID: <20090430234824.GC7901@oksana.dev.rtsoft.ru>
References: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20090430234739.GA27709@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for some underlaying GPIO controllers that may be
a bit slow, or if chip-select signal need some time to stabilize.

For what it's worth, we already have the similar delay for
chip-select de-assertion case.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/spi_mpc83xx.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi_mpc83xx.c b/drivers/spi/spi_mpc83xx.c
index 08b49d2..d378d5e 100644
--- a/drivers/spi/spi_mpc83xx.c
+++ b/drivers/spi/spi_mpc83xx.c
@@ -383,8 +383,10 @@ static void mpc83xx_spi_work(struct work_struct *work)
 					break;
 			}
 
-			if (cs_change)
+			if (cs_change) {
 				mpc83xx_spi_chipselect(spi, BITBANG_CS_ACTIVE);
+				ndelay(nsecs);
+			}
 			cs_change = t->cs_change;
 			if (t->len)
 				status = mpc83xx_spi_bufs(spi, t);
-- 
1.6.2.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZHNWZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZHNWZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 18:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757160AbZHNWZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 18:25:56 -0400
Received: from ru.mvista.com ([213.79.90.228]:26645 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756697AbZHNWZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 18:25:54 -0400
Date: Sat, 15 Aug 2009 02:25:55 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] spi_mpc8xxx: Fix uninitialized variable
Message-ID: <20090814222555.GE14458@oksana.dev.rtsoft.ru>
References: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090814222453.GA9568@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following warning:

CC      drivers/spi/spi_mpc8xxx.o
  spi_mpc8xxx.c: In function 'of_mpc8xxx_spi_probe':
  spi_mpc8xxx.c:681: warning: 'ret' may be used uninitialized in this function

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/spi/spi_mpc8xxx.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
index 0fd0ec4..518671b 100644
--- a/drivers/spi/spi_mpc8xxx.c
+++ b/drivers/spi/spi_mpc8xxx.c
@@ -709,6 +709,7 @@ static int of_mpc8xxx_spi_get_chipselects(struct device *dev)
 		gpio = of_get_gpio_flags(np, i, &flags);
 		if (!gpio_is_valid(gpio)) {
 			dev_err(dev, "invalid gpio #%d: %d\n", i, gpio);
+			ret = gpio;
 			goto err_loop;
 		}
 
-- 
1.6.3.3


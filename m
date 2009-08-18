Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZHRWFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZHRWFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbZHRWFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:05:04 -0400
Received: from ru.mvista.com ([213.79.90.228]:44081 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751164AbZHRWES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:04:18 -0400
Date: Wed, 19 Aug 2009 02:04:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       spi-devel-general@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] spi_mpc8xxx: Fix uninitialized variable
Message-ID: <20090818220419.GE25090@oksana.dev.rtsoft.ru>
References: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090818220304.GA23640@oksana.dev.rtsoft.ru>
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


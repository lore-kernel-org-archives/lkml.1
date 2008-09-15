Return-Path: <linux-kernel-owner+w=401wt.eu-S1756172AbYIOUDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbYIOUDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbYIOUCz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:02:55 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:39919 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754051AbYIOUCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:02:52 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <david-b@pacbell.net>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] gpio_free might sleep, blackfin architecture
Date: Mon, 15 Sep 2008 22:02:42 +0200
Message-Id: <1221508963-27259-4-git-send-email-ukleinek@informatik.uni-freiburg.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
References: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
 <1221508963-27259-1-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221508963-27259-2-git-send-email-ukleinek@informatik.uni-freiburg.de>
 <1221508963-27259-3-git-send-email-ukleinek@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the documentation gpio_free should only be called from task
context only.  To make this more explicit add a might sleep to all
implementations.

This patch changes the gpio_free implementations for the blackfin
architecture.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Bryan Wu <cooloney@kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/blackfin/kernel/bfin_gpio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_gpio.c b/arch/blackfin/kernel/bfin_gpio.c
index ecbd141..394006d 100644
--- a/arch/blackfin/kernel/bfin_gpio.c
+++ b/arch/blackfin/kernel/bfin_gpio.c
@@ -1151,6 +1151,8 @@ void gpio_free(unsigned gpio)
 	if (check_gpio(gpio) < 0)
 		return;
 
+	might_sleep();
+
 	local_irq_save(flags);
 
 	if (unlikely(!(reserved_gpio_map[gpio_bank(gpio)] & gpio_bit(gpio)))) {
-- 
1.5.6.5


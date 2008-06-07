Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbYFGBSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbYFGBSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYFGBJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:22 -0400
Received: from sous-sol.org ([216.99.217.87]:42470 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757030AbYFGBJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:17 -0400
Message-Id: <20080607010620.971046358@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:47 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Masakazu Mokuno <mokuno@sm.sony.co.jp>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 32/50] PS3: gelic: fix memory leak
Content-Disposition: inline; filename=ps3-gelic-fix-memory-leak.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Masakazu Mokuno <mokuno@sm.sony.co.jp>

upstream commit: 6fc7431dc0775f21ad7a7a39c2ad0290291a56ea

This fixes the bug that the I/O buffer is not freed at the driver removal.

Signed-off-by: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/ps3_gelic_wireless.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ps3_gelic_wireless.c
+++ b/drivers/net/ps3_gelic_wireless.c
@@ -2474,6 +2474,8 @@ static void gelic_wl_free(struct gelic_w
 
 	pr_debug("%s: <-\n", __func__);
 
+	free_page((unsigned long)wl->buf);
+
 	pr_debug("%s: destroy queues\n", __func__);
 	destroy_workqueue(wl->eurus_cmd_queue);
 	destroy_workqueue(wl->event_queue);

-- 

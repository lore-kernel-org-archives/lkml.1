Return-Path: <linux-kernel-owner+w=401wt.eu-S1756412AbYB2GTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbYB2GTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 01:19:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYB2GTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 01:19:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41086 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYB2GTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 01:19:40 -0500
Date: Fri, 29 Feb 2008 15:19:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: trivial clean up to zlc_setup
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080229151057.66ED.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I found very small bug during review mel's 2 zonelist patch series.

this patch is trivial clean up.
jiffies subtraction may cause overflow problem.
it shold be used time_after().

Thanks.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
CC: Paul Jackson <pj@sgi.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c   2008-02-18 17:17:25.000000000 +0900
+++ b/mm/page_alloc.c   2008-02-29 15:17:03.000000000 +0900
@@ -1294,7 +1294,7 @@ static nodemask_t *zlc_setup(struct zone
        if (!zlc)
                return NULL;

-       if (jiffies - zlc->last_full_zap > 1 * HZ) {
+       if (time_after(jiffies, zlc->last_full_zap + HZ)) {
                bitmap_zero(zlc->fullzones, MAX_ZONES_PER_ZONELIST);
                zlc->last_full_zap = jiffies;
        }






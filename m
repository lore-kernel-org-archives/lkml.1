Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbZDIOzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbZDIOzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761428AbZDIOzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:55:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40619 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760626AbZDIOzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:55:03 -0400
Message-ID: <49DE0C36.4070507@ti.com>
Date: Thu, 9 Apr 2009 09:54:46 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <venkatesh.pallipadi@intel.com>
Subject: [PATCH] Allow deferrable timers for intervals tv2-tv5 to be deferred
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current kernel implementation only kernel timers for time 
interval tv1 are being deferred. This patch allows any timer that is 
configured as deferrable to be defer regardless of time interval.

This patch was previously discussed on another the thread [1] and Ack'ed 
  by Venki Pallipadi the author of the original deferrable timer patch.

Venki, could you also ack this patch for confirmation?

Cheers
Jon

[1] http://marc.info/?l=linux-kernel&m=123196343531966&w=2


Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
  kernel/timer.c |    3 +++
  1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index b455556..6ab6e96 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1012,6 +1012,9 @@ cascade:
  		index = slot = timer_jiffies & TVN_MASK;
  		do {
  			list_for_each_entry(nte, varp->vec + slot, entry) {
+				if (tbase_get_deferrable(nte->base))
+					continue;
+
  				found = 1;
  				if (time_before(nte->expires, expires))
  					expires = nte->expires;
-- 
1.6.1

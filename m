Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYIAXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYIAXTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYIAXQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:16:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:45053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYIAXQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:16:05 -0400
Date: Mon, 1 Sep 2008 16:10:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 8/13] hrtimer: convert s390 to the new hrtimer apis
Message-ID: <20080901161027.560c5814@infradead.org>
In-Reply-To: <20080901160343.75a89ec9@infradead.org>
References: <20080901160343.75a89ec9@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] hrtimer: convert s390 to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts s390 to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/s390/crypto/ap_bus.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 62b6b55..6f02f1e 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -659,9 +659,9 @@ static ssize_t poll_timeout_store(struct bus_type *bus, const char *buf,
 	hr_time = ktime_set(0, poll_timeout);
 
 	if (!hrtimer_is_queued(&ap_poll_timer) ||
-	    !hrtimer_forward(&ap_poll_timer, ap_poll_timer.expires, hr_time)) {
-		ap_poll_timer.expires = hr_time;
-		hrtimer_start(&ap_poll_timer, hr_time, HRTIMER_MODE_ABS);
+	    !hrtimer_forward(&ap_poll_timer, hrtimer_get_expires(&ap_poll_timer), hr_time)) {
+		hrtimer_set_expires(&ap_poll_timer, hr_time);
+		hrtimer_start_expires(&ap_poll_timer, HRTIMER_MODE_ABS);
 	}
 	return count;
 }
-- 
1.5.5.1


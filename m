Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457AbYIAXTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbYIAXTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 19:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYIAXQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 19:16:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:45060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYIAXQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 19:16:10 -0400
Date: Mon, 1 Sep 2008 16:11:12 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       dwmw2@infradead.org, drepper@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: [PATCH 9/13] hrtimer: convert sound/ to the new hrtimer apis
Message-ID: <20080901161112.33ababcb@infradead.org>
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
Subject: [PATCH] hrtimer: convert sound/ to the new hrtimer apis

In order to be able to do range hrtimers we need to use accessor functions
to the "expire" member of the hrtimer struct.
This patch converts sound/ to these accessors.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 sound/drivers/pcsp/pcsp_lib.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index e341f3f..1f42e40 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -34,7 +34,7 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 		chip->thalf = 0;
 		if (!atomic_read(&chip->timer_active))
 			return HRTIMER_NORESTART;
-		hrtimer_forward(&chip->timer, chip->timer.expires,
+		hrtimer_forward(&chip->timer, hrtimer_get_expires(&chip->timer),
 				ktime_set(0, chip->ns_rem));
 		return HRTIMER_RESTART;
 	}
@@ -118,7 +118,8 @@ enum hrtimer_restart pcsp_do_timer(struct hrtimer *handle)
 	chip->ns_rem = PCSP_PERIOD_NS();
 	ns = (chip->thalf ? PCSP_CALC_NS(timer_cnt) : chip->ns_rem);
 	chip->ns_rem -= ns;
-	hrtimer_forward(&chip->timer, chip->timer.expires, ktime_set(0, ns));
+	hrtimer_forward(&chip->timer, hrtimer_get_expires(&chip->timer),
+							ktime_set(0, ns));
 	return HRTIMER_RESTART;
 
 exit_nr_unlock2:
-- 
1.5.5.1


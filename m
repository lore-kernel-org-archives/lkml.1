Return-Path: <linux-kernel-owner+w=401wt.eu-S1750984AbYITEJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750984AbYITEJL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbYITEIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:08:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:37301 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYITEIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:08:44 -0400
Date: Fri, 19 Sep 2008 21:08:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: akpm@linux-foundation.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: [PATCH] debug: use dev_WARN() rather than WARN_ON() in
 device_pm_add()
Message-ID: <20080919210842.0c5fdbba@infradead.org>
In-Reply-To: <20080919210733.4e9c58e8@infradead.org>
References: <20080919210733.4e9c58e8@infradead.org>
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
Date: Fri, 19 Sep 2008 21:05:25 -0700
Subject: [PATCH] debug: use dev_WARN() rather than WARN_ON() in device_pm_add()

device_pm_add() has a WARN_ON that is showing up relatively high on
kerneloops.org, but unfortunately the WARN_ON is less than useful
in that it doesn't print any information about what device is causing
the issue.

This patch fixes this by turning the WARN_ON() into the newly
introduces dev_WARN() which will print information about the
device in question.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/base/power/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index bf6d355..b65667f 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -83,7 +83,7 @@ void device_pm_add(struct device *dev)
 		 * transition is in progress in order to avoid leaving them
 		 * unhandled down the road
 		 */
-		WARN_ON(true);
+		dev_WARN(dev, "Parentless device registered during a PM transaction\n");
 	}
 
 	list_add_tail(&dev->power.entry, &dpm_list);
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

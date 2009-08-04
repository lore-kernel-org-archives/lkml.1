Return-Path: <linux-kernel-owner+w=401wt.eu-S932749AbZHDJg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749AbZHDJg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 05:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbZHDJgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 05:36:25 -0400
Received: from mail.free-electrons.com ([88.191.76.200]:54426 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbZHDJgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 05:36:25 -0400
Date: Tue, 4 Aug 2009 11:36:12 +0200
From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PM List <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] Add SIMPLE_PM_OPS: make switching to dev_pm_ops less
 error-prone
Message-ID: <20090804093542.GA5854@laptop>
References: <20090803163304.GF5002@laptop>
 <200908032123.17069.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908032123.17069.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a number of cases, the .suspend, .freeze, .poweroff and .resume,
.thaw, .restore functions are identical. However, they all need to be
assigned to avoid regressionsm as the previous code called .suspend
resp. .resume in all those cases. SIMPLE_PM_OPS allows to deal with
this case.

Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
---
 include/linux/pm.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index b3f7476..994a62f 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -184,6 +184,16 @@ struct dev_pm_ops {
 	int (*restore_noirq)(struct device *dev);
 };
 
+#define SIMPLE_PM_OPS(name, suspend_fn, resume_fn) \
+struct dev_pm_ops name = { \
+	.suspend = suspend_fn, \
+	.resume = resume_fn, \
+	.freeze = suspend_fn, \
+	.thaw = resume_fn, \
+	.poweroff = suspend_fn, \
+	.resume = resume_fn, \
+}
+
 /**
  * PM_EVENT_ messages
  *
-- 
Albin Tonnerre, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com

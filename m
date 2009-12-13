Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZLMWnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZLMWnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbZLMWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:43:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42407 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZLMWnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:43:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 3/5] PM: Add debug printouts to async suspend and resume code paths
Date: Sun, 13 Dec 2009 23:40:57 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <200912132338.30921.rjw@sisk.pl>
In-Reply-To: <200912132338.30921.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132340.57200.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Add pm_dev_dbg() to asynchronous suspend and resume code paths to
make the debugging of async suspend/resume easier.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -510,6 +510,7 @@ static void async_resume(void *data, asy
 	struct device *dev = (struct device *)data;
 	int error;
 
+	pm_dev_dbg(dev, pm_transition, "async ");
 	error = __device_resume(dev, pm_transition, true);
 	if (error)
 		pm_dev_err(dev, pm_transition, " async", error);
@@ -791,6 +792,7 @@ static void async_suspend(void *data, as
 	struct device *dev = (struct device *)data;
 	int error;
 
+	pm_dev_dbg(dev, pm_transition, "async ");
 	error = __device_suspend(dev, pm_transition, true);
 	if (error) {
 		pm_dev_err(dev, pm_transition, " async", error);


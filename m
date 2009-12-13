Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZLMWJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZLMWJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 17:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbZLMWJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 17:09:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42308 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZLMWJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 17:09:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 1/2] PM: Remove unnecessary goto from device_resume_noirq()
Date: Sun, 13 Dec 2009 23:08:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200912132306.57741.rjw@sisk.pl>
In-Reply-To: <200912132306.57741.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912132308.36538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

In device_resume_noirq() there is the 'End' label and the associated
goto statement that aren't strictly necessary, so rework the code to
get rid of them.  Also modify device_suspend_noirq() so that it looks
completely analogous to device_resume_noirq().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -372,14 +372,11 @@ static int device_resume_noirq(struct de
 	TRACE_DEVICE(dev);
 	TRACE_RESUME(0);
 
-	if (!dev->bus)
-		goto End;
-
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "EARLY ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}
- End:
+
 	TRACE_RESUME(error);
 	return error;
 }
@@ -615,10 +612,7 @@ static int device_suspend_noirq(struct d
 {
 	int error = 0;
 
-	if (!dev->bus)
-		return 0;
-
-	if (dev->bus->pm) {
+	if (dev->bus && dev->bus->pm) {
 		pm_dev_dbg(dev, state, "LATE ");
 		error = pm_noirq_op(dev, dev->bus->pm, state);
 	}


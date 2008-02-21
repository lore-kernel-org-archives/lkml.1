Return-Path: <linux-kernel-owner+w=401wt.eu-S1764941AbYBUNGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764941AbYBUNGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbYBUNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:06:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43076 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755031AbYBUNGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:06:04 -0500
Date: Thu, 21 Feb 2008 13:58:10 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>
Subject: power_state: remove it from driver core
Message-ID: <20080221125809.GA30308@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


power_state is scheduled for removal, and it is used only for debug
prints by driver core. Remove it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d180795..268855d 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -421,11 +421,6 @@ int suspend_device(struct device *dev, p
 {
 	int error = 0;
 
-	if (dev->power.power_state.event) {
-		dev_dbg(dev, "PM: suspend %d-->%d\n",
-			dev->power.power_state.event, state.event);
-	}
-
 	if (dev->class && dev->class->suspend) {
 		suspend_device_dbg(dev, state, "class ");
 		error = dev->class->suspend(dev, state);

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

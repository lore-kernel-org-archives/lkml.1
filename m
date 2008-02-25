Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYBYVpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYBYVpy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbYBYVpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:45:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:27835 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYBYVpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:45:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=ZhsuNkRQFgdcktukx5uyZx2m51rOkfaxuqeAASZmabr/E+DYde/c9cEsLeSxLdBBQ+NVhscLAePji5iukyNjySbwuxq0yrB86he9VtT+Wl9GoSyAp9J+cbm9u5qLio8lY/VhUTGV7xFRRmMMbgVM4Xgbu7r73TLmhDlRaRSJXt0=
Date: Tue, 26 Feb 2008 00:24:45 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Matt Reimer <mreimer@vpop.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [W1] ds1wm: report bus reset error
Message-ID: <20080225212445.GB29891@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch replaces dev_dbg() by dev_err(), so the user could actually
see the error, instead of wondering why w1 doesn't work. The root cause
of the bus reset error isn't yet debugged though, but this sometimes
happens on iPaq H5555.

And while I'm at it, some cosmetic cleanups also made (few lines were
using spaces instead of tabs).

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/w1/masters/ds1wm.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 78a14da..10211e4 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -103,12 +103,12 @@ struct ds1wm_data {
 static inline void ds1wm_write_register(struct ds1wm_data *ds1wm_data, u32 reg,
 					u8 val)
 {
-        __raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+	__raw_writeb(val, ds1wm_data->map + (reg << ds1wm_data->bus_shift));
 }
 
 static inline u8 ds1wm_read_register(struct ds1wm_data *ds1wm_data, u32 reg)
 {
-        return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
+	return __raw_readb(ds1wm_data->map + (reg << ds1wm_data->bus_shift));
 }
 
 
@@ -150,8 +150,8 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 	timeleft = wait_for_completion_timeout(&reset_done, DS1WM_TIMEOUT);
 	ds1wm_data->reset_complete = NULL;
 	if (!timeleft) {
-                dev_dbg(&ds1wm_data->pdev->dev, "reset failed\n");
-                return 1;
+		dev_err(&ds1wm_data->pdev->dev, "reset failed\n");
+		return 1;
 	}
 
 	/* Wait for the end of the reset. According to the specs, the time
@@ -168,11 +168,11 @@ static int ds1wm_reset(struct ds1wm_data *ds1wm_data)
 		(ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0));
 
 	if (!ds1wm_data->slave_present) {
-                dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
-                return 1;
-        }
+		dev_dbg(&ds1wm_data->pdev->dev, "reset: no devices found\n");
+		return 1;
+	}
 
-        return 0;
+	return 0;
 }
 
 static int ds1wm_write(struct ds1wm_data *ds1wm_data, u8 data)
@@ -335,7 +335,7 @@ static int ds1wm_probe(struct platform_device *pdev)
 	if (!pdev)
 		return -ENODEV;
 
-	ds1wm_data = kzalloc(sizeof (*ds1wm_data), GFP_KERNEL);
+	ds1wm_data = kzalloc(sizeof(*ds1wm_data), GFP_KERNEL);
 	if (!ds1wm_data)
 		return -ENOMEM;
 
-- 
1.5.4.3

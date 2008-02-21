Return-Path: <linux-kernel-owner+w=401wt.eu-S1763552AbYBUXxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763552AbYBUXxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935886AbYBUXsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:48:47 -0500
Received: from mx1.suse.de ([195.135.220.2]:45054 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765089AbYBUXsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:48:46 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/11] PM: Remove unbalanced mutex_unlock() from dpm_resume()
Date: Thu, 21 Feb 2008 15:48:05 -0800
Message-Id: <1203637687-7273-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080221234649.GB7128@kroah.com>
References: <20080221234649.GB7128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove an unnecessary unlocking of dpm_list_mtx in the error path
in drivers/base/power/main.c:dpm_suspend() .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/power/main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index d609560..cea5ed3 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -479,7 +479,6 @@ static int dpm_suspend(pm_message_t state)
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
 				list_add(&dev->power.entry, &dpm_locked);
-			mutex_unlock(&dpm_list_mtx);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);
-- 
1.5.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763636AbYBTBDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763636AbYBTBDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYBTBDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:03:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755755AbYBTBDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:03:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] PM: Remove unbalanced mutex_unlock() from dpm_resume()
Date: Wed, 20 Feb 2008 02:01:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.osdl.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802200201.42543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Please consider taking the following fix for 2.6.25.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

Remove an unnecessary unlocking of dpm_list_mtx in the error path
in drivers/base/power/main.c:dpm_suspend() .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -479,7 +479,6 @@ static int dpm_suspend(pm_message_t stat
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
 				list_add(&dev->power.entry, &dpm_locked);
-			mutex_unlock(&dpm_list_mtx);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);

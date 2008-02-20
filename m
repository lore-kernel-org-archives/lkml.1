Return-Path: <linux-kernel-owner+w=401wt.eu-S932368AbYBTWAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbYBTWAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYBTV7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:59:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:47369 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYBTV7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:59:50 -0500
Subject: patch pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch added to gregkh-2.6 tree
To: rjw@sisk.pl, greg@kroah.com, gregkh@suse.de, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org, pavel@ucw.cz, stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Wed, 20 Feb 2008 13:57:18 -0800
In-Reply-To: <200802200201.42543.rjw@sisk.pl>
Message-ID: <12035446381218@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PM: Remove unbalanced mutex_unlock() from dpm_resume()

to my gregkh-2.6 tree.  Its filename is

     pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Wed Feb 20 12:56:19 2008
From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Wed, 20 Feb 2008 02:01:41 +0100
Subject: PM: Remove unbalanced mutex_unlock() from dpm_resume()
To: Greg KH <greg@kroah.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>, "Linux-pm mailing list" <linux-pm@lists.osdl.org>, LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Message-ID: <200802200201.42543.rjw@sisk.pl>
Content-Disposition: inline

From: Rafael J. Wysocki <rjw@sisk.pl>

Remove an unnecessary unlocking of dpm_list_mtx in the error path
in drivers/base/power/main.c:dpm_suspend() .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/power/main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -479,7 +479,6 @@ static int dpm_suspend(pm_message_t stat
 			mutex_lock(&dpm_list_mtx);
 			if (list_empty(&dev->power.entry))
 				list_add(&dev->power.entry, &dpm_locked);
-			mutex_unlock(&dpm_list_mtx);
 			break;
 		}
 		mutex_lock(&dpm_list_mtx);


Patches currently in gregkh-2.6 which might be from rjw@sisk.pl are

driver/driver-core-pm-make-suspend_device-static.patch
driver/pm-remove-unbalanced-mutex_unlock-from-dpm_resume.patch

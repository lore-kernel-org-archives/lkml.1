Return-Path: <linux-kernel-owner+w=401wt.eu-S1759247AbXLTJDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247AbXLTJDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 04:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXLTJDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 04:03:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:56709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXLTJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 04:03:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=vqkbmDgeC5+mnCxtPL/7DwfgxglZ6dY71PvKRFkkj0b5AzCaQOmMJM7Qs7qhcJkl6oJNC0dRk7sO8rdDLQxMr001R/Zy2fw07VMavsQtH6i9AAA9MLZmy6h6qC4GD4Rcrm5iPHVqEDUt0ngGKPAd9XtDtbdNHbjo9pR1v//FjXA=
Date: Thu, 20 Dec 2007 17:07:32 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] kobject_add : kill unnecessary warning
Message-ID: <20071220090732.GA3274@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I don't know whether you or others have this change or not, if not please consider apply.

Kill the unnecessary warning in kobject_add if sysfs file EEXIST because of there's a similar one in sysfs_add_one

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
kobject.c |   13 ++-----------
1 file changed, 2 insertions(+), 11 deletions(-)

diff -upr linux/lib/kobject.c linux.new/lib/kobject.c
--- linux/lib/kobject.c	2007-12-20 09:02:49.000000000 +0800
+++ linux.new/lib/kobject.c	2007-12-20 17:00:09.000000000 +0800
@@ -265,19 +265,10 @@ int kobject_add(struct kobject * kobj)
 
 	error = create_dir(kobj);
 	if (error) {
+		printk(KERN_ERR "kobject_add failed for %s (%d)\n",
+			       kobject_name(kobj), error);
 		/* unlink does the kobject_put() for us */
 		unlink(kobj);
-
-		/* be noisy on error issues */
-		if (error == -EEXIST)
-			printk(KERN_ERR "kobject_add failed for %s with "
-			       "-EEXIST, don't try to register things with "
-			       "the same name in the same directory.\n",
-			       kobject_name(kobj));
-		else
-			printk(KERN_ERR "kobject_add failed for %s (%d)\n",
-			       kobject_name(kobj), error);
-		dump_stack();
 	}
 
 	return error;

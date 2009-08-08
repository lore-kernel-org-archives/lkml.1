Return-Path: <linux-kernel-owner+w=401wt.eu-S934187AbZHHNQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934187AbZHHNQH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 09:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934172AbZHHNQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 09:16:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40089 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934128AbZHHNQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 09:16:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Magnus Damm <magnus.damm@gmail.com>, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] PM: kill dev_pm_ops platform warning for now
Date: Sat, 8 Aug 2009 15:16:23 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, lethal@linux-sh.org,
       stern@rowland.harvard.edu, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
References: <20090807083430.31389.98825.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090807083430.31389.98825.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908081516.24018.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009, Magnus Damm wrote:
> From: Magnus Damm <damm@igel.co.jp>
> 
> Remove the platform device runtime dev_pm_ops warning
> for now. No point in upsetting users of non-rc kernels.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Thanks for the patch, I modified the changelog a bit.

Greg, do you agree with the patch below?

Rafael

---
From: Magnus Damm <damm@igel.co.jp>
Subject: PM / Driver Core: Kill dev_pm_ops platform warning for now

Commit 783ea7d4eeefe895f2731fe73ac951e94418927b
(Driver Core: Rework platform suspend/resume, print warning)
added a warning message printed for platform drivers that use the
legacy PM callbacks rather than struct dev_pm_ops.  Unfortunately,
this resulted in some confusion and made some people try to convert
drivers by replacing the old callbacks with struct dev_pm_ops in
automatic way, which generally is not a good idea.

Remove the platform device runtime dev_pm_ops warning for now,
because it's annoying to users and it's not really necessary right
now.

[rjw: Modified the changelog to be more informative.]

Signed-off-by: Magnus Damm <damm@igel.co.jp>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/platform.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/base/platform.c
===================================================================
--- linux-2.6.orig/drivers/base/platform.c
+++ linux-2.6/drivers/base/platform.c
@@ -483,9 +483,6 @@ int platform_driver_register(struct plat
 		drv->driver.remove = platform_drv_remove;
 	if (drv->shutdown)
 		drv->driver.shutdown = platform_drv_shutdown;
-	if (drv->suspend || drv->resume)
-		pr_warning("Platform driver '%s' needs updating - please use "
-			"dev_pm_ops\n", drv->driver.name);
 
 	return driver_register(&drv->driver);
 }

Return-Path: <linux-kernel-owner+w=401wt.eu-S933442AbYFGBV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442AbYFGBV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbYFGBJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:37 -0400
Received: from sous-sol.org ([216.99.217.87]:42520 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbYFGBJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:24 -0400
Message-Id: <20080607010558.082872812@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 12/50] USB: fix build errors in ohci-omap.c and ohci-sm501.c
Content-Disposition: inline; filename=usb-fix-build-errors-in-ohci-omap.c-and-ohci-sm501.c.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

This fixes the build errors previously caused by
45fa78357eab3287b5c39f2d983b91150b3f4bd8

This makes the code mirror what went into Linus's tree previously.


Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/host/ohci-omap.c  |    3 ++-
 drivers/usb/host/ohci-sm501.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -511,7 +511,8 @@ static int ohci_omap_suspend(struct plat
 
 static int ohci_omap_resume(struct platform_device *dev)
 {
-	struct ohci_hcd	*ohci = hcd_to_ohci(platform_get_drvdata(dev));
+	struct usb_hcd	*hcd = platform_get_drvdata(dev);
+	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
 
 	if (time_before(jiffies, ohci->next_statechange))
 		msleep(5);
--- a/drivers/usb/host/ohci-sm501.c
+++ b/drivers/usb/host/ohci-sm501.c
@@ -231,7 +231,8 @@ static int ohci_sm501_suspend(struct pla
 static int ohci_sm501_resume(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct ohci_hcd	*ohci = hcd_to_ohci(platform_get_drvdata(pdev));
+	struct usb_hcd	*hcd = platform_get_drvdata(pdev);
+	struct ohci_hcd	*ohci = hcd_to_ohci(hcd);
 
 	if (time_before(jiffies, ohci->next_statechange))
 		msleep(5);

-- 

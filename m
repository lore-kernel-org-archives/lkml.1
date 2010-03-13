Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935269Ab0CMA2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:28:15 -0500
Received: from kroah.org ([198.145.64.141]:32850 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935048Ab0CMAVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:05 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:14 2010
Message-Id: <20100313001514.672290530@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben-linux@fluff.org>,
       <linux-mmc@vger.kernel.org>
Subject: [patch 109/123] s3cmci: initialize default platform data no_wprotect and no_detect with 1
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit c212808a1ba6bfba489006399b8152a047305acf upstream.

If no platform_data was givin to the device it's going to use it's default
platform data struct which has all fields initialized to zero.  As a
result the driver is going to try to request gpio0 both as write protect
and card detect pin.  Which of course will fail and makes the driver
unusable

Previously to the introduction of no_wprotect and no_detect the behavior
was to assume that if no platform data was given there is no write protect
or card detect pin.  This patch restores that behavior.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mmc/host/s3cmci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1360,6 +1360,8 @@ static struct mmc_host_ops s3cmci_ops =
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
 	 * checks. Any zero fields to ensure reasonable defaults are picked. */
+	 .no_wprotect = 1,
+	 .no_detect = 1,
 };
 
 #ifdef CONFIG_CPU_FREQ



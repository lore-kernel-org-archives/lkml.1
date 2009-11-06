Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbZKFWWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbZKFWWf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932249AbZKFWWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:22:33 -0500
Received: from kroah.org ([198.145.64.141]:56709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760094AbZKFWWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:31 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:40 2009
Message-Id: <20091106221540.801628880@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
Subject: [16/99] watchdog: Fix rio watchdog probe function
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=watchdog-fix-rio-watchdog-probe-function.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 03717e3d12b625268848414e39beda25e4515692 ]

After sucessfully registering the misc device the driver iounmaps the
hardware registers and kfree's the device data structure. Ouch !

This was introduced with commit e42311d75 (riowatchdog: Convert to
pure OF driver) and went unnoticed for more than a year :)

Return success instead of dropping into the error cleanup code path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/riowd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -206,7 +206,7 @@ static int __devinit riowd_probe(struct 
 
 	dev_set_drvdata(&op->dev, p);
 	riowd_device = p;
-	err = 0;
+	return 0;
 
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, 2);



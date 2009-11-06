Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZKFWL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZKFWL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932220AbZKFWLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:11:55 -0500
Received: from kroah.org ([198.145.64.141]:39719 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759903AbZKFWFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:43 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:50 2009
Message-Id: <20091106215950.692406972@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stas Sergeev <stsp@aknet.ru>
Subject: [05/30] Driver core: fix driver_register() return value
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=driver-core-fix-driver_register-return-value.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stas Sergeev <stsp@aknet.ru>

commit 39acbc12affcaa23ef1d887ba3d197baca8e6e47 upstream.

In this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=16dc42e018c2868211b4928f20a957c0c216126c
the check was added for another driver to already claim the same device
on the same bus. But the returned error code was wrong: to modprobe, the
-EEXIST means that _this_ driver is already installed. It therefore
doesn't produce the needed error message when _another_ driver is trying
to register for the same device.  Returning -EBUSY fixes the problem.

Signed-off-by: Stas Sergeev <stsp@aknet.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -227,7 +227,7 @@ int driver_register(struct device_driver
 		put_driver(other);
 		printk(KERN_ERR "Error: Driver '%s' is already registered, "
 			"aborting...\n", drv->name);
-		return -EEXIST;
+		return -EBUSY;
 	}
 
 	ret = bus_add_driver(drv);



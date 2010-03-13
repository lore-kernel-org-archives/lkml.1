Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875Ab0CMBdk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:33:40 -0500
Received: from kroah.org ([198.145.64.141]:60600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934834Ab0CMATo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:44 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:06 2010
Message-Id: <20100313001506.839606236@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:11:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       Alessandro Zummo <a.zummo@towertech.it>
Subject: [patch 019/123] rtc-core: fix memory leak
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Aaro Koskinen <aaro.koskinen@nokia.com>

commit 2a7a06a0cdd86d572e91657603180da5992be6d3 upstream.

The idr should be destroyed when the module is unloaded. Found with
kmemleak.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/rtc/class.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -226,6 +226,7 @@ static void __exit rtc_exit(void)
 {
 	rtc_dev_exit();
 	class_destroy(rtc_class);
+	idr_destroy(&rtc_idr);
 }
 
 subsys_initcall(rtc_init);



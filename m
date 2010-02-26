Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965076Ab0BZPTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965021Ab0BZPTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:10 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 06/14] dell-laptop: Fix small memory leak
Date: Fri, 26 Feb 2010 10:18:39 -0500
Message-Id: <1267197527-18062-7-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da_tokens was not being freed by dell-laptop on unload. Fix that.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-laptop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index b4c2190..b13eb6a 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -478,6 +478,7 @@ static void __exit dell_exit(void)
 		platform_device_del(platform_device);
 		platform_driver_unregister(&platform_driver);
 	}
+	kfree(da_tokens);
 }
 
 module_init(dell_init);
-- 
1.6.6.1


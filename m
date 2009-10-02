Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbZJBCBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbZJBCBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 22:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbZJBBcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:32:32 -0400
Received: from kroah.org ([198.145.64.141]:32877 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbZJBBc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:32:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:07 2009
Message-Id: <20091002012406.906817735@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:15:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Korsgaard <jacmet@sunsite.dk>, Ben Dooks <ben-linux@fluff.org>
Subject: [008/136] video: s3c_fb.c: fix build with CONFIG_HOTPLUG=n
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=video-s3c_fb.c-fix-build-with-config_hotplug-n.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Peter Korsgaard <jacmet@sunsite.dk>

commit 3163eaba34943967aebb1eefa0d4bdc4e5dc197c upstream.

Fixes `s3c_fb_remove' referenced in section `.data' of
drivers/built-in.o: defined in discarded section `.devexit.text' of
drivers/built-in.o

With CONFIG_HOTPLUG=n, functions marked with __devexit gets removed,
so make sure we use __devexit_p when referencing pointers to them.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Acked-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/s3c-fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1036,7 +1036,7 @@ static int s3c_fb_resume(struct platform
 
 static struct platform_driver s3c_fb_driver = {
 	.probe		= s3c_fb_probe,
-	.remove		= s3c_fb_remove,
+	.remove		= __devexit_p(s3c_fb_remove),
 	.suspend	= s3c_fb_suspend,
 	.resume		= s3c_fb_resume,
 	.driver		= {



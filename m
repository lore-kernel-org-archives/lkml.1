Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbYCVDTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbYCVDTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 23:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYCVDTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 23:19:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:10075 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbYCVDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 23:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=I+ppDgqo1DL0pfOx16CCesXgKOoN0MYTSjpesBIoBovQ8dEBNNv5avGJwqN2VAEW5I0WQPfEn6dkK6NZBwfZsRbVRiB2DkvQx+SYIZB4IJf/X6f51X7NvLXeQE8Av/Jer/LLriTyKcn3eFrhgOuDq9VMMNUJzD7+4AStIWRdF08=
Date: Sat, 22 Mar 2008 12:10:48 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] cdrom: cleanup hardcoded error-code
Message-ID: <20080322031047.GB3665@APFDCB5C>
References: <20080322030948.GA3665@APFDCB5C>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <20080322030948.GA3665@APFDCB5C>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates hardcoded return value of register_cdrom().

It also changes the return value to -EINVAL.
It is more appropriate than -2 (-ENOENT) because it is only
happen invalid usage of register_cdrom() by broken cdrom driver.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/cdrom/cdrom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-git/drivers/cdrom/cdrom.c
===================================================================
--- 2.6-git.orig/drivers/cdrom/cdrom.c
+++ 2.6-git/drivers/cdrom/cdrom.c
@@ -393,7 +393,7 @@ int register_cdrom(struct cdrom_device_i
 	cdinfo(CD_OPEN, "entering register_cdrom\n"); 
 
 	if (cdo->open == NULL || cdo->release == NULL)
-		return -2;
+		return -EINVAL;
 	if (!banner_printed) {
 		printk(KERN_INFO "Uniform CD-ROM driver " REVISION "\n");
 		banner_printed = 1;

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbYE3XeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbYE3XeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3XeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:34:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:59143 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYE3XeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=LIi+qw5T9PvfHkx4kVuhGTZ/sRK3l9/yysWhDPKf5n9WKyYQDOrMnVmY/VghCaoY01DgUYTY1iejQ3lFPgK1LgJCUiYZI9CxtnElxpZP3OT4ZzeG0KNgffcQmDjEPpEUiWmr8omYWmFNna/cHOuDFC5IixuwvIHmIYfN3lktDvo=
Date: Sat, 31 May 2008 03:29:56 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] edd: fix suspicious return of 1 from module_init
Message-ID: <20080530232956.GA7358@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/firmware/edd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -753,7 +753,7 @@ edd_init(void)
 
 	if (!edd_num_devices()) {
 		printk(KERN_INFO "EDD information not available.\n");
-		return 1;
+		return -ENODEV;
 	}
 
 	edd_kset = kset_create_and_add("edd", NULL, firmware_kobj);


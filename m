Return-Path: <linux-kernel-owner+w=401wt.eu-S1760775AbXHENte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775AbXHENte (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 09:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757346AbXHENt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 09:49:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:54246 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHENt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 09:49:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=CmJpllNQ9CDdzWVwBQxs8BhOIbPypoMUM2AHMH/FLlpA1fcvu811/134j/kFULeIVgV4WZA5avSE36GCSFVd8phhiWxSIlPdnBTpCye1YhxfxoqvZDtKduP7UNXs2/yIIot48QoyqGNdh9kCm23+TZi08p1z4xTrrZNxSI4vgVI=
Date: Sun, 5 Aug 2007 17:49:23 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH] Off-by-one in /sys/module/*/refcnt
Message-ID: <20070805134923.GA5918@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hell knows when this changed, but sysfs is lying about modules refcounts now.

$ cat /sys/module/it87/refcnt
4294967295
$ lsmod | grep ^it87
it87                   15756  0

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -785,7 +785,7 @@ static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
 {
 	/* sysfs holds a reference */
-	return sprintf(buffer, "%u\n", module_refcount(mod)-1);
+	return sprintf(buffer, "%u\n", module_refcount(mod));
 }
 
 static struct module_attribute refcnt = {


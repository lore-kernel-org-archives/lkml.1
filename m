Return-Path: <linux-kernel-owner+w=401wt.eu-S933455AbXHFTsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455AbXHFTsA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 15:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbXHFTrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 15:47:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:43043 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594AbXHFTrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 15:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hBhdfR9EjkWCrLLIw7XadUug4J6Xqc8AfRrDb1tYsCaKzXykhsMyDJEmSI5lVeRIjY9UP/mUtFxEDfJZ/9Q9Z2C2mN+GklV2cIwzG4zMPZTe50hM+J1tBpJgUe9hIVVyY0rX6iGnVYPfSaXjwOMvGVuldBxj215xXrl3yuvaitA=
Date: Mon, 6 Aug 2007 23:47:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, akpm@osdl.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] Off-by-one in /sys/module/*/refcnt
Message-ID: <20070806194745.GB5842@martell.zuzino.mipt.ru>
References: <20070805134923.GA5918@martell.zuzino.mipt.ru> <3ae72650708050700p1fc2959epcc1e9307e3c64fed@mail.gmail.com> <46B6B22C.1020609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B6B22C.1020609@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs internals were changed to not pin module in question.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/module.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/module.c
+++ b/kernel/module.c
@@ -784,8 +784,7 @@ EXPORT_SYMBOL_GPL(symbol_put_addr);
 static ssize_t show_refcnt(struct module_attribute *mattr,
 			   struct module *mod, char *buffer)
 {
-	/* sysfs holds a reference */
-	return sprintf(buffer, "%u\n", module_refcount(mod)-1);
+	return sprintf(buffer, "%u\n", module_refcount(mod));
 }
 
 static struct module_attribute refcnt = {


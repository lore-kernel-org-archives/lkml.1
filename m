Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXI2KJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXI2KJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 06:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXI2KJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 06:09:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:22583 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbXI2KJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 06:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=CpLVWvYwvArEWTwaYI1zOGYLYtbrOHlWzC2TA1tydpFNn7Ph7KYDnApVTemAk4aA0iNPMRJRUQw1JZwPiq2h1uDxwl46AvRD0tV0IwXC3CtZsh+dVah7zg1KnF7VCC8U9QwzmL0cojUFgquEEtoGjDBOWnbBNZP2oX3Jo/M2waE=
Date: Sat, 29 Sep 2007 19:06:53 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] module: return error when mod_sysfs_init() failed
Message-ID: <20070929100653.GA4121@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	Rusty Russell <rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

load_module() returns zero when mod_sysfs_init() fails,
then the module loading will succeed accidentally.

This patch makes load_module() return error correctly in that case.

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 kernel/module.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: 2.6-git/kernel/module.c
===================================================================
--- 2.6-git.orig/kernel/module.c
+++ 2.6-git/kernel/module.c
@@ -1782,7 +1782,8 @@ static struct module *load_module(void _
 	module_unload_init(mod);
 
 	/* Initialize kobject, so we can reference it. */
-	if (mod_sysfs_init(mod) != 0)
+	err = mod_sysfs_init(mod);
+	if (err)
 		goto cleanup;
 
 	/* Set up license info based on the info section */

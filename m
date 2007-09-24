Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXIXNMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXIXNMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753033AbXIXNM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:12:27 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:8312 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbXIXNM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:12:26 -0400
Date: Mon, 24 Sep 2007 17:09:57 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org, kamalesh@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, xemul@sw.ru
Subject: 2.6.23-rc7-mm1: fix generic_setlease() mismerge
Message-ID: <20070924130957.GE6757@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please, try this:

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1373,11 +1373,6 @@ int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
 	if (new_fl == NULL)
 		goto out;
 
-	error = -ENOMEM;
-	new_fl = locks_alloc_lock();
-	if (new_fl == NULL)
-		goto out;
-
 	/*
 	 * At this point, we know that if there is an exclusive
 	 * lease on this file, then we hold it on this filp


Return-Path: <linux-kernel-owner+w=401wt.eu-S1030776AbXD1F0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030776AbXD1F0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbXD1F0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:26:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:27482 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbXD1F0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=a7KR7ypGFek3w1qosFlg+2u/QFvQXcrmK5cMWAMVWgYy9AtZMPq0V/MI9XlxMxZuAyzzQTt5A2TDZR6B6Mf9wdT4y5Z6d+jYZpoZAjrsyvZH8ydch7Z3vqGl+mix7ST2HxtWcPgoCWux68dBewvNyulEiq2/pACA+7cn4/he2Uc=
Date: Sat, 28 Apr 2007 13:30:23 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: steve@chygwyn.com, pavel@ucw.cz, Paul.Clements@steeleye.com,
       akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Wang Ya-gang <lazy_linux@126.com>,
       Chen Li-jun <cljun@xiyou.edu.cn>
Subject: [-mm Patch]nbd: check the return value of sysfs_create_file
Message-ID: <20070428053023.GA2578@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: steve@chygwyn.com, pavel@ucw.cz,
	Paul.Clements@steeleye.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Wang Ya-gang <lazy_linux@126.com>,
	Chen Li-jun <cljun@xiyou.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since 'sysfs_create_file' is declared with attribute warn_unused_result, we must always check its return value carefully.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

--- linux-2.6.21-rc7-mm2/drivers/block/nbd.c.orig	2007-04-27 17:27:47.000000000 +0800
+++ linux-2.6.21-rc7-mm2/drivers/block/nbd.c	2007-04-27 17:47:32.000000000 +0800
@@ -373,7 +373,10 @@ static void nbd_do_it(struct nbd_device 
 	BUG_ON(lo->magic != LO_MAGIC);
 
 	lo->pid = current->pid;
-	sysfs_create_file(&lo->disk->kobj, &pid_attr.attr);
+	if (sysfs_create_file(&lo->disk->kobj, &pid_attr.attr)) {
+		printk(KERN_ERR "nbd: sysfs_create_file failed!");
+		return;
+	}
 
 	while ((req = nbd_read_stat(lo)) != NULL)
 		nbd_end_request(req);

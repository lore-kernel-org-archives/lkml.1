Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbXGJE4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbXGJE4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbXGJE4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:56:09 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:47681 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXGJE4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:56:08 -0400
Date: Tue, 10 Jul 2007 13:56:46 +0900 (JST)
Message-Id: <20070710.135646.84167888.yoshfuji@linux-ipv6.org>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: sysfs: release mutex when kmalloc() failed in sysfs_open_file().
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

--
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b502c71..1f64ce5 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -283,6 +283,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	mutex_lock(&inode->i_mutex);
 	if (!(set = inode->i_private)) {
 		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
+			mutex_unlock(&inode->i_mutex);
 			error = -ENOMEM;
 			goto Done;
 		} else {

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA

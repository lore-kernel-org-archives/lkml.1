Return-Path: <linux-kernel-owner+w=401wt.eu-S1751765AbXCDNlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbXCDNlG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXCDNlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:41:06 -0500
Received: from wr-out-0506.google.com ([64.233.184.239]:50340 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbXCDNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=nu7Zm+nnXOhyfnFOED9jgehnH2Eh/JFW1wMd9JnSGV91F5hZkga9n1UBmIEcgHsA5bO+WEyDsAN206ztfdmlSJ3I9/b23eo9SlBqQrOjGFub2nAM3sLrTImUc5X3WPJBgH8Z7fGpvBR5RbByuZOcqVf0qhw22xnqD4qZ0nhqmnI=
Date: Sun, 4 Mar 2007 22:37:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mark.fasheh@oracle.com>, Kurt Hackel <kurt.hackel@oracle.com>
Subject: [PATCH] ocfs2_nodemanager: check o2net_init() error
Message-ID: <20070304133710.GB8519@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Mark Fasheh <mark.fasheh@oracle.com>,
	Kurt Hackel <kurt.hackel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] ocfs2_nodemanager: check o2net_init() error

Check o2net_init() return value in ocfs2_nodemanager module_init().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Cc: Kurt Hackel <kurt.hackel@oracle.com>
---
 fs/ocfs2/cluster/nodemanager.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: 2.6-mm/fs/ocfs2/cluster/nodemanager.c
===================================================================
--- 2.6-mm.orig/fs/ocfs2/cluster/nodemanager.c
+++ 2.6-mm/fs/ocfs2/cluster/nodemanager.c
@@ -915,12 +915,15 @@ static void __exit exit_o2nm(void)
 
 static int __init init_o2nm(void)
 {
-	int ret = -1;
+	int ret;
 
 	cluster_print_version();
 
 	o2hb_init();
-	o2net_init();
+
+	ret = o2net_init();
+	if (ret)
+		goto out;
 
 	ocfs2_table_header = register_sysctl_table(ocfs2_root_table);
 	if (!ocfs2_table_header) {

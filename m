Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZIRCZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZIRCZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbZIRCZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:25:19 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55862 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494AbZIRCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:25:15 -0400
Message-ID: <4AB2EFBC.90500@oracle.com>
Date: Thu, 17 Sep 2009 19:26:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH 1/3] docs: kref: double kref_put() in my_data_handler()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AB2EF81.0087:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>
Subject: kref: double kref_put() in my_data_handler()

The kref_put() already occurs after the out label

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kref.txt |    1 -
 1 file changed, 1 deletion(-)

--- lnx-2631-rc7.orig/Documentation/kref.txt
+++ lnx-2631-rc7/Documentation/kref.txt
@@ -84,7 +84,6 @@ int my_data_handler(void)
 	task = kthread_run(more_data_handling, data, "more_data_handling");
 	if (task == ERR_PTR(-ENOMEM)) {
 		rv = -ENOMEM;
-	        kref_put(&data->refcount, data_release);
 		goto out;
 	}
 

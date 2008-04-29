Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbYD2LPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbYD2LPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 07:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756681AbYD2LN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 07:13:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:20571 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbYD2LN1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 07:13:27 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: [PATCH 4/12] ipv6: assign PDE->data before gluing PDE into /proc tree
Date: Tue, 29 Apr 2008 15:13:14 +0400
Message-Id: <1209467602-20001-4-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1209467538.29647.11.camel@iris.sw.ru>
References: <1209467538.29647.11.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply replace proc_create and further data assigned with proc_create_data.

Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
---
 net/ipv6/proc.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index ca8b82f..df0736a 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -247,13 +247,11 @@ int snmp6_register_dev(struct inet6_dev *idev)
 	if (!proc_net_devsnmp6)
 		return -ENOENT;
 
-	p = proc_create(idev->dev->name, S_IRUGO,
-			proc_net_devsnmp6, &snmp6_seq_fops);
+	p = proc_create_data(idev->dev->name, S_IRUGO,
+			     proc_net_devsnmp6, &snmp6_seq_fops, idev);
 	if (!p)
 		return -ENOMEM;
 
-	p->data = idev;
-
 	idev->stats.proc_dir_entry = p;
 	return 0;
 }
-- 
1.5.3.rc5


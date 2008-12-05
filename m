Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbYLEAmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbYLEAmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:42:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYLEAm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:42:27 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:62966 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYLEAm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:42:26 -0500
Date: Thu, 4 Dec 2008 16:42:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, jens.axboe@oracle.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] sysctl: handle bio system when CONFIG_BLOCK=n
Message-Id: <20081204164213.65139547.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.493878E7.0032:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Handle build config of CONFIG_BLOCK=n:

kernel/sysctl.c:1233: error: 'bio_inline_vecs' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sysctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20081204.orig/kernel/sysctl.c
+++ linux-next-20081204/kernel/sysctl.c
@@ -1227,6 +1227,7 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_BLOCK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "bio_inline_vecs",
@@ -1237,6 +1238,7 @@ static struct ctl_table vm_table[] = {
 		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt

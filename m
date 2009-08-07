Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZHGSRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZHGSRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbZHGSRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:17:44 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:57296 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbZHGSRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:17:43 -0400
Date: Fri, 7 Aug 2009 11:16:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       jens.axboe@oracle.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] block: blk-iopoll sysctl iff CONFIG_BLOCK
Message-Id: <20090807111659.3d8da27f.randy.dunlap@oracle.com>
In-Reply-To: <20090807183118.e71b4db2.sfr@canb.auug.org.au>
References: <20090807183118.e71b4db2.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt018.oracle.com [141.146.116.27]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010207.4A7C6FB4.0049:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

New block-iopoll sysctl should be surrounded by CONFIG_BLOCK to
prevent build error:

kernel/built-in.o:(.data+0x2990): undefined reference to `blk_iopoll_enabled'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/sysctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090807.orig/kernel/sysctl.c
+++ linux-next-20090807/kernel/sysctl.c
@@ -990,6 +990,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_BLOCK
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "blk_iopoll",
@@ -998,6 +999,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

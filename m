Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZHQUf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZHQUf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754879AbZHQUf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:35:26 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:41188 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZHQUfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:35:25 -0400
Message-ID: <4A89BF25.9010404@oracle.com>
Date: Mon, 17 Aug 2009 13:35:49 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
CC: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] phonet: fix build when PROC_FS is disabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4A89BEC6.0069:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix phonet build when PROC_FS is not enabled:

net/built-in.o: In function `pn_sock_open':
socket.c:(.text+0x23c649): undefined reference to `seq_open_net'
net/built-in.o:(.rodata+0x21018): undefined reference to `seq_release_net'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/phonet/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090817.orig/net/phonet/socket.c
+++ linux-next-20090817/net/phonet/socket.c
@@ -413,6 +413,7 @@ found:
 }
 EXPORT_SYMBOL(pn_sock_get_port);
 
+#ifdef CONFIG_PROC_FS
 static struct sock *pn_sock_get_idx(struct seq_file *seq, loff_t pos)
 {
 	struct net *net = seq_file_net(seq);
@@ -509,3 +510,4 @@ const struct file_operations pn_sock_seq
 	.llseek = seq_lseek,
 	.release = seq_release_net,
 };
+#endif



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/

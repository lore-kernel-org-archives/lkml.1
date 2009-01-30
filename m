Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbZA3SVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbZA3SVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755526AbZA3SUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:20:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54770 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbZA3SUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:20:22 -0500
Message-ID: <498344F0.3010109@vlnb.net>
Date: Fri, 30 Jan 2009 21:20:32 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net
Subject: [PATCH][iSCSI-SCST]: Clean up netlink socket correctly
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19JvxfPQfodg+D1v1YWxODGS52XnYIk/Ywcxme
 2dIxaVBX2zBK4xoQLQq7ITAxUZ4MthzXppJNW8813JxIqnyvi/
 geyfOgBQa/uIS54Mq+HEw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25 introduced netlink_socket_release(), to be used to clean up netlink sockets
correctly taking care of namespaces. Fix now wrong sock_release() call in iSCSI-SCST.

Signed-off-by: Arne Redlich <agr@powerkom-dd.de>
Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>

 event.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: iscsi-scst/kernel/event.c
===================================================================
--- iscsi-scst/kernel/event.c	(revision 648)
+++ iscsi-scst/kernel/event.c	(working copy)
@@ -142,6 +142,10 @@ int __init event_init(void)
 
 void event_exit(void)
 {
- 	if (nl)
- 		sock_release(nl->sk_socket);
+	netlink_kernel_release(nl);
 }


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbYACRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbYACRTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYACRTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:19:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52449 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751343AbYACRTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:19:11 -0500
Date: Thu, 3 Jan 2008 17:17:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc: Fix warning that has recently appeared
Message-ID: <20080103171731.1f83602a@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use _t form to force types. We know that msg->m_ts is
clamped between 0 and MAXINT.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc6-mm1/ipc/msg.c linux-2.6.24-rc6-mm1/ipc/msg.c
--- linux.vanilla-2.6.24-rc6-mm1/ipc/msg.c	2008-01-02 16:04:25.000000000 +0000
+++ linux-2.6.24-rc6-mm1/ipc/msg.c	2008-01-02 16:50:46.000000000 +0000
@@ -898,7 +898,7 @@
 	if (IS_ERR(msg))
 		return PTR_ERR(msg);
 
-	msgsz = min(msgsz, msg->m_ts);
+	msgsz = min_t(size_t, msgsz, msg->m_ts);
 	*pmtype = msg->m_type;
 	if (store_msg(mtext, msg, msgsz))
 		msgsz = -EFAULT;

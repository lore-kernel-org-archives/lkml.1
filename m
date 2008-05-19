Return-Path: <linux-kernel-owner+w=401wt.eu-S1759214AbYESMcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214AbYESMcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756899AbYESMbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:47 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27605 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbYESMbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: davem@davemloft.net, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/11] Convert socket fasync to unlocked_fasync
Message-Id: <20080519123113.A19631B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:13 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:11.0531 (UTC) FILETIME=[3E44EDB0:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pretty sure the socket layer has no BKL requirements.

Cc: davem@davemloft.net

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/socket.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/net/socket.c
===================================================================
--- linux.orig/net/socket.c
+++ linux/net/socket.c
@@ -134,7 +134,7 @@ static const struct file_operations sock
 	.mmap =		sock_mmap,
 	.open =		sock_no_open,	/* special open code to disallow open via /proc */
 	.release =	sock_close,
-	.fasync =	sock_fasync,
+	.unlocked_fasync = sock_fasync,
 	.sendpage =	sock_sendpage,
 	.splice_write = generic_splice_sendpage,
 	.splice_read =	sock_splice_read,

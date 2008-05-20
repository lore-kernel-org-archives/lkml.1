Return-Path: <linux-kernel-owner+w=401wt.eu-S934793AbYETPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934793AbYETPe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932848AbYETPaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:35 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758371AbYETPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: davem@davemloft.net, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [4/11] Convert socket fasync to unlocked_fasync
Message-Id: <20080520152845.DDFB51B4204@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:45 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:45.0355 (UTC) FILETIME=[36DB35B0:01C8BA8D]
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

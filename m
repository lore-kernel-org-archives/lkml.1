Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZKENCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZKENCh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZKENCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:02:36 -0500
Received: from www84.your-server.de ([213.133.104.84]:39323 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbZKENCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:02:36 -0500
Subject: [PATCH] fix /proc/<pid>/stat stack pointer for kernel threads
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
In-Reply-To: <1257239184.4889.15.camel@wall-e>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 05 Nov 2009 14:02:28 +0100
Message-ID: <1257426148.30444.8.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix a small issue for the stack pointer in /proc/<pid>/stat.
In case of a kernel thread the value of the stack pointer should be 0.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.32-rc5.old/fs/proc/array.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5.new/fs/proc/array.c	2009-11-05 13:46:58.770599144 +0100
@@ -571,7 +571,7 @@
 		rsslim,
 		mm ? mm->start_code : 0,
 		mm ? mm->end_code : 0,
-		(permitted) ? task->stack_start : 0,
+		(permitted && mm) ? task->stack_start : 0,
 		esp,
 		eip,
 		/* The signal information here is obsolete.



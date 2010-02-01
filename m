Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0BAQvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:51:32 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48788 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0BAQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:51:30 -0500
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 3/3] kernel-shark: fix unitialized handle compile warnings
Date: Mon,  1 Feb 2010 08:50:26 -0800
Message-Id: <1265043026-24987-4-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
---
 kernel-shark.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel-shark.c b/kernel-shark.c
index 9dedf48..222381c 100644
--- a/kernel-shark.c
+++ b/kernel-shark.c
@@ -596,10 +596,10 @@ void kernel_shark(int argc, char **argv)
 		if (ret >= 0)
 			input_file = default_input_file;
 	}
-	if (handle)
-		handle = tracecmd_open(input_file);
+	handle = tracecmd_open(input_file);
 
-	info->handle = handle;
+	if (handle)
+		info->handle = handle;
 
 	/* --- Main window --- */
 
-- 
1.6.3.3


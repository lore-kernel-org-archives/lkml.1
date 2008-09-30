Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYI3Day@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYI3Day (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYI3Dar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:30:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50397 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbYI3Daq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:30:46 -0400
Message-ID: <48E19CE8.8070006@cn.fujitsu.com>
Date: Tue, 30 Sep 2008 11:28:40 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] markers: let marker_debug as module parameter
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


if we want to enable marker debug output, we have to modify
the code and remake/reinstall the kernel in current code.

this patch enable marker_debug to be set when kernel start.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/marker.c b/kernel/marker.c
index 9f76c4a..5d8404f 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -28,8 +28,9 @@
 extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
 
-/* Set to 1 to enable marker debug output */
-static const int marker_debug;
+static int marker_debug;
+module_param(marker_debug, bool, 0);
+MODULE_PARM_DESC(marker_debug, "Set to 1 to enable marker debug output");
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin



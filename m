Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbZCFLOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbZCFLOB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbZCFLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:13:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:36680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZCFLNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:13:50 -0500
Message-ID: <49B10532.3020105@kernel.org>
Date: Fri, 06 Mar 2009 03:12:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make "memtest" like "memtest=17"
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: make boot command line memtest do one loop

so don't need to guess many pattern in one loop

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/mm/memtest.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/arch/x86/mm/memtest.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/memtest.c
+++ linux-2.6/arch/x86/mm/memtest.c
@@ -100,6 +100,9 @@ static int __init parse_memtest(char *ar
 {
 	if (arg)
 		memtest_pattern = simple_strtoul(arg, NULL, 0);
+	else
+		memtest_pattern = ARRAY_SIZE(patterns);
+
 	return 0;
 }
 

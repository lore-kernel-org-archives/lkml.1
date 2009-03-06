Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZCFLTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZCFLTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 06:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZCFLTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 06:19:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:39862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZCFLS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 06:18:59 -0500
Date: Fri, 6 Mar 2009 11:18:27 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B10532.3020105@kernel.org>
References: <49B10532.3020105@kernel.org>
Subject: [tip:x86/memtest] x86: make "memtest" like "memtest=17"
Message-ID: <tip-d1a8e7792047f7dca7eb5759250e2c12800bf262@git.kernel.org>
Git-Commit-ID: d1a8e7792047f7dca7eb5759250e2c12800bf262
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 11:18:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1a8e7792047f7dca7eb5759250e2c12800bf262
Gitweb:     http://git.kernel.org/tip/d1a8e7792047f7dca7eb5759250e2c12800bf262
Author:     "Yinghai Lu" <yinghai@kernel.org>
AuthorDate: Fri, 6 Mar 2009 03:12:50 -0800
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 12:16:43 +0100

x86: make "memtest" like "memtest=17"

Impact: make boot command line "memtest" do one loop by default

So don't need to guess many patterns in one loop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49B10532.3020105@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/mm/memtest.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index 0bcd788..605c8be 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -100,6 +100,9 @@ static int __init parse_memtest(char *arg)
 {
 	if (arg)
 		memtest_pattern = simple_strtoul(arg, NULL, 0);
+	else
+		memtest_pattern = ARRAY_SIZE(patterns);
+
 	return 0;
 }
 

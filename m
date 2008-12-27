Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYL0FGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYL0FGg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbYL0FG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:06:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:44640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYL0FG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:06:27 -0500
Message-ID: <4955B782.3030407@kernel.org>
Date: Fri, 26 Dec 2008 21:05:06 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       mingo@elte.hu
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: [PATCH] perf_counter: more barrier in blank weak function
References: <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org>
In-Reply-To: <20081226102716.GA31450@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix panic possible panic etc

some compiler seems to inline the weak global function if no line in it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7a79f3..37f7716 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -45,8 +45,8 @@ hw_perf_counter_init(struct perf_counter *counter)
 }
 
 u64 __weak hw_perf_save_disable(void)		{ return 0; }
-void __weak hw_perf_restore(u64 ctrl)		{ }
-void __weak hw_perf_counter_setup(void)		{ }
+void __weak hw_perf_restore(u64 ctrl)		{ barrier(); }
+void __weak hw_perf_counter_setup(void)		{ barrier(); }
 
 static void
 list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)

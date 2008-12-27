Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbYL0FIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbYL0FIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 00:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYL0FIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 00:08:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:44689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbYL0FIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 00:08:05 -0500
Message-ID: <4955B7EC.7050002@kernel.org>
Date: Fri, 26 Dec 2008 21:06:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
       mingo@elte.hu
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, mel@csn.ul.ie
Subject: [PATCH] kgdb: more barrier in blank weak function
References: <20081219105441.GA19750@linux.vnet.ibm.com> <86802c440812190351q3118516aif664dd5869c21b2a@mail.gmail.com> <20081219134636.GA11772@linux.vnet.ibm.com> <494C0BF0.3080109@kernel.org> <20081223132127.GA5450@linux.vnet.ibm.com> <495153A4.5060201@kernel.org> <20081224163400.GA11562@linux.vnet.ibm.com> <49529CE1.4040005@kernel.org> <20081226091217.GA5100@linux.vnet.ibm.com> <4954AC7B.3020603@kernel.org> <20081226102716.GA31450@uranus.ravnborg.org> <4955B782.3030407@kernel.org>
In-Reply-To: <4955B782.3030407@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix panic possible panic etc

some compiler seems to inline the weak global function if no line in it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index e4dcfb2..70d2e36 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -223,7 +223,7 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 void __weak
 kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
 {
-	return;
+	barrier();
 }
 
 /**
@@ -236,6 +236,7 @@ kgdb_post_primary_code(struct pt_regs *regs, int e_vector, int err_code)
  */
 void __weak kgdb_disable_hw_debug(struct pt_regs *regs)
 {
+	barrier();
 }
 
 /*

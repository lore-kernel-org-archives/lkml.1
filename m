Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbXJDLz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbXJDLz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXJDLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:55:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42115 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXJDLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:55:43 -0400
Date: Thu, 4 Oct 2007 13:55:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [patch] net, 9p: build fix with !CONFIG_SYSCTL
Message-ID: <20071004115526.GA27403@elte.hu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: net, 9p: build fix with !CONFIG_SYSCTL
From: Ingo Molnar <mingo@elte.hu>

found via make randconfig build testing: 

 net/built-in.o: In function `init_p9':
 mod.c:(.init.text+0x3b39): undefined reference to `p9_sysctl_register'
 net/built-in.o: In function `exit_p9':
 mod.c:(.exit.text+0x36b): undefined reference to `p9_sysctl_unregister'

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/net/9p/9p.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/include/net/9p/9p.h
===================================================================
--- linux.orig/include/net/9p/9p.h
+++ linux/include/net/9p/9p.h
@@ -412,6 +412,18 @@ int p9_idpool_check(int id, struct p9_id
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
+
+#ifdef CONFIG_SYSCTL
 int __init p9_sysctl_register(void);
 void __exit p9_sysctl_unregister(void);
+#else
+static inline int p9_sysctl_register(void)
+{
+	return 0;
+}
+static inline void p9_sysctl_unregister(void)
+{
+}
+#endif
+
 #endif /* NET_9P_H */

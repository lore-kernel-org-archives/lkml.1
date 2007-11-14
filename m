Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXKNDka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXKNDka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 22:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbXKNDkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 22:40:21 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:40671 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbXKNDkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 22:40:20 -0500
Date: Wed, 14 Nov 2007 14:40:19 +1100
To: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix build failure when CONFIG_INFINIBAND_IPOIB_CM is not defined.
Message-ID: <20071114034019.GI24243@bakeyournoodle.com>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes:
  CC [M]  drivers/infiniband/ulp/ipoib/ipoib_main.o
drivers/infiniband/ulp/ipoib/ipoib_main.c: In function ‘ipoib_init_module’:
drivers/infiniband/ulp/ipoib/ipoib_main.c:1269: error: invalid lvalue in assignment

In the case where CONFIG_INFINIBAND_IPOIB_CM is not defined ipoib_max_conn_qp is #defined to 0.

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>

---

 drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 623458e..aeb5a01 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1265,8 +1265,9 @@ static int __init ipoib_init_module(void)
 	ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
 	ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
 	ipoib_sendq_size = max(ipoib_sendq_size, IPOIB_MIN_QUEUE_SIZE);
-
+#ifdef CONFIG_INFINIBAND_IPOIB_CM
 	ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
+#endif
 
 	ret = ipoib_register_debugfs();
 	if (ret)

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

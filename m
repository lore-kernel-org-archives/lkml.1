Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbZCXJ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbZCXJ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZCXJ7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:59:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50729 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561AbZCXJ7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:59:24 -0400
Subject: [PATCH 1/2] kmemtrace: fix build breakage in mm/failslab.c
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:59:21 +0200
Message-Id: <1237888761.25315.69.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: fix build

This patch fixes up the following build breakage caused by commit
e251ea2fa52321009940fad02238ef1c369531ae ("rcu: don't include unnecessary
headers, allow kmemtrace w/ tracepoints"):

    CC      mm/failslab.o
  mm/failslab.c: In function ‘should_failslab’:
  mm/failslab.c:16: error: ‘__GFP_NOFAIL’ undeclared (first use in this function)
  mm/failslab.c:16: error: (Each undeclared identifier is reported only once
  mm/failslab.c:16: error: for each function it appears in.)
  mm/failslab.c:19: error: ‘__GFP_WAIT’ undeclared (first use in this function)
  make[1]: *** [mm/failslab.o] Error 1
  make: *** [mm] Error 2

Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/failslab.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/mm/failslab.c b/mm/failslab.c
index 7c6ea64..9339de5 100644
--- a/mm/failslab.c
+++ b/mm/failslab.c
@@ -1,4 +1,5 @@
 #include <linux/fault-inject.h>
+#include <linux/gfp.h>
 
 static struct {
 	struct fault_attr attr;
-- 
1.5.4.3




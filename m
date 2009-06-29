Return-Path: <linux-kernel-owner+w=401wt.eu-S1757683AbZF2Ixu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757683AbZF2Ixu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbZF2Ixl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:53:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZF2Ixl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:53:41 -0400
Message-ID: <4A488104.3080801@kernel.org>
Date: Mon, 29 Jun 2009 17:53:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH] percpu: use __weak only in the definition of weak percpu
 variables
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 08:53:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__weak is necessary only for definition and might even not work in
declaration.  Drop it from declaration.

This change was suggested by Ivan Kokshaysky.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
Committed to percpu#for-next.  Thanks.

 include/linux/percpu-defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index cf32838..9b7a53c 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -56,7 +56,7 @@
  */
 #define DECLARE_PER_CPU_SECTION(type, name, sec)			\
 	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
-	extern __PCPU_ATTRS(sec) __weak __typeof__(type) per_cpu__##name
+	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
 
 #define DEFINE_PER_CPU_SECTION(type, name, sec)				\
 	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
-- 
1.6.0.2


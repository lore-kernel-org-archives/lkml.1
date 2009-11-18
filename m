Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZKRJGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZKRJGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756346AbZKRJGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:06:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:60463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbZKRJGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:06:19 -0500
Message-ID: <4B03B8E5.7000706@kernel.org>
Date: Wed, 18 Nov 2009 18:05:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH percpu#for-next] percpu: remove compile warnings caused by
 __verify_pcpu_ptr()
References: <20091112174558.128cea97.sfr@canb.auug.org.au>
In-Reply-To: <20091112174558.128cea97.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If percpu pointer is const, __verify_pcpu_ptr() triggers warnings like
the following.

 drivers/net/loopback.c: In function 'loopback_get_stats':
 drivers/net/loopback.c:109: warning: initialization discards qualifiers from pointer target type

Fix it by adding const to the verification target pointer used in
__verify_pcpu_ptr().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
Sorry about the delay.  Patch committed to percpu#for-next.

Thanks.

 include/linux/percpu-defs.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 1fa36eb..68567c0 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -24,7 +24,7 @@
  * input parameter is a percpu pointer.
  */
 #define __verify_pcpu_ptr(ptr)	do {					\
-	void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
+	const void __percpu *__vpp_verify = (typeof(ptr))NULL;		\
 	(void)__vpp_verify;						\
 } while (0)

-- 
1.6.4.2


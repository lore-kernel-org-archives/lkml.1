Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbZDAGHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbZDAGHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 02:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbZDAGGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 02:06:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:60282 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZDAGGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 02:06:50 -0400
Message-ID: <49D30469.8020006@kernel.org>
Date: Wed, 01 Apr 2009 15:06:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86,percpu: fix inverted NUMA test in setup_pcpu_remap()
References: <20090331.223128.143365884.davem@davemloft.net> <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com>
In-Reply-To: <86802c440903312256r6ddbaa22o5c23cf85d83a6662@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 06:06:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setup_percpu_remap() is for NUMA machines yet it bailed out with
-EINVAL if pcpu_need_numa().  Fix the inverted condition.

This problem was reported by David Miller and verified by Yinhai Lu.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: David Miller <davem@davemloft.net>
Reported-by: Yinghai Lu <yinghai@kernel.org>
---
Oops, thanks for spotting it.  I don't have a numa machine so the
condition was never tested on actual machines.  :-)

 arch/x86/kernel/setup_percpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 400331b..876b127 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -162,7 +162,7 @@ static ssize_t __init setup_pcpu_remap(size_t static_size)
 	 * If large page isn't supported, there's no benefit in doing
 	 * this.  Also, on non-NUMA, embedding is better.
 	 */
-	if (!cpu_has_pse || pcpu_need_numa())
+	if (!cpu_has_pse || !pcpu_need_numa())
 		return -EINVAL;
 
 	last = NULL;

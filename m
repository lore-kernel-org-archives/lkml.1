Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbYGVUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbYGVUvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYGVUvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:51:40 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:54032 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYGVUvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:51:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kajFSQjtv77enDMhzNAgxy6jvHw5ja3GBlAWs+VJKbIi3mIQYt0SeIBxv9tVEV7ZMs
         eesKRyJILAAsledO0CGrePQx9aTWZLFut/mtkizVHQwIAE2BpyN+35Cs7m92V2wb+mFz
         jlRdsQ5caYliTkQke/mVi19xoJ4Lk1RPnQKf4=
Message-ID: <48864843.6030808@gmail.com>
Date: Tue, 22 Jul 2008 16:51:15 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, rml@tech9.net, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Test runtime rather than period in global_rt_runtime()
References: <488529B2.1080609@gmail.com> <1216717739.7257.94.camel@twins>
In-Reply-To: <1216717739.7257.94.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2008-07-21 at 20:28 -0400, roel kluin wrote:
>> Peter, you added the test in global_rt_runtime(), in commit
>> d0b27fa77854b149ad4af08b0fe47fe712a47ade
>> could you take a look at it and tell whether this test should
>> be replaced by something else?

>> -	if (sysctl_sched_rt_period < 0)

> Gah, I'm a moron. That should read:
> 
>   if (sysctl_sched_rt_runtime < 0)
---
Test runtime rather than period

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..a73c783 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -832,7 +832,7 @@ static inline u64 global_rt_period(void)
 
 static inline u64 global_rt_runtime(void)
 {
-	if (sysctl_sched_rt_period < 0)
+	if (sysctl_sched_rt_runtime < 0)
 		return RUNTIME_INF;
 
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;


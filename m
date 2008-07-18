Return-Path: <linux-kernel-owner+w=401wt.eu-S1753128AbYGREvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbYGREvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 00:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbYGREu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 00:50:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:7739 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYGREu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 00:50:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=WZ2WuDxobqIZIk4DGtX4xYYF8wea0A5qV/+kuMvxA6dEy4/5UTBJEvPLTq6fFcxITC
         veut0tFen2eSxOceDXbLw6vvEqYwLkUBFfO9gNVc7s1lyZBDBwMHW9cF7F8k3NnVHkOC
         eKDrT8JTIPvI0PFlZVLP9POOXzDx54j3V6hnw=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86: use cpu_clear in remove_cpu_from_maps
Date: Thu, 17 Jul 2008 21:50:23 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807172150.23463.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -1310,7 +1310,7 @@ static void __ref remove_cpu_from_maps(i
 	cpu_clear(cpu, cpu_callout_map);
 	cpu_clear(cpu, cpu_callin_map);
 	/* was set by cpu_init() */
-	clear_bit(cpu, (unsigned long *)&cpu_initialized);
+	cpu_clear(cpu, cpu_initialized);
 	numa_remove_cpu(cpu);
 }
 

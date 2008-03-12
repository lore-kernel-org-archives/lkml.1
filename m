Return-Path: <linux-kernel-owner+w=401wt.eu-S1751927AbYCLKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbYCLKDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYCLKDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:03:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:26072 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYCLKDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=YvkWvIHq4Y+wVUdawbaMIuV9XgNqg6kEh6kKRWH4CmwdQj5xs4q4Nr8uIc/sZtdHYS59MpyF1mbjFK+KNO6MDTtdWbKKi3RoIdACCMSYQc246nr2FNbmGX7KUs0CMpEcLnWOz+jfwSE94ADqHCR12e8J+L69/aU2bA5ngeJfUZ4=
Date: Wed, 12 Mar 2008 18:08:48 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -mm] x86 halt warning fix
Message-ID: <20080312100848.GA2768@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While halting kernel report warning at arch/x86/kernel/reboot.c : 424
fix the WARN_ON_ONCE param to ret

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
arch/x86/kernel/reboot.c |    2 +-
1 file changed, 1 insertion(+), 1 deletion(-)

diff -upr linux/arch/x86/kernel/reboot.c linux.new/arch/x86/kernel/reboot.c
--- linux/arch/x86/kernel/reboot.c	2008-03-12 17:56:48.000000000 +0800
+++ linux.new/arch/x86/kernel/reboot.c	2008-03-12 17:58:43.000000000 +0800
@@ -421,7 +421,7 @@ static void native_machine_shutdown(void
 
 		schedparm.sched_priority = 99;
 		ret = sched_setscheduler(current, SCHED_RR, &schedparm);
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(ret);
 
 		set_cpus_allowed(current, cpumask_of_cpu(reboot_cpu_id));
 	}

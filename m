Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZBPKyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZBPKyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbZBPKyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:54:11 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:51790 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZBPKyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HACrKVf8QVbBG1bfcnijQz/jXn+cYZotDj+5Nw/mdptudfQfRjaU9zzv5Ird4tNY7L
         81/RO+Tqn2z4kaX243wNpLL4wQq6IlXjDNNz2m0stoz78EFlasXD7munCZW60NXfOVti
         5ObNtrWvu+rBs2hEoZOTMQKro9XDsNOPdAgt8=
Date: Mon, 16 Feb 2009 18:54:21 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [Patch] sched: use TASK_NICE for task_struct
Message-ID: <20090216105421.GB23665@hack.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


#define TASK_NICE(p)            PRIO_TO_NICE((p)->static_prio)

So it's better to use TASK_NICE here.

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: Ingo Molnar <mingo@elte.hu>

---
diff --git a/kernel/sched.c b/kernel/sched.c
index c1d0ed3..a996bcc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5145,7 +5145,7 @@ SYSCALL_DEFINE1(nice, int, increment)
 	if (increment > 40)
 		increment = 40;
 
-	nice = PRIO_TO_NICE(current->static_prio) + increment;
+	nice = TASK_NICE(current) + increment;
 	if (nice < -20)
 		nice = -20;
 	if (nice > 19)


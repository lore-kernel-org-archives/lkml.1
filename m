Return-Path: <linux-kernel-owner+w=401wt.eu-S1751646AbZCMH5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbZCMH5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZCMH5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:57:19 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:56249 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZCMH5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xluPdFmkKQVGczfiX+RAR51Hvpd11BjdtOm77IKEPlCF9bFAi+iU5Kj5EfY0JoPvFD
         pQ+JH+uPCs24Kwhqxjcqc7y2+TevHYGRh624sA4p28TbsEVRnRdicwmRC/iIirixwNJa
         gAWZiD2DbmwuL1T8ZrZD7tSoaXq7W6xlsUw2M=
Date: Fri, 13 Mar 2009 15:56:58 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>,
       Markus Metzger <markus.t.metzger@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [Patch] ptrace: fix an unreachable statement
Message-ID: <20090313075622.GB8933@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit c2724775ce57c98b8af9694857b941dc61056516 put a statement after
return, which makes that statement unreachable.

Move that statement before return.

Cc: Markus Metzger <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 06ca07f..f7d38d6 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -690,9 +690,8 @@ static int ptrace_bts_config(struct task_struct *child,
 		if (!cfg.signal)
 			return -EINVAL;
 
-		return -EOPNOTSUPP;
-
 		child->thread.bts_ovfl_signal = cfg.signal;
+		return -EOPNOTSUPP;
 	}
 
 	if ((cfg.flags & PTRACE_BTS_O_ALLOC) &&


 

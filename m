Return-Path: <linux-kernel-owner+w=401wt.eu-S936021AbZAPRKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936021AbZAPRKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 12:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbZAPRKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 12:10:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:35349 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843AbZAPRKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 12:10:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:x-operating-system:user-agent:
	x-gmailtapped-by:x-gmailtapped;
	b=JicYeBv5f/hauDR7N9KLH5rpCwTGDeBVE/36/oyTVoMiHLDRI4t/SihXbt63xyHER
	V4TJfyW0aQaoF21SRwndg==
Date: Fri, 16 Jan 2009 09:09:38 -0800
From: Mandeep Singh Baines <msb@google.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, rientjes@google.com, mbligh@google.com,
       thockin@google.com
Subject: [PATCH] softlockup: fix to allow compiling with !DETECT_HUNG_TASK
Message-ID: <20090116170938.GA11346@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux/2.6.18.5-gg42workstation-mixed64-32 (x86_64)
User-Agent: Mutt/1.5.11
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: msb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> doesnt build with !SOFTLOCKUP:
> 
> kernel/fork.c:1049: error: 'struct task_struct' has no member named 'last_switch_count'
> kernel/fork.c:1050: error: 'struct task_struct' has no member named 'last_switch_timestamp'
> 
> Could you send a delta fix patch relative to -v4 please? Thanks,
> 
> 	Ingo

Oops. Will be more careful next time.

---

Fixes the following compile error:

kernel/fork.c:1049: error: 'struct task_struct' has no member named 'last_switch_count'
kernel/fork.c:1050: error: 'struct task_struct' has no member named 'last_switch_timestamp'

Signed-off-by: Mandeep Singh Baines <msb@google.com>
---
 kernel/fork.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index fb1f5e9..d68e59b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1045,7 +1045,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	p->default_timer_slack_ns = current->timer_slack_ns;
 
-#ifdef CONFIG_DETECT_SOFTLOCKUP
+#ifdef CONFIG_DETECT_HUNG_TASK
 	p->last_switch_count = 0;
 	p->last_switch_timestamp = 0;
 #endif
-- 
1.5.4.5


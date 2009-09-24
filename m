Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbZIXVHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbZIXVHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbZIXVHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:07:53 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:3811 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZIXVHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:07:53 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAI98u0qrR7PD/2dsb2JhbAC+TYhTAZAIBYQc
X-IronPort-AV: E=Sophos;i="4.44,447,1249257600"; 
   d="scan'208";a="246602136"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] hrtimer: Remove overly verbose "switch to high res mode" message
References: <adavdj92sso.fsf@cisco.com> <adar5tx2s9d.fsf@cisco.com>
	<20090924093800.GA23158@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 24 Sep 2009 14:07:55 -0700
In-Reply-To: <20090924093800.GA23158@elte.hu> (Ingo Molnar's message of "Thu,
	24 Sep 2009 11:38:00 +0200")
Message-ID: <ada1vlw126s.fsf_-_@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 24 Sep 2009 21:07:56.0453 (UTC) FILETIME=[16A23D50:01CA3D5B]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On big systems, printing <number of CPUs> copies of

    Switched to high resolution mode on CPU nnn

clutters up the kernel log for minimal gain.  Just get rid of them.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 > Yeah. The switched-to message could be eliminated altogether.

easy enough...

 kernel/hrtimer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e5d98ce..4267279 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -720,8 +720,6 @@ static int hrtimer_switch_to_hres(void)
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
-	printk(KERN_DEBUG "Switched to high resolution mode on CPU %d\n",
-	       smp_processor_id());
 	return 1;
 }
 

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXLAScc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXLAScc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXLAScU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:32:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:36577 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbXLAScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:32:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=jUc4kpTWJBal73WrAzKCTE8XQQJ3NzCMNme18OPJnxieYop+fQXymyvDWb0ah6//8
	gq6oNouqR5/MTL9w4pQvg==
Date: Sat, 1 Dec 2007 10:31:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
In-Reply-To: <20071201092037.GA32544@elte.hu>
Message-ID: <alpine.DEB.0.9999.0712011031230.9694@chino.kir.corp.google.com>
References: <20071201092037.GA32544@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checked auto variable isn't doing anything in
check_hung_uninterruptible_tasks().

Signed-off-by: David Rientjes <rientjes@google.com>
---
 kernel/softlockup.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/softlockup.c b/kernel/softlockup.c
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -170,7 +170,6 @@ static void check_hung_uninterruptible_tasks(int this_cpu)
 	int max_count = sysctl_hung_task_check_count;
 	unsigned long now = get_timestamp(this_cpu);
 	struct task_struct *g, *t;
-	int checked = 0;
 
 	/*
 	 * If the system crashed already then all bets are off,
@@ -183,10 +182,8 @@ static void check_hung_uninterruptible_tasks(int this_cpu)
 	do_each_thread(g, t) {
 		if (!--max_count)
 			break;
-		if (t->state & TASK_UNINTERRUPTIBLE) {
+		if (t->state & TASK_UNINTERRUPTIBLE)
 			check_hung_task(t, now);
-			checked++;
-		}
 	} while_each_thread(g, t);
 
 	read_unlock(&tasklist_lock);

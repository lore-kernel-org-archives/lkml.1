Return-Path: <linux-kernel-owner+w=401wt.eu-S1762994AbYCUWuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762994AbYCUWuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762778AbYCUWqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:46:32 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34764 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762765AbYCUWqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:46:30 -0400
Message-Id: <20080321224446.779071450@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michal Schmidt <mschmidt@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [patch 65/76] sched_nr_migrate wrong mode bits
Content-Disposition: inline; filename=sched_nr_migrate-wrong-mode-bits.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michal Schmidt <mschmidt@redhat.com>

sched_nr_migrate has strange permission bits:

 $ ls -l /proc/sys/kernel/sched_nr_migrate
 --w----r-T 1 root root 0 2008-03-17 23:31 /proc/sys/kernel/sched_nr_migrate

The bug is an obvious decimal/octal confusion.

Fixed (collaterally) in Linus's tree by Peter Zijlstra with commit fa85ae241
"sched: rt time limit" (in 2.6.25-rc1).

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -306,7 +306,7 @@ static struct ctl_table kern_table[] = {
 		.procname	= "sched_nr_migrate",
 		.data		= &sysctl_sched_nr_migrate,
 		.maxlen		= sizeof(unsigned int),
-		.mode		= 644,
+		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
 #endif

-- 

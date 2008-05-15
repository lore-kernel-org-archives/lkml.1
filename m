Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbYEONDE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbYEONDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 09:03:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751042AbYEONCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 09:02:54 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:44501 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYEONCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 09:02:53 -0400
Date: Thu, 15 May 2008 18:34:59 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: [PATCH] sched: Improve readability in update_cpu_load() code
Message-ID: <20080515130459.GA9650@in.ibm.com>
Reply-To: ego@in.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Author: Gautham R Shenoy <ego@in.ibm.com>
Date:   Thu May 15 17:55:49 2008 +0530

    sched: Improve readability in update_cpu_load() code
    
    Currently the cpu_load[i] is calculated as:
    	this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
    
    However, since scale = 2^i, this can be simplified as:
    	this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);
    
    Makes it easier to read.
    Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index 2d7d8f1..e1a6985 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2921,7 +2921,7 @@ static void update_cpu_load(struct rq *this_rq)
 		 */
 		if (new_load > old_load)
 			new_load += scale-1;
-		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
+		this_rq->cpu_load[i] = old_load + ((new_load - old_load) >> i);
 	}
 }
 
-- 
Thanks and Regards
gautham

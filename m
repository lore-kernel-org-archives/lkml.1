Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbXC2EIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbXC2EIr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 00:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXC2EIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 00:08:47 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:32970 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbXC2EIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 00:08:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: g3vbv@blueyonder.co.uk
Cc: Adrian Bunk <bunk@stusta.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, auxsvr@gmail.com
Subject: Re: 2.6.21-rc1 and 2.6.21-rc2 kwin dies silently
References: <45E59D64.3070202@blueyonder.co.uk>
	<200702281805.13822.auxsvr@gmail.com>
	<20070307214730.87859590.akpm@linux-foundation.org>
	<45EFBC73.2030005@blueyonder.co.uk>
	<46016EAF.6010801@blueyonder.co.uk> <20070321193420.GP752@stusta.de>
	<m17itabbbv.fsf@ebiederm.dsl.xmission.com>
	<4601DCB4.4060804@blueyonder.co.uk>
	<20070321184258.758a5a29.randy.dunlap@oracle.com>
	<20070322105908.GS752@stusta.de> <4608919C.4050007@blueyonder.co.uk>
	<m1y7liyeyt.fsf@ebiederm.dsl.xmission.com>
	<4609E04D.408@blueyonder.co.uk>
Date: Wed, 28 Mar 2007 22:04:16 -0600
In-Reply-To: <4609E04D.408@blueyonder.co.uk> (Sid Boyce's message of "Wed, 28
	Mar 2007 04:26:05 +0100")
Message-ID: <m1r6r8n1a7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sid I think I have found the problem. Could you try the following patch. 
I believe I accidentally switched the sense of a test....

diff --git a/kernel/exit.c b/kernel/exit.c
index f132349..b55ed4c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -790,7 +790,7 @@ static void exit_notify(struct task_struct *tsk)
 	
 	pgrp = task_pgrp(tsk);
 	if ((task_pgrp(t) != pgrp) &&
-	    (task_session(t) != task_session(tsk)) &&
+	    (task_session(t) == task_session(tsk)) &&
 	    will_become_orphaned_pgrp(pgrp, tsk) &&
 	    has_stopped_jobs(pgrp)) {
 		__kill_pgrp_info(SIGHUP, SEND_SIG_PRIV, pgrp);



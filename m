Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbZKCVqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbZKCVqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZKCVqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:46:13 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58337 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbZKCVqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:46:12 -0500
Date: Wed, 4 Nov 2009 03:15:44 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Balbir Singh <balbir@in.ibm.com>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: sched: Add USER_SCHED to feature removal list
Message-ID: <20091103214544.GI5495@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sched: Add USER_SCHED to feature removal list

Peter Zijlstra suggested that we remove USER_SCHED at
http://lkml.org/lkml/2009/3/21/67 . Removing USER_SCHED removes a
lot of code from the scheduler and simplifies the code.

We already have the ability to do user based classification which
is tightened using PAM in userspace.

Schedule USER_SCHED for removal in 2.6.34

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
---
 Documentation/feature-removal-schedule.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt
+++ linux-2.6/Documentation/feature-removal-schedule.txt
@@ -6,6 +6,21 @@ be removed from this file.
 
 ---------------------------
 
+What:	USER_SCHED
+When:	2.6.34
+
+Why:	USER_SCHED was implemented as a proof of concept for group scheduling.
+	The effect of USER_SCHED can already be achieved from userspace with
+	the help of libcgroup. The removal of USER_SCHED will also simplify
+	the scheduler code with the removal of one major ifdef. There are also
+	issues USER_SCHED has with USER_NS. A decision was taken not to fix
+	those and instead remove USER_SCHED. Also new group scheduling
+	features will not be implemented for USER_SCHED.
+
+Who:	Dhaval Giani <dhaval@linux.vnet.ibm.com>
+
+---------------------------
+
 What:	PRISM54
 When:	2.6.34
 
-- 
regards,
Dhaval

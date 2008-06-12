Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbYFLUhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbYFLUhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:37:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbYFLUh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:37:27 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45771 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756129AbYFLUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:37:26 -0400
Date: Thu, 12 Jun 2008 15:37:19 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Paul Menage <menage@google.com>, Dan Smith <danms@us.ibm.com>
Subject: Re: [PATCH] cgroup_clone: use pid of newly created task for new
	cgroup
Message-ID: <20080612203719.GA20755@us.ibm.com>
References: <20080611193540.GC13365@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611193540.GC13365@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> cgroup_clone creates a new cgroup with the pid of the task.  This works
> correctly for unshare, but for clone cgroup_clone is called from
> copy_namespaces inside copy_process, which happens before the new pid
> is created.  As a result, the new cgroup was created with current's pid.
> This patch:

"I swear it worked yesterday..."  but in any case this fix is needed on
top of the cgroup_clone patch

-serge

>From 8819a1f0e4e5ae9950b8310144b3fda2c30cab08 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@us.ibm.com>
Date: Thu, 12 Jun 2008 15:33:38 -0500
Subject: [PATCH] ns_cgroup: include proc_fs.h

Need proc_fs.h included to slurp the PROC_NUMBUF #define.

Signed-off-by: Serge Hallyn <serge@us.ibm.com>
---
 kernel/ns_cgroup.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/ns_cgroup.c b/kernel/ns_cgroup.c
index 6431fb7..d6895d0 100644
--- a/kernel/ns_cgroup.c
+++ b/kernel/ns_cgroup.c
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/nsproxy.h>
+#include <linux/proc_fs.h>
 
 struct ns_cgroup {
 	struct cgroup_subsys_state css;
-- 
1.5.4.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1752193AbZH1Szw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbZH1Szw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbZH1Szv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:55:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbZH1Szu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:55:50 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 1/9] task_struct: add PF_NONOTIFY for fanotify to use
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Cc: davem@davemloft.net, viro@zeniv.linux.org.uk, alan@linux.intel.com,
       hch@infradead.org
Date: Fri, 28 Aug 2009 14:55:42 -0400
Message-ID: <20090828185542.8014.22791.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fanotify opens file descriptors inside the kernel for it's listeners
it needs a way to make sure that 2 fanotify listeners, both which listen to
open events do not continuously see each others open events (and get into a
livelock reporting on each other's activity).  This fix is to create a new
tast_struct flags called PF_NONOTIFY.  If this flag is set in a task no
fanotify events will be generated for that task.   fanotify will set the
flag before and open call and will clear it immediately after.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/sched.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b88872f..3c1ce66 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1695,6 +1695,7 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
+#define PF_NONOTIFY	0x00000020	/* In fanotify open operation */
 #define PF_FORKNOEXEC	0x00000040	/* forked but didn't exec */
 #define PF_MCE_PROCESS  0x00000080      /* process policy on mce errors */
 #define PF_SUPERPRIV	0x00000100	/* used super-user privileges */


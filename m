Return-Path: <linux-kernel-owner+w=401wt.eu-S1764379AbYEASgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764379AbYEASgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761127AbYEASgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:36:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37865 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002AbYEASgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:36:01 -0400
Date: Thu, 1 May 2008 13:35:59 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morgan <morgan@kernel.org>, linux-security-module@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH] capabilities: add bounding set to /proc/self/status
Message-ID: <20080501183559.GA21279@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no way to query the bounding set of another
task.  As there appears to be no security reason not to, and
as Michael Kerrisk points out the following valid reasons to do
so exist:

* consistency (I can see all of the other per-thread/process sets in
/proc/.../status)
* debugging -- I could imagine that it would make the job of debugging
an application that uses capabilities a little simpler.

this patch adds the bounding set to /proc/self/status right after
the effective set.

If at all possible (and if acked by Andrew Morgan) it would be nice to
get this into the 2.6.26 cycle.  But I realize it probably is too late
for that.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
---
 fs/proc/array.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c135cbd..160dd4a 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -297,6 +297,7 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 	render_cap_t(m, "CapInh:\t", &p->cap_inheritable);
 	render_cap_t(m, "CapPrm:\t", &p->cap_permitted);
 	render_cap_t(m, "CapEff:\t", &p->cap_effective);
+	render_cap_t(m, "CapBnd:\t", &p->cap_bset);
 }
 
 static inline void task_context_switch_counts(struct seq_file *m,
-- 
1.5.3.6


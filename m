Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYHBLbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYHBLbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 07:31:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYHBLbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 07:31:35 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:33892 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbYHBLbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 07:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KLR2vTqQsagDKNn7c9RRftGQLiTfD3CO6RmPruoEXMwmP5/xK1lJHghoyIKiPTJ11a
         7q8eZrsBjW3Tk/uzeUsLUMyOvVmtY3NeEsjzvNcMXgUxunba4+gCC8tN36uh77nhvKDs
         dmGyATyzyTjgXWhIpdwNdQsx6qyrf5yEjUyJ4=
Date: Sat, 2 Aug 2008 15:31:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, pj@sgi.com
Subject: [PATCH 2/2] cpuset: use seq_cpumask(), seq_nodemask()
Message-ID: <20080802113131.GB3536@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks might want to boot with NR_CPUS=4096 and see what happens,
m->count games don't look promising. :-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/cpuset.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2392,16 +2392,14 @@ const struct file_operations proc_cpuset_operations = {
 void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task)
 {
 	seq_printf(m, "Cpus_allowed:\t");
-	m->count += cpumask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->cpus_allowed);
+	seq_cpumask(m, &task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Cpus_allowed_list:\t");
 	m->count += cpulist_scnprintf(m->buf + m->count, m->size - m->count,
 					task->cpus_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed:\t");
-	m->count += nodemask_scnprintf(m->buf + m->count, m->size - m->count,
-					task->mems_allowed);
+	seq_nodemask(m, &task->mems_allowed);
 	seq_printf(m, "\n");
 	seq_printf(m, "Mems_allowed_list:\t");
 	m->count += nodelist_scnprintf(m->buf + m->count, m->size - m->count,
-- 
1.5.3.7



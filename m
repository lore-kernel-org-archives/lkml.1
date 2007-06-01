Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXFAKub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXFAKub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 06:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXFAKuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 06:50:23 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:37533 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFAKuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 06:50:22 -0400
From: Srinivasa Ds <srinivasa@in.ibm.com>
Organization: IBM
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] cpuset operations causes Badness at mm/slab.c:777 warning
Date: Fri, 1 Jun 2007 16:20:05 +0530
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dinakar Guniguntala <dino@in.ibm.com>, pj@sgi.com, simon.derr@bull.net,
       clameter@sgi.com, clameter@cthulhu.engr.sgi.com, rientjes@google.com
References: <465FCA79.70207@in.ibm.com>
In-Reply-To: <465FCA79.70207@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011620.05756.srinivasa@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007 12:57:53 Srinivasa Ds wrote:

I have modified the patch little bit, Thanks Vatsa for input and hence 
resending it. Please let me know your comments on this.

Signed-off-by: Srinivasa DS <srinivasa@in.ibm.com>

---
 kernel/cpuset.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

Index: linux-2.6.22-rc3/kernel/cpuset.c
===================================================================
--- linux-2.6.22-rc3.orig/kernel/cpuset.c
+++ linux-2.6.22-rc3/kernel/cpuset.c
@@ -1741,6 +1741,13 @@ static int cpuset_tasks_open(struct inod
 	 * show up until sometime later on.
 	 */
 	npids = atomic_read(&cs->count);
+	if (!npids) {
+		ctr->buf = NULL;
+		ctr->bufsz = 0;
+		file->private_data = ctr;
+		return 0;
+	}
+
 	pidarray = kmalloc(npids * sizeof(pid_t), GFP_KERNEL);
 	if (!pidarray)
 		goto err1;
@@ -1772,6 +1779,9 @@ static ssize_t cpuset_tasks_read(struct 
 {
 	struct ctr_struct *ctr = file->private_data;
 
+	if (!ctr->buf)     /* No tasks in this cpuset */
+		return 0;
+
 	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
 }
 



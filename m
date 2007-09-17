Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXIQVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXIQVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760296AbXIQVH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:07:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbXIQVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:07:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=AofBrgR1mMoIZNQbgIdNkB1d00PHagrpibMDXfwa+0Lg/s4f/FF8Q1Cv2oLG/STNU
	rpuzU5tw5S2g1fRPaT6tA==
Message-Id: <20070917210428.544334000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:22 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/33] task-containersv11-add-container_clone-interface-cgroups-fix-refcount-bug
Content-Disposition: inline; filename=fixoops2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updates cgroup_clone() to use lookup_one_len() rather than
cgroup_get_dentry(). Originally part of
task-cgroupsv11-basic-task-cgroup-framework-cgroups-fix-refcount-bug
but split out by akpm for the -mm tree.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-rc4-mm1-new/kernel/cgroup.c
===================================================================
--- linux-2.6.23-rc4-mm1-new.orig/kernel/cgroup.c
+++ linux-2.6.23-rc4-mm1-new/kernel/cgroup.c
@@ -2577,7 +2577,7 @@ int cgroup_clone(struct task_struct *tsk
 	/* Hold the parent directory mutex across this operation to
 	 * stop anyone else deleting the new cgroup */
 	mutex_lock(&inode->i_mutex);
-	dentry = cgroup_get_dentry(parent->dentry, nodename);
+	dentry = lookup_one_len(nodename, parent->dentry, strlen(nodename));
 	if (IS_ERR(dentry)) {
 		printk(KERN_INFO
 		       "Couldn't allocate dentry for %s: %ld\n", nodename,

--

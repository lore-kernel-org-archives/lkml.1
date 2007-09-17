Return-Path: <linux-kernel-owner+w=401wt.eu-S1760553AbXIQVJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760553AbXIQVJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbXIQVHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:07:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52068 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695AbXIQVHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:07:05 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=vIcg6UTHbxW00zyN0R6kyuh2frPQlHdxWGdQlPoEIG28+w70dqYPL8f3hyrJmk7/G
	wTcZTxtToCXuHaDamWwDw==
Message-Id: <20070917210426.415625000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:09 -0700
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
Subject: [PATCH 02/33] task containersv11 basic task container framework fix
Content-Disposition: inline; filename=task-containersv11-basic-task-container-framework-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle reading /proc/self/cpuset when cpusets isn't mounted.

Signed-off-by: Paul Menage <menage@google.com>

---

 kernel/cgroup.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN kernel/cgroup.c~task-cgroupsv11-basic-task-cgroup-framework-fix kernel/cgroup.c
--- a/kernel/cgroup.c~task-cgroupsv11-basic-task-cgroup-framework-fix
+++ a/kernel/cgroup.c
@@ -683,6 +683,15 @@ int cgroup_path(const struct containe
 {
 	char *start;
 
+	if (cont == dummytop) {
+		/*
+		 * Inactive subsystems have no dentry for their root
+		 * cgroup
+		 */
+		strcpy(buf, "/");
+		return 0;
+	}
+
 	start = buf + buflen;
 
 	*--start = '\0';
_

--

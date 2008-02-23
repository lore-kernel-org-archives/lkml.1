Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbYBWX3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbYBWX3q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYBWX1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:27:50 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5174 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198AbYBWX1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:27:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=CSHh/y8REdmY4CjFLEl84Zdn4Rbbu4IEN5NdGUi14TsRCkuLAzpZpW+wv4lkm3470
	6qwF+fIvGdgOe2LD88ReQ==
Message-Id: <20080223232617.795230000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:29 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 04/10] CGroup API files: Strip all trailing whitespace in cgroup_write_u64
Content-Disposition: inline; filename=cgroup_write_uint_strstrip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the need for people to remember to pass the -n flag to
echo when writing values to cgroup control files.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cgroup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: cgroup-2.6.25-rc2-mm1/kernel/cgroup.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/kernel/cgroup.c
+++ cgroup-2.6.25-rc2-mm1/kernel/cgroup.c
@@ -1321,10 +1321,7 @@ static ssize_t cgroup_write_u64(struct c
 		return -EFAULT;
 
 	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
+	strstrip(buffer);
 	val = simple_strtoull(buffer, &end, 0);
 	if (*end)
 		return -EINVAL;

--

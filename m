Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZAIQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZAIQO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZAIQOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:14:49 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531AbZAIQOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:14:48 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] CRED: Must initialise the new creds in
	prepare_kernel_cred()
To: torvalds@osdl.org, jmorris@namei.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, steved@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Fri, 09 Jan 2009 16:13:46 +0000
Message-ID: <20090109161346.13371.62067.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090109161341.13371.24540.stgit@warthog.procyon.org.uk>
References: <20090109161341.13371.24540.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly allocated creds in prepare_kernel_cred() must be initialised before
get_uid() and get_group_info() can access them.  They should be copied from
the old credentials.

Reported-by: Steve Dickson <steved@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
---

 kernel/cred.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 400e608..3a03918 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -507,6 +507,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 	else
 		old = get_cred(&init_cred);
 
+	*new = *old;
 	get_uid(new->user);
 	get_group_info(new->group_info);
 

